//===-- Allocation.cpp ------------------------------------------*- C++ -*-===//
//
// This file is distributed under the LegUp license. See LICENSE for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements the Allocation object
//
//===----------------------------------------------------------------------===//

#include "Allocation.h"
#include "Ram.h"
#include "Binding.h"
#include "BipartiteWeightedMatchingBinding.h"
#include "utils.h"
#include "LegupConfig.h"
#include "FiniteStateMachine.h"
#include "Debug.h"
//#include "../lib/VMCore/ConstantsContext.h"
#include "../lib/IR/ConstantsContext.h"
#include <iostream>
#include <iomanip>
#include <cstdio>
#include "llvm/Support/FileSystem.h"
#include "PointerAnalysis.h"

using namespace llvm;
using namespace legup;

namespace legup {

// x * 10 is equivalent to:
// = x * (2^3 + 2)
// = (x << 3) + (x << 1)
// quartus will not infer a DSP if a multiply by constant
// can be replaced by shifts (which are free) and at most one addition
// to see if this is possible:
// 1) calculate the closest power of two
// 2) can get there by adding/subtracting x or (x << n)?
bool canReplaceMultiplyByConstantWithShiftAdd(uint64_t multiplierInput) {
    uint64_t closestPower2, diff, l, addPower2, newdiff;
    int debug = 0;

    if (LEGUP_CONFIG->getParameterInt("MULT_BY_CONST_INFER_DSP")) {
        return false;
    }

    if (debug) printf("multiplierInput: %ld\n", multiplierInput);
    l = log2((double)multiplierInput)+0.5;
    if (debug) printf("log2(multiplierInput): %ld\n", l);
    closestPower2 = pow(2,l);
    if (debug) printf("closestPower2: %ld\n", closestPower2);
    diff = labs(multiplierInput-closestPower2);
    if (debug) printf("diff=abs(multiplierInput-pow2): %ld\n", diff);
    // multiplierInput is a power
    if (diff == 0) return true;

    // within one addition/subtraction of multiplierInput << x
    l = log2((double)diff)+0.5;
    if (debug) printf("log2(multiplierInput): %ld\n", l);
    addPower2 = pow(2,l);
    if (debug) printf("addPower2: %ld\n", addPower2);
    newdiff = labs(diff-addPower2);
    if (debug) printf("newdiff=abs(diff-addPower2): %ld\n", newdiff);
    if (newdiff == 0) return true;

    if (debug) printf("%ld will infer a DSP\n", multiplierInput);
    return false;
}

// determines when a signal comes from the memory controller output
// for instance in this case %113 comes from memory:
//  %112 = load i16* %111, align 2, !tbaa !0
//  %113 = sext i16 %112 to i32
bool from_memory_controller(Value *value) {
    if (isa<SExtInst>(value) || isa<ZExtInst>(value)) {
        Instruction *ext = dyn_cast<Instruction>(value);
        Value *op = ext->getOperand(0);
        if (isa<LoadInst>(op)) {
            return true;
        }
    }
    return false;
}

// detect multipliers with identical inputs:
// 1) a shared input
// 2) one input coming from the memory controller (second shared input)
// note: commutativity matters for multiply
void Allocation::detect_multipliers_with_identical_inputs() {
    map<pair<Value*, Value*>, Instruction*> multiplier_shared;
    // using the NULL pointer as a placeholder for memory controller
    Value *mem_controller = 0;

    for (Module::iterator F = module->begin(), E = module->end(); F != E; ++F) {

        multiplier_shared.clear();
        for (Function::iterator b = F->begin(), be = F->end(); b != be; ++b) {
            for (BasicBlock::iterator I = b->begin(), ie = b->end(); I
                    != ie; ++I) {
                if (!isMul(I)) continue;
                Value *vop0 = I->getOperand(0);
                Value *vop1 = I->getOperand(1);
                if (from_memory_controller(vop0)) vop0 = mem_controller;
                if (from_memory_controller(vop1)) vop1 = mem_controller;

                pair<Value *, Value*> key(vop0, vop1);
                if (multiplier_shared.find(key) != multiplier_shared.end()) {
                    same_inputs[F].insert(I);
                    same_inputs[F].insert(multiplier_shared[key]);
                    //errs() << "Detected identical inputs:\n";
                    //errs() << *I << "\n";
                    //errs() << *multiplier_shared[key] << "\n";
                }
                multiplier_shared[key] = I;
            }
        }
    }
}

Allocation::Allocation(Module *M)
    : genericRAMs(false), module(M), dataSize(0),
      memoryFile("memory.legup.rpt", FileError, llvm::sys::fs::F_None),
      bindingFile("binding.legup.rpt", FileError, llvm::sys::fs::F_None),
      patternFile("patterns.legup.rpt", FileError, llvm::sys::fs::F_None),
      schedulingFile("scheduling.legup.rpt", FileError, llvm::sys::fs::F_None),
      multipumpingFile("multipumping.legup.rpt", FileError,
                       llvm::sys::fs::F_None),
      pipelineDotFile("pipeline.dot", FileError, llvm::sys::fs::F_None),
      pipeliningRTLFile("pipelining.rtl.legup.rpt", FileError,
                        llvm::sys::fs::F_None),
      TimingReportFile("timingReport.legup.rpt", FileError,
                       llvm::sys::fs::F_None),
      generateRTLFile("generateRTL.legup.rpt", FileError,
                      llvm::sys::fs::F_None) {

    assert(FileError.empty() && "Error opening log files");
    TD = new DataLayout(module);

    pipelineDotFile << getFileHeader();
    memoryFile << getFileHeader();
    bindingFile << getFileHeader();
    patternFile << getFileHeader();
    schedulingFile << getFileHeader();
    multipumpingFile << getFileHeader();
    pipeliningRTLFile << getFileHeader();
    generateRTLFile << getFileHeader();
    TimingReportFile << getFileHeader();

    // first 2 tags are reserved for processor memory and the null pointer
    ramTagNum = 2;

    allocateGlobalVarRAMs();

    allocateStackRAMs();

    if (LEGUP_CONFIG->getParameterInt("LOCAL_RAMS")) {
        runPointsToAnalysis();

        allocateLocalRAMs();
    }

    allocatePhysicalRAMs();

//    genericRAMs = structsExistInCode();
	genericRAMs = true;

    detect_multipliers_with_identical_inputs();

    propagatingSignals = new PropagatingSignals();

    dbgInfo = new LegUpDebugInfo(this);
}

//NC changes...
int Allocation::getRamTagNum(RAM* ram) {
    return mapRamTag[ram];
}
//

GenerateRTL *Allocation::createGenerateRTL(Function *F) {
    GenerateRTL *HW = new GenerateRTL(this, F);

    mapFctModule[F] = HW;
    hwList.push_back(HW);

    return HW;
}

// get ram tag number, needed for initializing constant pointers
int Allocation::getRamTagNum(const Value * op) {
    RAM* r = getRAM(op);

    return mapRamTag[r];
}

std::string Allocation::verilogName(const Value *val) {
    const Value *value = val;
     return globalScope.verilogName(value);
}

std::string Allocation::verilogNameFunction(const Value *val, Function *F) {
    assert(F);
    // keep global updated

    const Value *value = val;
    globalScope.verilogName(value);
    return functionScope[F].verilogName(value);

}

RAM* Allocation::getRAM(const Value *I) {

    if (mapValueRam.find(I) == mapValueRam.end()) {
        errs() << "getRam: " << *I << "\n";

        errs() << "RAM not defined for: " << I->getName() << "\n";
    }
    assert (mapValueRam.find(I) != mapValueRam.end());

    return mapValueRam[I];
}

RAM* Allocation::allocateRAM(const Value *I) {

    formatted_raw_ostream out(getMemoryFile());
    out << "allocateRAM: " << getLabel(I) << "\n";

    assert (mapValueRam.find(I) == mapValueRam.end());

    RAM *r = new RAM(I, this);
    assert(r);

    bool isConstant = false;
    if (const GlobalVariable *G = dyn_cast<GlobalVariable>(I)) {
        isConstant = G->isConstant();
    }
    out << "Constant: " << isConstant << "\n";
    r->setROM(isConstant);

    ramList.push_back(r);

    mapValueRam[I] = r;

    // reserve name (avoid _var### for rams)
    verilogName(I);

    // check if this RAM is used in a parallel function
    // then set the number of instances for this ram accordingly
    // there is one instance for each thread
    if (const Instruction *ins = dyn_cast<Instruction>(I)) {

        const Function *F = ins->getParent()->getParent();
        unsigned numInstances;
        // if not found previously
        if (functionNumInstances.find(F) == functionNumInstances.end()) {
            std::set<const Function*> visited;            
            // get the number of instances
            numInstances = getNumInstancesforFunction(1, F, visited);
            // store into map
            functionNumInstances[F] = numInstances;
        } else {
            numInstances = functionNumInstances[F]; 
        }
        DEBUG(errs() << "Allocating " << numInstances << 
                " of RAM for instruction " << ins->getName() <<
                "in function " << F->getName() << "\n");               
        r->setNumInstances(numInstances);
    }

    return r;
}

void Allocation::addGlobalDefines() {
    // extra tag for the NULL tag
    unsigned tagSize = requiredBits(getNumRAMs() + 1);

    // tag size should always be 8
    assert(tagSize <= getTagSize());
    tagSize = getTagSize();

    setDefine("MEMORY_CONTROLLER_TAG_SIZE", utostr(tagSize),
              "Number of RAM elements: " + utostr(getNumRAMs()));

    dataSize = (usesGenericRAMs()) ? 64 : 32;

    if (!LEGUP_CONFIG->isHybridFlow()) {
        for (Allocation::const_ram_iterator i = ram_begin(), e = ram_end();
		        i != e; ++i) {
		    RAM *R = *i;

            // don't need TAGs for local RAMs
            if (isLocalFunctionRam.find(R) != isLocalFunctionRam.end()) continue;

            std::string tmp;
            raw_string_ostream Out(tmp);
            Out << getValueStr(R->getValue());
            defineCommentList[R->getTag()] = Out.str();

            // there are multiple TAGs if RAM is used
            // by multiple threads
            unsigned numInstances = R->getNumInstances();
            int tagIndex = mapRamTag[R];
            for (unsigned i = 0; i < numInstances; ++i) {

                std::string tagName = R->getTag();
                if (numInstances != 1)            
                    tagName += "_inst" + utostr(i);            

                defineList[tagName] = "`MEMORY_CONTROLLER_TAG_SIZE'd" + utostr(tagIndex);
                tagIndex++;
            }
               
            dataSize = std::max(dataSize, R->getDataWidth());
            defineList[R->getTagAddrName()] = R->getTagAddr();
		}
	}
    if (LEGUP_CONFIG->isPCIeFlow()) {
	defineList["MEMORY_CONTROLLER_ADDR_SIZE"] = "32";
    }
    else {
	defineList["MEMORY_CONTROLLER_ADDR_SIZE"] =
	    utostr((int)getDataLayout()->getPointerSizeInBits());
    }
    defineList["MEMORY_CONTROLLER_DATA_SIZE"] = utostr(dataSize);
}

bool Allocation::structsExistInCode() {
    for (std::map<const Value*, RAM*>::iterator i =
            mapValueRam.begin(), e = mapValueRam.end(); i != e; ++i) {
        RAM *R = i->second;
        if (R->isStruct()) {
            return true;
        }
    }

    return false;
}

RTLModule *Allocation::getModuleForFunction(const Function *f) {

    std::map<const Function *, RTLModule *>::iterator mod = modulesForFunctions.find(f);

    // If this function is called for a function that hasn't been paired with
    // a module then there is some kind of error.
    //
    assert(mod != modulesForFunctions.end());

    return mod->second;

}

void Allocation::allocateGlobalVarRAMs() {
    formatted_raw_ostream out(getMemoryFile());
    for (Module::global_iterator I = module->global_begin(), E =
            module->global_end();
            I != E; ++I) {
        if (I->isDeclaration()) continue;
        if (I->getName() == "llvm.used") continue;
        if (isaPrintfString(I)) continue;
        //TODO: Bypassing RAM creation global output
        if (LEGUP_CONFIG->isInterfacePort(I->getName())){
        	out<<"FOUND IT"<<"\n";
        }else{
        out << "allocating global ram: " << getLabel(I) << "\n";
        allocateRAM(I);
    }

    }
}

// get RAM from a load/store instruction
RAM *Allocation::getLocalRamFromInst(Instruction *I) {
    formatted_raw_ostream out(getMemoryFile());
    assert(isMem(I));

    if (instToRam.find(I) != instToRam.end()) {
        return instToRam[I];
    }

    Value *addr = NULL;
    if (LoadInst *L = dyn_cast<LoadInst>(I)) {
        addr = L->getPointerOperand();
    } else if (StoreInst *S = dyn_cast<StoreInst>(I)) {
        addr = S->getPointerOperand();
    }

    RAM *ram = NULL;
    if (addr && LEGUP_CONFIG->getParameterInt("LOCAL_RAMS")) {
        ram = getLocalRamFromValue(addr);
    }
    instToRam[I] = ram;
    return ram;
}


// get RAM from a load/store pointer operand
RAM* Allocation::getLocalRamFromValue(Value *op) {
    if (isMem(op)) {
        return getLocalRamFromInst(dyn_cast<Instruction>(op));
    }

    // valueToRam has been updated in visitLocalMemoryInst for every
    // address that points to exactly one memory
    if (valueToRam.find(op) != valueToRam.end()) {
        return valueToRam[op];
    } else {
        // must be from global memory
        return NULL;
    }
}

bool Allocation::isRAMLocaltoFct(Function *F, RAM *r) {

    if (!LEGUP_CONFIG->getParameterInt("LOCAL_RAMS")) {
        return false;
    }
    if (isLocalFunctionRam.find(r) == isLocalFunctionRam.end()) {
        if (isGlobalRams.find(r) == isGlobalRams.end()) {
            errs() << "Can't find RAM: " << r->getName() << "\n";
            assert(0 && "Did you call addLocalRAM?");
        }
        return false;
    }
    return (isLocalFunctionRam[r] == F);
}

bool Allocation::fctOnlyUsesLocalRAMs(Function *F) {

    // if PA analysis cannot determine RAM for this function
    if (functionsWithNoPointsToSet.find(F) != functionsWithNoPointsToSet.end())
        return false;

    for (std::set<RAM *>::iterator i = functionToRams[F].begin(),
                                   ie = functionToRams[F].end();
         i != ie; ++i) {
        RAM *r = *i;
        if (isLocalFunctionRam.find(r) == isLocalFunctionRam.end())
            return false;
    }
    return true;
}

// return ture if all RAMs are local to each module
// hence no memory controller is needed
bool Allocation::noSharedMemoryController() {

    if (!LEGUP_CONFIG->getParameterInt("LOCAL_RAMS")) {
        return false;
    }

    for (Module::iterator F = module->begin(), E = module->end(); F != E; ++F) {
        if (!fctOnlyUsesLocalRAMs(F))
            return false;
    }
    return true;
}

void Allocation::visitLocalMemoryInst(Instruction *I) {
    formatted_raw_ostream out(getMemoryFile());

		if (LEGUP_CONFIG->isInterfacePort(I->getName())){
    	out<<"FOUND IT"<<"\n";
			return;
    }

    assert(isMem(I));
    Value *addr = NULL;

    if (LoadInst *L = dyn_cast<LoadInst>(I)) {
        addr = L->getPointerOperand();
    } else if (StoreInst *S = dyn_cast<StoreInst>(I)) {
        addr = S->getPointerOperand();
    }
    assert(addr);

    assert(pointsToAnalysis);
    assert(pointsToAnalysis->value2int.count(addr));
    int variableNum = pointsToAnalysis->value2int[addr];

    // memory locations this address can point to
    std::set<int> &pointsTo =
        pointsToAnalysis->pointerAnalysis->pointsTo(variableNum);

    BasicBlock *BB = I->getParent();
    assert(BB);
    Function *F = BB->getParent();

    if (pointsTo.size() == 0) {
        functionsWithNoPointsToSet.insert(F);
        return;
    }

    out << getLabel(I) << " -> { "
        << "\n";
    for (std::set<int>::iterator j = pointsTo.begin(), je = pointsTo.end();
         j != je; ++j) {
        int memNum = *j;
        assert(pointsToAnalysis->int2mem.count(memNum));
        Value *mem = pointsToAnalysis->int2mem[memNum];
        out << "\tAddr: " << getLabel(mem) << "\n";

        if (isaPrintfString(mem))
            continue;

				if (LEGUP_CONFIG->isInterfacePort(mem->getName())){
					out<<"FOUND POINT IT"<<"\n";
					continue;
				}

        assert(isa<GlobalVariable>(mem) || isa<AllocaInst>(mem));
        RAM *ram = getRAM(mem);
        out << "\t\tRAM: " << ram->getName() << "\n";

        functionToRams[F].insert(ram);

        if (pointsTo.size() == 1) {
            valueToRam[addr] = ram;

            out << "\t\t\tAdding Local RAM: " << ram->getName()
                << " to Fct: " << getLabel(F) << "\n";

            addLocalRam(F, ram);

            // if this ram is already local to another function
            // it'll be put in global memory and be removed
            // from isLocalFunctionRam map
        } else {
            // the variable points to more than one memory...
            assert(pointsTo.size() > 1);

            out << "\t\t\tVariable points to multiple RAMs. Making global RAM: "
                << ram->getName() << "\n";

            addGlobalRam(ram);
        }
    }
    out << "}\n";
}

void Allocation::runPointsToAnalysis() {
    pointsToAnalysis = new PADriver();
    pointsToAnalysis->runOnModule(*module);
    {
        formatted_raw_ostream out(getMemoryFile());
        pointsToAnalysis->print(out, module);
    }

    for (Module::iterator F = module->begin(), E = module->end(); F != E; ++F) {
        for (Function::iterator b = F->begin(), be = F->end(); b != be; ++b) {
            for (BasicBlock::iterator I = b->begin(), ie = b->end(); I != ie;
                 ++I) {
                if (!isMem(I))
                    continue;
                visitLocalMemoryInst(I);
            }
        }
    }
}

// iterate over all LLVM instructions in the module looking for:
//      1) load/stores
//      2) GEP instructions passed as parameters in function calls
// We use these instructions to determine which RAMs are local
// to one function and which RAMs are global
void Allocation::allocateLocalRAMs() {

    formatted_raw_ostream out(getMemoryFile());

    for (Allocation::const_ram_iterator i = ram_begin(), e = ram_end(); i != e;
         ++i) {
        RAM *R = *i;
        if (isLocalFunctionRam.find(R) != isLocalFunctionRam.end()) {
            // the user may specify a ram to be global
            if (LEGUP_CONFIG->isMemoryUserSpecifiedGlobal(R->getName())) {
                addGlobalRam(R);
            }
            continue;
        }
        if (isGlobalRams.find(R) != isGlobalRams.end()) continue;
        out << "Could not detect load/store to ram: " << R->getName() << "\n";
        out << "Forcing to global RAM. I: " << getLabel(R->getValue()) << "\n";
        addGlobalRam(R);
    }

    out << "Final memory allocation:\n";
    out << "Global Memories:\n";
    for (std::set<RAM*>::iterator i = isGlobalRams.begin(), e
            = isGlobalRams.end(); i != e; ++i) {
        RAM *ram = *i;
        ram->setScope(RAM::GLOBAL);
        out << "\t" << ((ram->isROM()) ? "ROM" : "RAM");
        out << ": " << ram->getName() << "\n";
    }

    out << "Local Memories:\n";
    for (std::map<RAM*, Function*>::iterator i = isLocalFunctionRam.begin(), e
            = isLocalFunctionRam.end(); i != e; ++i) {
        RAM *ram = i->first;
        ram->setScope(RAM::LOCAL);
        Function *F = i->second;
        out << "\t" << ((ram->isROM()) ? "ROM" : "RAM");
        out << ": " << ram->getName() << " Function: " << F->getName() <<
            "\n";
    }

}

void Allocation::allocatePhysicalRAMs() {
    formatted_raw_ostream out(getMemoryFile());
    for (Allocation::ram_iterator i = ram_begin(), e = ram_end(); i != e; ++i) {
        RAM *r = *i;
        if (r->getScope() != RAM::GLOBAL) continue;
        if (LEGUP_CONFIG->getParameterInt("GROUP_RAMS")) {
            int datawidth = r->getDataWidth();

            std::map<unsigned, PhysicalRAM*> &physicalMap =
                (r->isROM()) ? physicalROMs : physicalRAMs;

            PhysicalRAM *phyRAM = NULL;
            if (physicalMap.find(datawidth) == physicalMap.end()) {
                // create a new physical RAM
                phyRAM = new PhysicalRAM;
                assert(phyRAM);
                phyRAM->setDataWidth(datawidth);
                phyRAM->setTag(ramTagNum++);
                std::string type = (r->isROM()) ? "rom" : "ram";
                phyRAM->setName(type + "_" + utostr(datawidth));
                out << "Creating new physical ram: " << phyRAM->getName() << "\n";
                physicalMap[datawidth] = phyRAM;
                phyRamList.push_back(phyRAM);
            } else {
                phyRAM = physicalMap[datawidth];
            }

            // add this RAM into the physical (grouped) RAM
            phyRAM->addRAM(r, out);

        } else {
            mapRamTag[r] = ramTagNum;
            // increment tag number
            // by the number of instances of this RAM
            // by default it is 1
            // there can more than 1, if it is used by
            // multiple threads
            unsigned numInstances = r->getNumInstances();
            ramTagNum += numInstances;
        }
    }
    for (Allocation::const_phy_ram_iterator i = phy_ram_begin(),
                                            e = phy_ram_end();
         i != e; ++i) {
        PhysicalRAM *phyRAM = *i;

        if (LEGUP_CONFIG->getParameterInt("GROUP_RAMS_SIMPLE_OFFSET")) {
            phyRAM->staticMemoryAllocation(out);
        }

        for (PhysicalRAM::ram_iterator r = phyRAM->ram_begin(),
                                       re = phyRAM->ram_end();
             r != re; ++r) {
            RAM *R = *r;
            R->setPhysicalRAM(phyRAM);
            mapRamTag[R] = phyRAM->getTag();
        }
    }
}

void Allocation::allocateStackRAMs() {
    for (Module::iterator F = module->begin(), E = module->end(); F != E; ++F) {
        for (Function::iterator b = F->begin(), be = F->end(); b != be; ++b) {
            for (BasicBlock::iterator instr = b->begin(), ie = b->end();
                 instr != ie; ++instr) {
                if (const AllocaInst *alloca = dyn_cast<AllocaInst>(instr)) {
                    allocateRAM(alloca);
                }
            }
        }
    }
}

GenerateRTL *Allocation::getGenerateRTL(Function *F) {
    if (mapFctModule.find(F) == mapFctModule.end()) {
        errs() << "Function not defined: " << F->getName() << "\n";
    }
    assert (mapFctModule.find(F) != mapFctModule.end());

    return mapFctModule[F];
}

int Allocation::getRegCount(GenerateRTL *hw) {
    int RegCount = 0;
    Function *F = hw->getFunction();
    for (std::map<const Value*, std::string>::iterator i =
            functionScope[F].uniquename.begin(), e = functionScope[F].uniquename.end(); i
            != e; ++i) {
        if(const Type *T = dyn_cast<IntegerType>(i->first->getType()))
            RegCount += T->getPrimitiveSizeInBits();
        else
            RegCount += getDataLayout()->getPointerSizeInBits();
    }
    return RegCount;
}

int Allocation::getVarCount(GenerateRTL *hw) {
    return functionScope[hw->getFunction()].uniquename.size();
}

Allocation::~Allocation() {

    for (Allocation::hw_iterator r = hw_begin(), re = hw_end();
            r != re; ++r) {
        assert(*r);
        delete *r;
    }
    for (Allocation::ram_iterator i = ram_begin(), e = ram_end(); i != e; ++i) {
        assert(*i);
        delete *i;
    }
    delete propagatingSignals;
    assert(TD);
    delete TD;
}

// Fill the minFUs map by counting max number of operations in any state
void Allocation::calculateMinMaxFUs (
    FiniteStateMachine *fsm, std::map <std::string, int> &minFUs,
    std::map <std::string, int> &maxFUs) {

    // determine how many functional units we need
    for (FiniteStateMachine::iterator state = fsm->begin(), se = fsm->end();
            state != se; ++state) {
        // FUs needed in this state (used for Bipartite Weighted Matching)
        std::map <std::string, int> ops;

        for (State::iterator i = state->begin(), ie = state->end(); i != ie;
                ++i) {
            Instruction *I = *i;
            std::string opName = LEGUP_CONFIG->getOpNameFromInst(I, this);

            // when opName is empty then the operation will be optimized away
            // so don't increment the number of functional units (ops)
            // ie. divide by a power of 2
            if (opName.empty()) continue;

            if (BipartiteWeightedMatchingBinding::isInstructionSharable(I,
                        this)) {
                ops[opName]++;
            }
        }

        for (std::map<std::string, int>::iterator i = ops.begin(), ie =
                ops.end(); i != ie; ++i) {
            std::string opName = i->first;
            int num = i->second;
            minFUs[opName] = std::max(minFUs[opName], num);
            maxFUs[opName] += num;
        }
    }

}

// this calculates the actual number of FUs required post-scheduling
void Allocation::calculateRequiredFunctionalUnits() {

    std::map <Function *, std::map <std::string, int> > mapFunctionMinFUs;
    std::map <Function *, std::map <std::string, int> > mapFunctionMaxFUs;

    // calculate required functional units for each module
    // calculate min/max DSPs required for each module
    for (hw_iterator i = hw_begin(), ie = hw_end(); i != ie; ++i) {
        GenerateRTL *HW = *i;

        // minFUs is the number of FUs which will be created for a given
        // operation name, determined by the maximum number of those operations
        // which occur in a given state
        std::map <std::string, int> minFUs;

        // maxFUs is the total number of times each FU is used in this function
        std::map <std::string, int> maxFUs;

        FiniteStateMachine *fsm = HW->getBindingFSM();
        assert(fsm);

        // Fill the minFUs/maxFUs map
        calculateMinMaxFUs(fsm,
                minFUs, maxFUs);
               //mapFunctionMinFUs[F], mapFunctionMaxFUs[F]);

        Function *F = HW->getFunction();
        mapFunctionMinFUs[F] = minFUs;
        outs()<<"MIN FUs: "<<minFUs["mem_dual_port"]<<"\n";
        mapFunctionMaxFUs[F] = maxFUs;
        outs()<<"MAX FUs: "<<maxFUs["mem_dual_port"]<<"\n";
    }

    // always start off using the minimum FUs per function
    mapFunctionNumFUs = mapFunctionMinFUs;

    // if we want to restrict ourselves to the number of DSPs on the FPGA
    if (LEGUP_CONFIG->getParameterInt("RESTRICT_TO_MAXDSP")) {
        restrictToMaxDSPs(mapFunctionMinFUs, mapFunctionMaxFUs);
    }

    std::string s;
    std::stringstream ss;
    for (std::map <Function *, std::map <std::string, int> >::iterator i =
            mapFunctionNumFUs.begin(), ie = mapFunctionNumFUs.end(); i != ie;
            ++i) {
        Function *F = i->first;

        ss << "--------------------------------------------------------------------------------\n";
        ss << "Function: " << F->getName().str() << "\n";
        ss << "--------------------------------------------------------------------------------\n";
        ss << left << setw(30) << "Function unit type:" << setw(30) << 
            "Number Required" << "\n";
        for (std::map <std::string, int> ::iterator j =
                mapFunctionNumFUs[F].begin(), je = mapFunctionNumFUs[F].end();
                j != je; ++j) {
            std::string fu = j->first;
            int num = j->second;
            ss << left << setw(30) << fu << setw(30) << num << "\n";
        }
    }
    ss << "\n";
    formatted_raw_ostream out(getBindingFile());
    ss.flush();
    out << ss.str();

}

// This function restricts the multiplier functional units in such
// a way that we don't use more DSPs than available on the device
// Note: We only deal with functional units that use DSPs in this function
// Basically we assign functional units in round robin fashion one at a time
// until all the DSPs are used on the FPGA
void Allocation::restrictToMaxDSPs(
    std::map <Function *, std::map <std::string, int> > mapFunctionMinFUs,
    std::map <Function *, std::map <std::string, int> > mapFunctionMaxFUs) {

    // the first iteration collects the initial running totals.
    bool firstIteration = true;
    unsigned runningTotalMax = 0;
    unsigned runningTotal = 0;
    bool changed = true;
    while (changed) {
        changed = false;

        for (hw_iterator i = hw_begin(), ie = hw_end(); i != ie; ++i) {
            GenerateRTL *HW = *i;
            Function *F = HW->getFunction();

            std::map <std::string, int> minFUs = mapFunctionMinFUs[F];

            for (std::map<std::string, int>::iterator i = minFUs.begin(),
                    ie = minFUs.end(); i != ie; ++i) {
                std::string opName = i->first;

                Operation *Op = LEGUP_CONFIG->getOperationRef(opName);
                assert(Op);
                unsigned DSPs = Op->getDSPElements();
                if (!DSPs) continue;

                if (firstIteration) {
                    runningTotalMax += DSPs * mapFunctionMaxFUs[F][opName];
                    runningTotal += DSPs * mapFunctionNumFUs[F][opName];
                    continue;
                }

                // we have allocated the max FUs necessary for this
                // operand in the function
                if (mapFunctionNumFUs[F][opName] ==
                        mapFunctionMaxFUs[F][opName]) continue;

                unsigned maxDSPs = LEGUP_CONFIG->getMaxDSPs();

                /*
                errs() << "Opname: " << opName << "\n";
                errs() << "DSPs: " << DSPs << "\n";
                errs() << "Total DSPs: " << runningTotal << "\n";
                unsigned requiredFUs = runningTotal/DSPs;
                errs() << "Required FUs: " << requiredFUs << "\n";
                errs() << "Max DSPs: " << maxDSPs << "\n";
                unsigned maxFUsAvail = maxDSPs/DSPs;
                errs() << "Max FUs: " << maxFUsAvail << "\n";
                */

                if (runningTotal > maxDSPs) {
                    DEBUG(errs() << "Using maximum number of DSPs: " <<
                        runningTotal << "/" << maxDSPs << "\n");
                    break;
                } else {
                    runningTotal += DSPs;
                    mapFunctionNumFUs[F][opName]++;
                    changed = true;
                }
            }
        }
        if (firstIteration) {
            firstIteration = false;
            changed = true;
            DEBUG(errs() << "Minimum DSPs: " << runningTotal << "\n");
        }
    }

    DEBUG(errs() << "Expected DSPs: " << runningTotal << "\n");
    DEBUG(errs() << "Without round robin DSPs: " << runningTotalMax << "\n");
}

// returns true if the instruction infers a DSP block
bool Allocation::useExplicitDSP(Instruction *I) {
    if (!isMul(I)) return false;

    // if we are multiplying by a constant then don't use a DSP
    ConstantInt * ci = dyn_cast<ConstantInt>(I->getOperand(0));
    if (ci && canReplaceMultiplyByConstantWithShiftAdd(ci->getZExtValue())) {
        return false;
    }
    ci = dyn_cast<ConstantInt>(I->getOperand(1));
    if (ci && canReplaceMultiplyByConstantWithShiftAdd(ci->getZExtValue())) {
        return false;
    }

    // squares don't use DSPs?
    // actually they do
    //if (I->getOperand(0) == I->getOperand(1)) return false;

    if (!LEGUP_CONFIG->getParameterInt("LOCAL_RAMS")) {
        Function* F = I->getParent()->getParent();
        if (same_inputs.find(F) != same_inputs.end() &&
            same_inputs[F].find(I) != same_inputs[F].end()) {
                return false;
        }
    }

    return true;
}

/*
// create a map, which holds the type of synchronization mechanism as the key (lock, barrier)
// where the value is a set of name of the mutex variables
void Allocation::getSynchronizationUsage (std::map<std::string, std::set<std::string> > &syncMap) const {

    for (Module::iterator FI = module->begin(), FE = module->end(); FI != FE; ++FI) {
        for (Function::const_iterator BB = FI->begin(), BE = FI->end(); BB != BE; ++BB) {
            for (BasicBlock::const_iterator I = BB->begin(), IE = BB->end(); I != IE; ++I) {
                if (const CallInst *CI = dyn_cast<CallInst>(I)) {
                    const Function *calledFunction = CI->getCalledFunction();
                    // ignore indirect function calls
                    if (!calledFunction) continue;

                    if (calledFunction->getName().str() == "legup_lock2") { //uses locks
                        std::string mutexName = getMetadataStr(CI, "mutexName");
                        syncMap["lock"].insert(mutexName);
                    } else if (calledFunction->getName().str() == "legup_barrier_wait") {
                        // for now only support one barrier 
                        syncMap["barrier"].insert("barrier");
                    }
                }
            }
        }
    }
}
*/

// create a map, which holds the type of synchronization mechanism as the key (lock, barrier)
// where the value is a set of integers which represent the mutex index
//void Allocation::getSynchronizationUsage (std::map<std::string, std::set<int> > &syncMap) const {
void Allocation::getSynchronizationUsage (std::map<std::string, int > &syncMap) const {

    for (Module::iterator FI = module->begin(), FE = module->end(); FI != FE; ++FI) {
        for (Function::const_iterator BB = FI->begin(), BE = FI->end(); BB != BE; ++BB) {
            for (BasicBlock::const_iterator I = BB->begin(), IE = BB->end(); I != IE; ++I) {
                if (const CallInst *CI = dyn_cast<CallInst>(I)) {
                    const Function *calledFunction = CI->getCalledFunction();
                    // ignore indirect function calls
                    if (!calledFunction) continue;

                    if (calledFunction->getName().str() == "legup_lock") { //uses locks
                        std::string mutexName = getMetadataStr(CI, "mutexName");

                        // if there is no operand
                        // when there is only one lock, the compiler can optimize away the operand
                        if (CI->getNumArgOperands () == 0) {
                            // one lock core is used
                            syncMap["lock"] = 1;
                        } else {
                            // we add one to indicate the number of lock cores needed
                            ConstantInt *constant = dyn_cast<ConstantInt>(CI->getArgOperand(0));
                            syncMap["lock"] = constant->getZExtValue() + 1;
                        }
                    } else if (calledFunction->getName().str() == "legup_barrier_wait") {
                        // for now only support one barrier 
                        syncMap["barrier"] = 1;
                    }
                }
            }
        }
    }
}

/* TODO: commented out for LLVM 3.4 update
// Add a ProfileInfo object to Allocation, which contains data about an 
// execution of the program. Also calculate and cache some basic statistics 
// about the software profile information.
void Allocation::addPI(ProfileInfo *P)
{
    assert(P);
    PI = P;
    
    // Calculate total basic block executions
    profile_total_bb_executions = 0;
    for (Module::iterator FI = module->begin(), FE = module->end(); FI != FE; ++FI) {
        if (FI->isDeclaration()) continue;
        for (Function::iterator BB = FI->begin(), BBE = FI->end(); BB != BBE; ++BB) {
            double freq = PI->getExecutionCount(BB);
            if (freq != ProfileInfo::MissingValue) {
                profile_total_bb_executions += freq;
            }
        }
    }
    //errs() << "Total Basic Block executions: " << profile_total_bb_executions;
    
    // Add other statistics of interest here
}
*/

// Return the frequency of execution for this basic block as a percentage
// overall BB executions
float Allocation::get_percentage_execution_for_BB(BasicBlock *BB)
{
	// The ProfileInfo object contains data for each Basic Block. 
	// Find the execution count of this BB
	if (!LEGUP_CONFIG->getParameterInt("LLVM_PROFILE")) return 0;




	// TODO: changed for LLVM 3.4 update
	//int execution_count = PI->getExecutionCount(BB);
	int execution_count = 1;

	//if (execution_count == ProfileInfo::MissingValue) {
		//return 0;
	//}
	
	return float(execution_count) / getTotalBasicBlockExecutions() * 100;
}

// Return true if the execution frequency of this basic block is at
// or below the threshold defined in legup.tcl
bool Allocation::is_BB_executed_infrequently(BasicBlock *BB)
{
	if (!LEGUP_CONFIG->getParameterInt("LLVM_PROFILE")) return false;
	float freq = get_percentage_execution_for_BB(BB);
	return (freq <= LEGUP_CONFIG->getParameterInt("LLVM_PROFILE_MAX_BB_FREQ_TO_ALTER"));
}

// This function is used in compilations where LLVM profiling is enabled. 
// Infrequently executed basic blocks have registers removed and replaced with 
// multi-cycle constraints. However, some instruction (e.g. loads/stores) need
// registers. Given one of these registered instructions, return its state number
// within its basic block.
int Allocation::get_registered_instruction_state(Instruction *i) { 
	std::map<Instruction*, int>::const_iterator inst_it = registered_instruction_to_state.find(i);
	assert(inst_it != registered_instruction_to_state.end()); // Assert found
	return inst_it->second;
}
std::string Allocation::get_register_type(Instruction *i) { 
	std::map<Instruction*, std::string>::const_iterator inst_it = registered_instruction_to_type.find(i);
	assert(inst_it != registered_instruction_to_type.end());  // Assert found
	return inst_it->second;
}
int Allocation::get_num_states_in_BB(BasicBlock *BB) { 
	std::map<BasicBlock*, int>::const_iterator it = BB_to_num_states.find(BB);
	assert(it != BB_to_num_states.end()); // Assert found
	return it->second;
}
bool Allocation::is_registered_instruction(Instruction *i)
{
    if (registered_instruction_to_state.find(i) == 
        registered_instruction_to_state.end())
    {
        return false;
    }
    if (get_register_type(i) == "unregistered") 
    {
        return false;
    }
    return true;
}

// Mark the RAM as a global RAM. If it was associated as
// a local RAM to a specific function, remove that association
void Allocation::addGlobalRam(RAM *r) {
    if (isLocalFunctionRam.find(r) != isLocalFunctionRam.end()) {
        isLocalFunctionRam.erase(r);
    }
    isGlobalRams.insert(r);
}

// Associate a RAM with a specific function and mark it as a local RAM,
// unless:
//      1) this RAM is already a global RAM
//      2) this RAM is local to *another* function
// In which case, we mark the RAM as a global RAM
void Allocation::addLocalRam(Function *F, RAM *r) {

    if (isGlobalRams.find(r) != isGlobalRams.end()) {
    } else if (isLocalFunctionRam.find(r) != isLocalFunctionRam.end()) {
        // this ram is already local to a function
        if (F != isLocalFunctionRam[r]) {
            // different function -- must be put in global memory
            addGlobalRam(r);
        }
    } else {
        isLocalFunctionRam[r] = F;
    }
}

// return the number of instances for this Function
// there is one instance per thread
unsigned Allocation::getNumInstancesforFunction(unsigned currNumInstance, const Function *F, 
        std::set<const Function*> &visited) {

    if (visited.count(F))
        return currNumInstance;
    visited.insert(F);

    // multiply by the number of instances for this function
    // only if it's not the top-level function
    if (F->hasFnAttribute("totalNumThreads") && F->hasNUsesOrMore(1)) {
        currNumInstance *= strToInt(F->getFnAttribute("totalNumThreads").getValueAsString());
    } 

    unsigned maxNumInstance=1;
    for (const User *UI : F->users()) {   
		if (const CallInst *CI = dyn_cast<CallInst>(UI)) {

            const Function *callerF = CI->getParent()->getParent();
            unsigned numInstance = getNumInstancesforFunction(currNumInstance, callerF, visited);
            if (numInstance > maxNumInstance)
                maxNumInstance = numInstance;
		}
    }
   
    if (maxNumInstance > currNumInstance)
        return maxNumInstance;
    return currNumInstance;
}

std::string PropagatingSignal::getName() {
	assert(_signal);
	std::string name = _signal->getName();
	size_t arbiter = name.find("_arbiter");
	if (arbiter != std::string::npos) {
		return name.substr(0, arbiter) + name.substr(arbiter+strlen("_arbiter"), std::string::npos); 
	}
	return name;
}

std::string PropagatingSignal::getPthreadsMemSignalName() {
    std::string standardName = this->getName();
		if (standardName == "memory_controller_waitrequest") return "memory_controller_waitrequest_arbiter";
    std::size_t lastUnderscore = standardName.rfind("_");
    std::string pthreadsName = standardName.substr(0, lastUnderscore) +
	"_arbiter" + standardName.substr(lastUnderscore, std::string::npos);
    return pthreadsName;
}
    
bool PropagatingSignals::functionUsesMemory(std::string name) {
    std::vector<PropagatingSignal *> signals = getPropagatingSignalsForFunctionNamed(name);
    for (std::vector<PropagatingSignal *>::iterator it = signals.begin(); it != signals.end(); ++it) {

	if ((*it)->isMemory())
	    return true;

    }
    return false;
}

std::vector<FunctionWithSignals *>::iterator PropagatingSignals::functionWithSignalsInVector(std::string name) {

    std::vector<FunctionWithSignals *>::iterator it;
    for (it = functionsAndSignals.begin(); it != functionsAndSignals.end(); ++it) {

	if ((*it)->name == name) return it;

    }

    return functionsAndSignals.end();

}

void PropagatingSignals::addPropagatingSignalToFunctionNamed(std::string name, PropagatingSignal &signal) {
    
    // Create a FunctionWithSignals object to compare with
    // items in the functionsAndSignals set (matches by name).
    //
    FunctionWithSignals newFunction;
    newFunction.name = name;
    std::vector<FunctionWithSignals *>::iterator it = functionWithSignalsInVector(name);

    // If the function exists, add the signal to the list of functions
    // if the function doesn't exist, add the signal and then add the
    // function to the list of functions.
    //
    if (it != functionsAndSignals.end()) {
	FunctionWithSignals *function = *it;
	if (std::find(function->signals.begin(), function->signals.end(), signal) == function->signals.end()) {
	    function->signals.push_back(signal);
	}
    }
    else {
	FunctionWithSignals *mallocedFWS = new FunctionWithSignals;
	mallocedFWS->name = name;
	mallocedFWS->signals.push_back(signal);
	functionsAndSignals.push_back(mallocedFWS);
    }
}

void PropagatingSignals::addPropagatingSignalsToFunctionNamed(std::string name, std::vector<PropagatingSignal> &signals) {

    for (std::vector<PropagatingSignal>::iterator sit = signals.begin(); sit != signals.end(); ++sit) {

	addPropagatingSignalToFunctionNamed(name, *sit);
	
    }
}

std::vector<PropagatingSignal *> PropagatingSignals::referenceVectorForSignalVector(std::vector<PropagatingSignal> &sigVec) {

    std::vector<PropagatingSignal *> refVec;

    for (std::vector<PropagatingSignal>::iterator it = sigVec.begin(); it != sigVec.end(); ++it) {

	refVec.push_back(&*it);

    }

    return refVec;

}

std::vector<PropagatingSignal *> PropagatingSignals::getPropagatingSignalsForFunctionNamed(std::string name) {

    std::vector<FunctionWithSignals *>::iterator it = functionWithSignalsInVector(name);
    if (it != functionsAndSignals.end()) {
	FunctionWithSignals *function = *it;
	return referenceVectorForSignalVector(function->signals);
    }
    
    std::vector<PropagatingSignal *> emptyVector;
    return emptyVector;
}

void PropagatingSignals::
mergePropagatingSignalsWithExistingSignalsInVector(std::vector<PropagatingSignal> &signals,
						   std::vector<PropagatingSignal *> &vector) {

    for (std::vector<PropagatingSignal>::iterator sit = signals.begin(); sit != signals.end(); ++sit) {

	PropagatingSignal &propSig = *sit;
	
	std::vector<PropagatingSignal *>::iterator vit = vector.begin();
	while (vit != vector.end()) {
	    
	    PropagatingSignal &vectorSig = **vit;
	    
	    if (vectorSig.getName() == propSig.getName()) {

		std::string vectorSigHiStr = vectorSig.getWidth().getHi(), 
		            vectorSigLoStr = vectorSig.getWidth().getLo(),
		            propSigHiStr   = propSig.getWidth().getHi(),
		            propSigLoStr   = propSig.getWidth().getLo();

		if (strIsInt(vectorSigHiStr) &&
		    strIsInt(vectorSigLoStr) &&
		    strIsInt(propSigHiStr) &&
		    strIsInt(propSigLoStr)) {

		    int vectorSigHi = strToInt(vectorSigHiStr);
		    int vectorSigLo = strToInt(vectorSigLoStr);
		    int propSigHi   = strToInt(propSigHiStr);
		    int propSigLo   = strToInt(propSigLoStr);
		    
		    int vectorMax = std::max(vectorSigHi, vectorSigLo);
		    int propMax   = std::max(propSigHi, propSigLo);
		    int max       = std::max(vectorMax, propMax);
		    
		    int vectorMin = std::min(vectorSigHi, vectorSigLo);
		    int propMin   = std::min(propSigHi, propSigLo);
		    int min       = std::min(vectorMin, propMin);
		    
		    RTLWidth width(max, min);
		    
		    vectorSig.overrideWidth(width);
		    vectorSig.setMerged(true);
				
		}
		break;
	    }
	    ++vit;
	    
	}
	
	if (vit == vector.end()) {
	    vector.push_back(&propSig);
	}
	
    }
}

std::vector<PropagatingSignal *> PropagatingSignals::getPropagatingSignalsForFunctionsWithNames(std::vector<std::string> names) {
    std::vector<PropagatingSignal *> signals;
    for (std::vector<std::string>::iterator it = names.begin(); it != names.end(); ++it) {
	
	std::string &functionName = *it;
	
	std::vector<FunctionWithSignals *>::iterator fsit = functionWithSignalsInVector(functionName);
	if (fsit != functionsAndSignals.end()) {
	    FunctionWithSignals *function = *fsit;
	    mergePropagatingSignalsWithExistingSignalsInVector(function->signals, signals);
	}
    }
    return signals;
}

} // End legup namespace

