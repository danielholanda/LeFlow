//===-- LegupConfig.cpp - Legup Configuration -------------------*- C++ -*-===//
//
// This file is distributed under the LegUp license. See LICENSE for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements the Legup configuration object
//
//===----------------------------------------------------------------------===//

#include "LegupConfig.h"
#include "llvm/IR/Instructions.h"
#include "utils.h"
#include "Ram.h"
#include <sstream>

#define MULTIPORT

using namespace llvm;

namespace legup {

// NOT thread safe!
static LegupConfig LegupConfigObj;

LegupConfig *LEGUP_CONFIG = &LegupConfigObj;

#define NUM_PARAMETERS 126
const std::string validParameters[NUM_PARAMETERS] = {
    "ALIAS_ANALYSIS", "CLOCK_PERIOD", "DEBUG_MODULO_DEPENDENT",
    "DEBUG_MODULO_TABLE", "DEBUG_PERTURBATION", "DEBUG_VERIFY_INCR_SDC",
    "DFG_SHOW_DUMMY_CALLS", "DISABLE_REG_SHARING", "DONT_CHAIN_GET_ELEM_PTR",
    "DUAL_PORT_BINDING", "ENABLE_PATTERN_SHARING", "EXPLICIT_LPM_MULTS",
    "FREQ_THRESHOLD", "GROUP_RAMS", "GROUP_RAMS_SIMPLE_OFFSET",
    "INCLUDE_INST_IN_FSM_DOT_GRAPH", "INCREMENTAL_SDC", "INFERRED_RAMS",
    "KEEP_SIGNALS_WITH_NO_FANOUT", "LLVM_PROFILE", "LLVM_PROFILE_EXTRA_CYCLES",
    "LLVM_PROFILE_MAX_BB_FREQ_TO_ALTER", "LLVM_PROFILE_PERIOD_CII",
    "LLVM_PROFILE_PERIOD_SIV", "LLVM_PROFILE_STRETCH_BB", "LOCAL_RAMS",
    "LOOP_PIPELINE_CHAIN_BINARY_NOOP", "LOOP_PIPELINE_CHAIN_EXT",
    "MB_MAX_BACK_PASSES", "MB_MINIMIZE_HW", "MB_MINIMIZE_LSB", "MB_PRINT_STATS",
    "MB_RANGE_FILE", "MODULO_DEBUG", "MODULO_SCHEDULER",
    "MULT_BY_CONST_INFER_DSP", "MULTI_CYCLE_ADD_THROUGH_CONSTRAINTS",
    "MULTI_CYCLE_ABORT", "MULTI_CYCLE_DEBUG", "MULTI_CYCLE_DISABLE_REG_MERGING",
    "MULTI_CYCLE_DUPLICATE_LOAD_REG", "MULTI_CYCLE_REMOVE_CMP_REG",
    "MULTI_CYCLE_REMOVE_REG", "MULTI_CYCLE_REMOVE_REG_DIVIDERS",
    "MULTIPLIER_NO_CHAIN", "MULTIPUMPING", "NO_DFG_DOT_FILES",
    "NO_LOOP_PIPELINING", "NO_SDC", "PATTERN_SHARE_ADD", "PATTERN_SHARE_BITOPS",
    "PATTERN_SHARE_SHIFT", "PATTERN_SHARE_SUB", "PIPELINE_ALL",
    "PIPELINE_NO_CHAIN", "PIPELINE_RESOURCE_SHARING", "PIPELINE_SAVE_REG",
    "PRINT_BB_STATS", "PRINTF_CYCLES", "PRINT_STATES", "processor",
    "PS_BIT_DIFF_THRESHOLD", "PS_BIT_DIFF_THRESHOLD_PREDS", "PS_MAX_SIZE",
    "PS_MIN_SIZE", "PS_MIN_WIDTH", "PS_WRITE_TO_DOT", "PS_WRITE_TO_VERILOG",
    "RESTRICT_TO_MAXDSP", "RESTRUCTURE_LOOP_RECURRENCES", "SDC_ALAP",
    "SDC_BACKTRACKING_BUDGET_RATIO", "SDC_BACKTRACKING_PRIORITY", "SDC_DEBUG",
    "SDC_MULTIPUMP", "SDC_NO_CHAINING", "SDC_NO_TIMING_CONSTRAINTS",
    "SDC_ONLY_CHAIN_CRITICAL", "SDC_PRIORITY", "SDC_RES_CONSTRAINTS",
    "SERIAL_DIVIDER", "SKIP_ELEM_CYCLES", "TEST_WAITREQUEST",
    "TIMING_NO_IGNORE_GETELEMENTPTR_AND_STORE", "TIMING_NUM_PATHS", "NO_ROMS",
    "CASE_FSM", "CASEX",
    "INSPECT_DEBUG",                   // Inspect debugger: Populate database.
    "INSPECT_ONCHIP_BUG_DETECT_DEBUG", // Inspect debugger: on-chip bug
                                       // detection
    "INSPECT_DEBUG_DB_NAME",           // Inspect debugger: database name
    "INSPECT_DEBUG_DB_SCRIPT_FILE",    // Inspect debugger: path to database
                                       // creation script
    "DEBUG_FILL_DATABASE",             // Populate debug database
    "DEBUG_INSERT_DEBUG_RTL",          // Add debug core to RTL
    "DEBUG_DB_HOST",         // Debug database host (used by both debuggers)
    "DEBUG_DB_USER",         // Debug database username (used by both debuggers)
    "DEBUG_DB_PASSWORD",     // Debug database password (used by both debuggers)
    "DEBUG_DB_NAME",         // Debug database name (jeff's debugger)
    "DEBUG_DB_SCRIPT_FILE",  // Path to debug database creation script
    "DEBUG_CORE_TRACE_REGS", // Record database regsisters in on-chip buffer?
    "DEBUG_CORE_TRACE_REGS_DELAY_WORST",    // Register tracing - Delay Worst
                                            // optimization
    "DEBUG_CORE_TRACE_REGS_DELAY_ALL",      // Register tracing - Delay All
                                            // optimization
    "DEBUG_CORE_TRACE_REGS_DUAL_PORT",      // Register tracing - Dual ported
    "DEBUG_CORE_TRACE_REGS_DELAY_DEBUG",    // Add debug statements to trace
                                            // delaying
    "DEBUG_CORE_SIZE_BUFS_STATIC_ANALYSIS", // Debug trace buffer sizing method:
                                            // Static analysis
    "DEBUG_CORE_SIZE_BUFS_SIMULATION",      // Debug trace buffer sizing method:
                                            // Simulation
    "VSIM_NO_ASSERT", "PRINT_FUNCTION_START_FINISH",

    // Start of system parameters
    "SYSTEM_PROJECT_NAME",              // The project containing this system
    "SYSTEM_PROCESSOR_ARCHITECTURE",    // ARMA9, MIPSI, X86
    "SYSTEM_PROCESSOR_NAME",            // Tiger_MIPS, Arm_A9_HPS
    "SYSTEM_PROCESSOR_DATA_MASTER",     // data_master
    "SYSTEM_CLOCK_MODULE",              // Module name of the system clock
    "SYSTEM_CLOCK_INTERFACE",           // Interface name of the system clock
    "SYSTEM_RESET_MODULE",              // Module name of the system reset
    "SYSTEM_RESET_INTERFACE",           // Interface name of the system reset
    "SYSTEM_MEMORY_MODULE",             // Module name for system memory
    "SYSTEM_MEMORY_INTERFACE",          // Interface name for system memory
    "SYSTEM_DATA_CACHE_TYPE",           // none, legup_dm_wt_cache
    "SYSTEM_MEMORY_BASE_ADDRESS",       // Any 32-bit address
    "SYSTEM_MEMORY_SIZE",               // Any 32-bit number
    "SYSTEM_MEMORY_WIDTH",              // Data width of the memory in bytes
    "SYSTEM_MEMORY_SIM_INIT_FILE_TYPE", // DAT
    "SYSTEM_MEMORY_SIM_INIT_FILE_NAME", // The simulation memory init file
    "DIVIDER_MODULE",                   // Altera or generic dividers
    "INFERRED_RAM_FORMAT"               // Altera or Xilinx RAM format
                                        // End of system parameters

};

void LegupConfig::checkValidParameter(const std::string name) {
    static std::set<std::string> validParametersSet(
        validParameters, validParameters + NUM_PARAMETERS);
    if (validParametersSet.find(name) == validParametersSet.end()) {
        errs() << "Parameter: " << name << "\n";
        assert(0 && "Unknown or unsupported parameter. "
                    "Add new parameters to whitelist in LegupConfig.cpp");
    }
}

bool LegupConfig::setLegupOutputPath(std::string path) {
    // Check that the path is valid, meaning that it is a subdirectory
    // Don't allow for blank paths
    if (path.length() == 0) {
        errs() << "Setting LegUp Output Path failed: input path had 0 length";
        return false;
    }
    // Don't allow the first character to be '/'
    if (path.find('/') == 0) {
        errs() << "Setting LegUp Output Path failed: input path started with /";
        return false;
    }
    // Don't allow the any character to be '~'
    if (path.find('~') != std::string::npos) {
        errs() << "Setting LegUp Output Path failed: input path had '~'";
        return false;
    }
    // Don't allow any part of the string to be '..'
    if (path.find("..") != std::string::npos) {
        errs() << "Setting LegUp Output Path failed: input path had \"..\"";
        return false;
    }
    // Don't allow '.'
    if ((path.find('.') == 0) && path.length() == 1) {
        errs() << "Setting LegUp Output Path failed: input path was '.'";
        return false;
    }

    // Should be a subdirectory
    legupOutputPath = path;
    return true;
}

LegupConfig *LegupConfig::getLegupConfig() { return &LegupConfigObj; }

bool LegupConfig::isAnyOfTwoOperandsZero(Instruction *instr) {
    for (int i = 0; i < 2; i++) {
        ConstantInt *ci = dyn_cast<ConstantInt>(instr->getOperand(i));
        if (ci && ci->isZero()) {
            return true;
        }
    }

    return false;
}

bool LegupConfig::isSecondOperandZero(Instruction *instr) {
    ConstantInt *ci = dyn_cast<ConstantInt>(instr->getOperand(1));
    return ci && ci->isZero();
}

bool LegupConfig::isSecondOperandPowerOfTwo(Instruction *instr) {
    ConstantInt *ci = dyn_cast<ConstantInt>(instr->getOperand(1));
    return ci && ci->getValue().isPowerOf2();
}

bool LegupConfig::isSecondOperandConstant(Instruction *instr) {
    return isa<ConstantInt>(instr->getOperand(1));
}

int LegupConfig::maxBitWidth(int width0, int width1, int width2) {
    return (width0 >= width1) ? (width0 >= width2) ? width0 : width2
                              : (width1 >= width2) ? width1 : width2;
}

bool LegupConfig::isSupportedBitwidth(int width) {
    return width == 8 || width == 16 || width == 32 || width == 64;
}

bool LegupConfig::isBinaryOperatorNoOp(Instruction *instr) {
    switch (instr->getOpcode()) {
    case Instruction::Add:
        // x + 0 = 0 + x = x
        if (isAnyOfTwoOperandsZero(instr))
            return true;
        break;
    case Instruction::Sub:
        // x - 0 = x
        if (isSecondOperandZero(instr))
            return true;
        break;
    case Instruction::Mul:
    case Instruction::URem:
    case Instruction::UDiv:
        if (isSecondOperandPowerOfTwo(instr))
            return true;
        break;
    case Instruction::And:
    case Instruction::Or:
    case Instruction::Shl:
    case Instruction::AShr:
    case Instruction::LShr:
        if (isSecondOperandConstant(instr)) {
            // If the second operand is a constant
            return true;
        }
        break;
    }

    return false;
}

bool LegupConfig::populateStringsForBinaryOperator(Instruction *instr,
                                                   std::string params[10]) {
    switch (instr->getOpcode()) {
    case Instruction::Add:
        params[0] = "signed";
        params[1] = "add";
        break;
    case Instruction::FAdd:
        params[0] = "altfp";
        params[1] = "add";
        break;
    case Instruction::FMul:
        params[0] = "altfp";
        params[1] = "multiply";
        break;
    case Instruction::FSub:
        params[0] = "altfp";
        params[1] = "subtract";
        break;
    case Instruction::FDiv:
        params[0] = "altfp";
        params[1] = "divide";
        break;
    case Instruction::Sub:
        params[0] = "signed";
        params[1] = "subtract";
        break;
    case Instruction::Mul:
        params[0] = "signed";
        params[1] = "multiply";
        break;
    case Instruction::URem:
        params[0] = "unsigned";
        params[1] = "modulus";
        break;
    case Instruction::UDiv:
        params[0] = "unsigned";
        params[1] = "divide";
        break;
    case Instruction::And:
        params[0] = "bitwise";
        params[1] = "AND";
        break;
    case Instruction::Or:
        params[0] = "bitwise";
        params[1] = "OR";
        break;
    case Instruction::Xor:
        params[0] = "bitwise";
        params[1] = "XOR";
        break;
    case Instruction::Shl:
        params[0] = "shift";
        params[1] = "ll";
        break;
    case Instruction::AShr:
        params[0] = "shift";
        params[1] = "ra";
        break;
    case Instruction::LShr:
        params[0] = "shift";
        params[1] = "rl";
        break;
    case Instruction::SRem:
        params[0] = "signed";
        params[1] = "modulus";
        break;
    case Instruction::SDiv:
        params[0] = "signed";
        params[1] = "divide";
        break;
    default:
        errs() << "Invalid operator type!\n";
    }

    return !isBinaryOperatorNoOp(instr);
}

void LegupConfig::populateStringsForICmpInst(const ICmpInst *cmp,
                                             std::string params[10]) {
    switch (cmp->getPredicate()) {
    case ICmpInst::ICMP_EQ:
        params[0] = "signed";
        params[1] = "comp";
        params[2] = "eq";
        break;
    case ICmpInst::ICMP_NE:
        // TODO: Add "not equal" operations to script and change
        // this accordingly
        params[0] = "signed";
        params[1] = "comp";
        params[2] = "eq";
        break;
    case ICmpInst::ICMP_SLT:
        params[0] = "signed";
        params[1] = "comp";
        params[2] = "lt";
        break;
    case ICmpInst::ICMP_ULT:
        params[0] = "unsigned";
        params[1] = "comp";
        params[2] = "lt";
        break;
    case ICmpInst::ICMP_SLE:
        params[0] = "signed";
        params[1] = "comp";
        params[2] = "lte";
        break;
    case ICmpInst::ICMP_ULE:
        params[0] = "unsigned";
        params[1] = "comp";
        params[2] = "lte";
        break;
    case ICmpInst::ICMP_SGT:
        params[0] = "signed";
        params[1] = "comp";
        params[2] = "gt";
        break;
    case ICmpInst::ICMP_UGT:
        params[0] = "unsigned";
        params[1] = "comp";
        params[2] = "gt";
        break;
    case ICmpInst::ICMP_SGE:
        params[0] = "signed";
        params[1] = "comp";
        params[2] = "gte";
        break;
    case ICmpInst::ICMP_UGE:
        params[0] = "unsigned";
        params[1] = "comp";
        params[2] = "gte";
        break;
    default:
        errs() << "Illegal ICmp predicate.\n";
    }
}

void LegupConfig::populateStringsForFCmpInst(const FCmpInst *cmp,
                                             std::string params[10]) {
    switch (cmp->getPredicate()) {
    case FCmpInst::FCMP_OEQ:
        params[0] = "signed";
        params[1] = "comp";
        params[2] = "oeq";
        break;
    case FCmpInst::FCMP_UEQ:
        params[0] = "signed";
        params[1] = "comp";
        params[2] = "ueq";
        break;
    case FCmpInst::FCMP_ONE:
        params[0] = "signed";
        params[1] = "comp";
        params[2] = "one";
        break;
    case FCmpInst::FCMP_UNE:
        params[0] = "signed";
        params[1] = "comp";
        params[2] = "une";
        break;
    case FCmpInst::FCMP_OLT:
        params[0] = "signed";
        params[1] = "comp";
        params[2] = "olt";
        break;
    case FCmpInst::FCMP_ULT:
        params[0] = "signed";
        params[1] = "comp";
        params[2] = "ult";
        break;
    case FCmpInst::FCMP_OLE:
        params[0] = "signed";
        params[1] = "comp";
        params[2] = "ole";
        break;
    case FCmpInst::FCMP_ULE:
        params[0] = "signed";
        params[1] = "comp";
        params[2] = "ule";
        break;
    case FCmpInst::FCMP_OGT:
        params[0] = "signed";
        params[1] = "comp";
        params[2] = "ogt";
        break;
    case FCmpInst::FCMP_UGT:
        params[0] = "signed";
        params[1] = "comp";
        params[2] = "ugt";
        break;
    case FCmpInst::FCMP_OGE:
        params[0] = "signed";
        params[1] = "comp";
        params[2] = "oge";
        break;
    case FCmpInst::FCMP_UGE:
        params[0] = "signed";
        params[1] = "comp";
        params[2] = "uge";
        break;
    default:
        errs() << "Illegal FCmp predicate.\n";
    }
}

bool LegupConfig::populateStringsForOneOperandInstr(Instruction *instr,
                                                    std::string params[10]) {
    switch (instr->getOpcode()) {
    case Instruction::FPTrunc:
        params[0] = "altfp";
        params[1] = "truncate";
        break;
    case Instruction::FPExt:
        params[0] = "altfp";
        params[1] = "extend";
        break;
    case Instruction::FPToSI:
        params[0] = "altfp";
        params[1] = "fptosi";
        break;
    case Instruction::SIToFP:
        params[0] = "altfp";
        params[1] = "sitofp";
        break;
    default:
        return false;
    }
    return true;
}

bool LegupConfig::populateStringsForTwoOperandInstr(Instruction *instr,
                                                    std::string params[10]) {
    if (isa<BinaryOperator>(instr)) {
        if (!populateStringsForBinaryOperator(instr, params))
            return false;

    } else if (const ICmpInst *cmp = dyn_cast<ICmpInst>(instr)) {
        populateStringsForICmpInst(cmp, params);
    } else if (const FCmpInst *cmp = dyn_cast<FCmpInst>(instr)) {
        populateStringsForFCmpInst(cmp, params);
    } else {
        // errs() << "Unrecognized instruction: " << *instr << "\n";
        // assert(isa<GetElementPtrInst>(instr) || isa<PHINode>(instr) ||
        //        isa<CallInst>(instr));
    }

    return true;
}

bool LegupConfig::populateStringsForThreeOperandInstr(Instruction *instr,
                                                      std::string params[10]) {
    if (instr->getOpcode() == Instruction::Select) {
        params[0] = "signed";
        params[1] = "comp";
        params[2] = "eq";
        params[3] = "mux";
    } else {
        // DEBUG(errs() << "Unrecognized instruction: " << *instr << "\n");
        return false;
    }
    return true;
}

std::string LegupConfig::assembleOpNameFromStringList(std::string params[10]) {
    std::string op_name = params[0];
    for (int i = 1; params[i] != ""; i++) {
        // errs() << "PARAMS[i] is: " << params[i] << "\n";
        op_name = op_name + "_" + params[i];
    }

    return op_name;
}

int findMatchingConstraint(std::string FuName,
                           std::map<std::string, int> &constraintMap,
                           int *constraint) {
    // find longest string match from constraints:
    int finalConstraint = 0;
    std::string longestMatch;
    bool foundMatch = false;
    for (std::map<std::string, int>::iterator i = constraintMap.begin(),
                                              e = constraintMap.end();
         i != e; ++i) {
        std::string constraintFuName = i->first;
        int constraint = i->second;

        size_t found;
        found = FuName.find(constraintFuName);
        if (found == std::string::npos)
            continue;

        // match found
        unsigned lengthMatch = constraintFuName.size();
        if (lengthMatch > longestMatch.size()) {
            finalConstraint = constraint;
            longestMatch = constraintFuName;
            foundMatch = true;
        }
    }
    // errs() << FuName << " (closest tcl constraint: " << longestMatch
    //    << ")\n";

    *constraint = finalConstraint;

    return foundMatch;
}

// This function calculates the constraint on an FuName by
// trying to find the most specific constraint (longest string match) that
// applies. For instance in the tcl file:
//      set_resource_constraint signed_divide_16 3
//      set_resource_constraint signed_divide 2
//      set_resource_constraint divide 1
// this is what will be returned:
//      getNumberOfFUsAllocated(signed_divide_8)     = 2
//      getNumberOfFUsAllocated(signed_divide_16)    = 3
//      getNumberOfFUsAllocated(signed_divide_32)    = 2
//      getNumberOfFUsAllocated(signed_divide_64)    = 2
//      getNumberOfFUsAllocated(unsigned_divide_8)   = 1
//      getNumberOfFUsAllocated(unsigned_divide_16)  = 1
//      getNumberOfFUsAllocated(unsigned_divide_32)  = 1
//      getNumberOfFUsAllocated(unsigned_divide_64)  = 1
// this also applies for memories. For instance, for the local memory 'shared'
// the FuName would be:
//      shared_mem_dual_port
// So the following tcl constraint would apply (if there was nothing more
// specific):
//      set_resource_constraint mem_dual_port 2
// returns false if no constraint is found
bool LegupConfig::getNumberOfFUsAllocated(std::string FuName, int *number) {
    // errs() << "getNumberOfFUsAllocated(" << FuName << ")\n"

    return findMatchingConstraint(FuName, FuncUnitConstraints, number);
}

// works the same as getNumberOfFUsAllocated()
// returns false if no constraint is found
bool LegupConfig::getOperationLatency(std::string FuName, int *latency) {
    // errs() << "getFULatency(" << FuName << ")\n"

    return findMatchingConstraint(FuName, FuncUnitLatency, latency);
}

// works the same as getNumberOfFUsAllocated()
// returns false if no constraint is found
bool LegupConfig::getOperationSharingEnabled(std::string FuName,
                                             bool *sharing) {
    // errs() << "getFULatency(" << FuName << ")\n"

    int sharing_int;
    if (findMatchingConstraint(FuName, FuncUnitSharing, &sharing_int)) {
        *sharing = sharing_int;
        return true;
    } else {
        *sharing = true;
        return false;
    }
}

std::string LegupConfig::getOpNameFromInst(Instruction *instr,
                                           Allocation *alloc) {
    assert(alloc);

    // Later take care of signed/unsigned
    std::string params[10];
    int width0 = 0, width1 = 0, width2 = 0;

	#ifdef MULTIPORT
	if (isa<StoreInst>(instr)){
		StoreInst *storeI = dyn_cast<StoreInst>(instr);
		Value *addr = storeI->getPointerOperand();
		if (LEGUP_CONFIG->isInterfacePort(addr->getName())){
			std::string port = "interface_port";
			outs()<<"PORT FOUND "<<addr->getName().str()<<"\n";
			return port;
		}
	}
	#endif

    if (isMem(instr)) {
        std::string mem = "mem_dual_port";
        if (LEGUP_CONFIG->getParameterInt("LOCAL_RAMS")) {
            assert(alloc);
            RAM *ram = alloc->getLocalRamFromInst(instr);
            if (ram && !alloc->isRAMGlobal(ram)) {
                // each local ram is a unique FU
                mem = ram->getName() + "_local_" + mem;
            } else {
                // global memory -- all have the same FU name
            }
        }
        return mem;
    }

    switch (instr->getNumOperands()) {
    case 1:
        if (isa<SIToFPInst>(instr)) {
            // altfp_sitofp32 converts int (32) to float (32)
            // altfp_sitofp64 converts int (32) to double (64)
            // width0 should be width of output
            width0 = instr->getType()->getPrimitiveSizeInBits();
        } else {
            width0 = instr->getOperand(0)->getType()->getPrimitiveSizeInBits();
        }
        if (!populateStringsForOneOperandInstr(instr, params))
            return "";
        break;

    case 2:
        width0 = instr->getOperand(0)->getType()->getPrimitiveSizeInBits();
        width1 = instr->getOperand(1)->getType()->getPrimitiveSizeInBits();
        if (!populateStringsForTwoOperandInstr(instr, params))
            return "";
        break;

    case 3:
        width0 = instr->getOperand(0)->getType()->getPrimitiveSizeInBits();
        width1 = instr->getOperand(1)->getType()->getPrimitiveSizeInBits();
        width2 = instr->getOperand(2)->getType()->getPrimitiveSizeInBits();
        if (!populateStringsForThreeOperandInstr(instr, params))
            return "";
        break;
    }

    int BitWidth = maxBitWidth(width0, width1, width2);
    int endindex;
    for (endindex = 0; params[endindex] != ""; endindex++)
        ;

    if (!isSupportedBitwidth(BitWidth) || endindex == 0) {
        // DEBUG(errs() << "Unsupported bitwidth for instruction: " << *instr <<
        // "\n");
        return "";
    }

    params[endindex] = utostr(BitWidth);

    return assembleOpNameFromStringList(params);
}

void LegupConfig::setResourceConstraint(std::string FuName,
                                        std::string numFUs) {
    assert(isNumeric(numFUs));
    int num = atoi(numFUs.c_str());
    FuncUnitConstraints[FuName] = num;
}

void LegupConfig::setOperationLatency(std::string FuName,
                                      std::string numCycles) {
    assert(isNumeric(numCycles));
    int num = atoi(numCycles.c_str());
    FuncUnitLatency[FuName] = num;
}

void LegupConfig::setOperationSharing(std::string state, std::string FuName) {
    size_t found;
    int sharing;
    found = state.find("-on");
    if (found != std::string::npos) {
        sharing = 1;
    } else {
        found = state.find("-off");
        assert(found != std::string::npos &&
               "set_operation_state first arg must be either -on or -off");
        sharing = 0;
    }

    FuncUnitSharing[FuName] = sharing;
}

bool CustomVerilogFunction::addIO(std::string _name, std::string _iowidth,
                                  std::string _kind) {
    CustomVerilogIO _io;
    _io.name = _name;
    std::vector<std::string> bitIndices =
        stringsFromStringDelimitedByString(_iowidth, ":");
    if (!isNumeric(bitIndices.at(0)) || !isNumeric(bitIndices.at(1))) {

        return false;
    }

    std::stringstream str(bitIndices.at(0));
    std::stringstream str2(bitIndices.at(1));

    str >> _io.bitFrom;
    str2 >> _io.bitTo;

    if (_kind == "input") {

        _io.isInput = true;

    } else if (_kind == "output") {

        _io.isInput = false;

    } else {

        return false;
    }

    io.push_back(_io);

    return true;
}

std::vector<CustomVerilogIO>
LegupConfig::getCustomVerilogIOForFunctionNamed(const std::string &function) {
    std::set<legup::CustomVerilogFunction>::iterator cf =
        customVerilogFunctions.find(function);
    if (cf != customVerilogFunctions.end()) {
        legup::CustomVerilogFunction customFunction = *cf;
        return customFunction.getIO();
    }
    std::vector<CustomVerilogIO> emptyVector;
    return emptyVector;
}

} // End legup namespace
