//===-- GenerateRTL.cpp -----------------------------------------*- C++ -*-===//
//
// This file is distributed under the LegUp license. See LICENSE for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements the GenerateRTL object
//
//===----------------------------------------------------------------------===//

#include "Allocation.h"
#include "GenerateRTL.h"
#include "BipartiteWeightedMatchingBinding.h"
#include "PatternBinding.h"
#include "SchedulerDAG.h"
#include "SDCScheduler.h"
#include "LegupPass.h"
#include "LegupConfig.h"
#include "Ram.h"
#include "utils.h"
#include "RTL.h"
#include "Debug.h"
#include "llvm/Pass.h"
#include "llvm/IR/InstVisitor.h"
#include "llvm/IR/InstIterator.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Analysis/AliasAnalysis.h"
#include "llvm/IR/ValueSymbolTable.h"
#include "llvm/IR/Metadata.h"
#include <sstream>
#include <fstream>
#include <sstream>
#include <cstdlib>
#include "llvm/Support/FileSystem.h"

#define DEBUG_TYPE "LegUp:GenerateRTL"

using namespace llvm;
using namespace legup;

namespace legup {

void GenerateRTL::updateOperationUsage(
		std::map<std::string, int> &_OperationUsage) {
	for (std::map<std::string, int>::iterator i =
			OperationUsageFunction.begin(), e = OperationUsageFunction.end();
			i != e; ++i) {
		std::string OpName = i->first;
		if (_OperationUsage.find(OpName) == _OperationUsage.end()) {
			_OperationUsage[OpName] = i->second;
		} else {
			_OperationUsage[OpName] += i->second;
		}
	}
}

void GenerateRTL::setOperationUsageFunction(Instruction *instr) {
	//mem related instr should not be counted
	//as it isn't an "operation" with an fmax/area.
	if (isMem(instr))
		return;

	std::string OpName = LEGUP_CONFIG->getOpNameFromInst(instr, alloc);
	if (OperationUsageFunction.find(OpName) == OperationUsageFunction.end()) {
		OperationUsageFunction[OpName] = 1;
	} else {
		OperationUsageFunction[OpName] += 1;
	}
}

std::string GenerateRTL::verilogName(const Value &val) {
	return verilogName(&val);
}

// return the unique Verilog identifier for val
std::string GenerateRTL::verilogName(const Value *val) {
	// keep global updated
	return alloc->verilogNameFunction(val, Fp);
}

// get ram from a GetElementPtrInst, or getElementPtr constant
RAM* GenerateRTL::getRam(Value *op) {
	const Value *ram;

	DEBUG(errs() << "getRam: " << *op << "\n");

	ram = op;
	if (const User *U = dyn_cast<User>(op)) {
		if (U->getNumOperands() > 1) {
			ram = U->getOperand(0);
		}
	}
	return alloc->getRAM(ram);
}

//NC changes... wrapper function
RTLSignal *GenerateRTL::getGEP(State *state, User *GEP) {
	int offsetValue = 0;
	return getGEP(state, GEP, offsetValue);
}

// get ram address from a GetElementPtrInst, or getElementPtr constant
RTLSignal *GenerateRTL::getGEP(State *state, User *GEP, int &value) {

	int baseValue = 0;
	RTLSignal *basePointer = getOp(state, GEP->getOperand(0), baseValue);
	//RTLWidth w("`MEMORY_CONTROLLER_ADDR_SIZE-1");
	//basePointer->setWidth(w);

	int offsetValue = 0;
	RTLSignal *offset = getGEPOffset(state, GEP, offsetValue);
	if (!offset) {
		value = baseValue;
		return basePointer;
	}

	// add offset to base pointer
	RTLOp *gep;
	if (LEGUP_CONFIG->getParameterInt("GROUP_RAMS")
			&& LEGUP_CONFIG->getParameterInt("GROUP_RAMS_SIMPLE_OFFSET")
			&& basePointer->isConst()) {
		// We can OR these cases where basePointer is a TAG:
		// gep = (`TAG_g_mem | (4 * offset));
		gep = rtl->addOp(RTLOp::Or);
	} else {
		gep = rtl->addOp(RTLOp::Add);
	}
	value = baseValue + offsetValue;
	gep->setOperand(0, basePointer);
	gep->setOperand(1, offset);

	return gep;
}

//NC changes... wrapper
RTLSignal *GenerateRTL::getGEPOffset(State *state, User *GEP) {
	int value = 0;
	return getGEPOffset(state, GEP, value);
}

RTLSignal *GenerateRTL::getGEPOffset(State *state, User *GEP, int &value) {

	RTLSignal *gepOffset = NULL;

	gep_type_iterator GTI = gep_type_begin(GEP);
	for (User::op_iterator i = GEP->op_begin() + 1, e = GEP->op_end(); i != e;
			++i, ++GTI) {
		Value *Op = *i;

		int offsetValue = 0;
		RTLSignal *offset = getByteOffset(state, Op, GTI, offsetValue);
		if (!offset)
			continue;

		if (!gepOffset) {
			gepOffset = offset;
			value = offsetValue;
		} else {
			RTLOp *newGepOffset = rtl->addOp(RTLOp::Add);
			newGepOffset->setOperand(0, gepOffset);
			newGepOffset->setOperand(1, offset);
			int newGepOffsetValue = value + offsetValue;
			RTLWidth w("`MEMORY_CONTROLLER_ADDR_SIZE-1");
			gepOffset->setWidth(w);
			gepOffset = newGepOffset;
			value = newGepOffsetValue;
		}
	}

	return gepOffset;
}

//NC changes... wrapper
RTLSignal *GenerateRTL::getByteOffset(State *state, Value *Op,
		gep_type_iterator GTI) {
	int offsetValue = 0;
	return getByteOffset(state, Op, GTI, offsetValue);
}

RTLSignal *GenerateRTL::getByteOffset(State *state, Value *Op,
		gep_type_iterator GTI, int &offsetValue) {

	// Build a mask for high order bits.
    const DataLayout* TD = alloc->getDataLayout();
	unsigned IntPtrWidth = TD->getPointerSizeInBits();
	uint64_t PtrSizeMask = ~0ULL >> (64 - IntPtrWidth);

	// apply mask
	uint64_t Size = TD->getTypeAllocSize(GTI.getIndexedType()) & PtrSizeMask;

	RTLWidth w("`MEMORY_CONTROLLER_ADDR_SIZE-1");
	RTLOp *offset = rtl->addOp(RTLOp::Mul);
	offset->setOperand(0, rtl->addConst(utostr(Size), w));
	offsetValue = Size;

	if (ConstantInt *OpC = dyn_cast<ConstantInt>(Op)) {
		if (OpC->isZero()) {
			offsetValue = 0;
			return NULL;
		}

		// Handle a struct index, which adds its field offset.
		if (StructType *STy = dyn_cast<StructType>(*GTI)) {

			offsetValue = TD->getStructLayout(STy)->getElementOffset(
					OpC->getZExtValue());

			return rtl->addConst(
					utostr(
							TD->getStructLayout(STy)->getElementOffset(
									OpC->getZExtValue())), w);
		}

		offset->setOperand(1, getConstantSignal(OpC));
		offsetValue *= OpC->getValue().getSExtValue();

	} else {

		int op1Value = 0;
		offset->setOperand(1, getOp(state, Op, op1Value));
		offsetValue *= op1Value;
	}

	return offset;

}

bool GenerateRTL::fromSameState(Value *v, State *state) {
	// never gets called
	assert(0);
	errs() << "fromSameState: " << *v << "\n";
	Instruction *operand = dyn_cast<Instruction>(v);
	if (!operand || isa<AllocaInst>(operand)) {
		return false;
	}

	errs() << "fromSameState: " << *operand << "\n";
	//if (isa<LoadInst>(operand)) return false;

	if (sched->getFSM(Fp)->getEndState(operand) == state) {
		return true;
	} else {
		return false;
	}
}

// does the value 'v' finish in another state?
bool GenerateRTL::fromOtherState(Value *v, State *state) {
	Instruction *operand = dyn_cast<Instruction>(v);
	if (!operand)
		return false;
	if (isa<PHINode>(operand))
		return true;

	if (sched->getFSM(Fp)->getEndState(operand) != state) {
		return true;
	} else {
		return false;
	}
}

bool GenerateRTL::usedSameState(Value *instr, State *state) {
	// never called
	assert(0);
	for (Value::user_iterator i = instr->user_begin(), e = instr->user_end();
			i != e; ++i) {
		Instruction *use = dyn_cast<Instruction>(*i);
		if (!use)
			continue;
		if (sched->getFSM(Fp)->getEndState(use) == state) {
			return true;
		}
	}
	return false;
}

// is the value 'val' used in a state other than 'state'?
bool GenerateRTL::usedAcrossStates(Value *val, State *state) {
	for (Value::user_iterator i = val->user_begin(), e = val->user_end(); i != e;
			++i) {
		Instruction *use = dyn_cast<Instruction>(*i);
		if (!use)
			continue;
		if (sched->getFSM(Fp)->getEndState(use) != state) {
			return true;
		}
	}
	return false;
}

// like getOp but instead of returning a wire,
// returns a register
RTLSignal *GenerateRTL::getOpReg(Value *v, State* state) {
	if (rtl->exists(verilogName(v) + "_reg")) {
		RTLSignal *reg = rtl->find(verilogName(v) + "_reg");
		return reg;
	} else {
		return getOp(state, v);
	}
}

void GenerateRTL::createMultiPumpMultiplierFU(Instruction *AxB,
		Instruction *CxD) {

	// create multipump
	/*
	 multipump	multipump_inst (
	 .clk( clk ),
	 .clk2x( clk2x ),
	 .clk1x_follower( clk1x_follower ),

	 .inA( main_1_6_reg_wire ),
	 .inB( 32'd12 ),
	 .outAxB( main_encode_exit__crit_edge_phitmp_wire ),

	 .inC( main_1_5_reg_wire ),
	 .inD( -32'd44 ),
	 .outCxD( main_encode_exit__crit_edge_phitmp29_wire )
	 );
	 */

	// registers retain their value so we just need
	// to connect up the divider
	RTLModule *m = rtl->addModule("multipump", "multipump_" + verilogName(AxB));

	// add a comment
	std::string tmp;
	raw_string_ostream Out(tmp);
	Out << "/* " << getValueStr(AxB) << "\n" << getValueStr(CxD) << "*/";
	m->setBody(Out.str());

	m->addIn("clk")->connect(rtl->find("clk"));
	m->addIn("clk2x")->connect(rtl->find("clk2x"));
	m->addIn("clk1x_follower")->connect(rtl->find("clk1x_follower"));

	Value *vop0 = AxB->getOperand(0);
	Value *vop1 = AxB->getOperand(1);

	// in many cases for a 64-bit multiply, only 32-bit operands are required
	unsigned sizeAxB = max(MBW->getMinBitwidth(vop0),
			MBW->getMinBitwidth(vop1));

	vop0 = CxD->getOperand(0);
	vop1 = CxD->getOperand(1);

	// in many cases for a 64-bit multiply, only 32-bit operands are required
	unsigned sizeCxD = max(MBW->getMinBitwidth(vop0),
			MBW->getMinBitwidth(vop1));
	assert(sizeAxB == sizeCxD);

	//RTLWidth width(AxB->getType());
	RTLWidth width(sizeAxB);

	MultipumpOperation &multipumpAxB = multipumpOperations[AxB];
	RTLSignal *inA_wire = rtl->addWire(multipumpAxB.op0, width);
	m->addIn("inA")->connect(inA_wire);

	RTLSignal *inB_wire = rtl->addWire(multipumpAxB.op1, width);
	m->addIn("inB")->connect(inB_wire);

	RTLSignal *outAxB_actual = rtl->addWire(
			multipumpAxB.name + "_outAxB_actual", RTLWidth(sizeAxB * 2));

	m->addOut("outAxB")->connect(outAxB_actual);

	RTLOp *trunc = rtl->addOp(RTLOp::Trunc);
	trunc->setCastWidth(getBitWidth(AxB->getType()));
	trunc->setOperand(0, outAxB_actual);

	RTLSignal *outAxB = rtl->addWire(multipumpAxB.out, trunc->getWidth());
	outAxB->connect(trunc);

	MultipumpOperation &multipumpCxD = multipumpOperations[CxD];
	RTLSignal *outCxD_actual = rtl->addWire(
			multipumpCxD.name + "_outCxD_actual", RTLWidth(sizeAxB * 2));

	m->addOut("outCxD")->connect(outCxD_actual);

	RTLOp *trunc2 = rtl->addOp(RTLOp::Trunc);
	trunc2->setCastWidth(getBitWidth(CxD->getType()));
	trunc2->setOperand(0, outCxD_actual);

	RTLSignal *outCxD = rtl->addWire(multipumpCxD.out, trunc2->getWidth());
	outCxD->connect(trunc2);

	RTLSignal *en = rtl->addWire("lpm_mult_" + verilogName(CxD) + "_en");
	m->addIn("clken")->connect(en);

	RTLSignal *inC_wire = rtl->addWire(multipumpCxD.op0, width);
	m->addIn("inC")->connect(inC_wire);

	RTLSignal *inD_wire = rtl->addWire(multipumpCxD.op1, width);
	m->addIn("inD")->connect(inD_wire);

	//m->addParam("size", utostr(getBitWidth(AxB->getType())));
	m->addParam("size", utostr(sizeAxB));

	if (sizeAxB < getBitWidth(AxB->getType()) && isa<SExtInst>(vop0)
			&& isa<SExtInst>(vop1)) {
		m->addParam("sign", "\"SIGNED\"");
	} else {
		m->addParam("sign", "\"UNSIGNED\"");
	}

}

RTLSignal *GenerateRTL::createMulFU(Instruction *instr, RTLSignal *op0,
		RTLSignal *op1) {
	/*
	 lpm_mult	lpm_mult_component (
	 .clock (clk2x),
	 .dataa (dataa_wire),
	 .datab (datab_wire),
	 .result (dsp_out),
	 .aclr (1'b0),
	 .clken (1'b1),
	 .sum (1'b0));

	 defparam
	 lpm_mult_component.lpm_hint = "DEDICATED_MULTIPLIER_CIRCUITRY=YES,MAXIMIZE_SPEED=5",
	 lpm_mult_component.lpm_representation = "SIGNED",
	 lpm_mult_component.lpm_type = "LPM_MULT",
	 lpm_mult_component.lpm_pipeline = 0,
	 lpm_mult_component.lpm_widtha = 32,
	 lpm_mult_component.lpm_widthb = 32,
	 lpm_mult_component.lpm_widthp = 64;
	 */

	// registers retain their value so we just need
	// to connect up the divider
	RTLModule *d = rtl->addModule("lpm_mult", "lpm_mult_" + verilogName(instr));

	// add a comment
	std::string tmp;
	raw_string_ostream Out(tmp);
	Out << "/* " << getValueStr(instr) << "*/";
	d->setBody(Out.str());

	Value *vop0 = instr->getOperand(0);
	Value *vop1 = instr->getOperand(1);

	const Type *T = vop0->getType();
	unsigned origSize = T->getPrimitiveSizeInBits();

	// in many cases for a 64-bit multiply, only 32-bit operands are required
	unsigned size = max(MBW->getMinBitwidth(vop0), MBW->getMinBitwidth(vop1));

	std::string sign = "\"UNSIGNED\"";

	if (size < origSize) {
		RTLOp *trunc_op0 = rtl->addOp(RTLOp::Trunc);
		trunc_op0->setCastWidth(size);
		trunc_op0->setOperand(0, op0);
		RTLSignal *a = rtl->addWire("lpm_mult_" + verilogName(instr) + "_a",
				RTLWidth(size));
		a->connect(trunc_op0);

		RTLOp *trunc_op1 = rtl->addOp(RTLOp::Trunc);
		trunc_op1->setCastWidth(size);
		trunc_op1->setOperand(0, op1);

		RTLSignal *b = rtl->addWire("lpm_mult_" + verilogName(instr) + "_b",
				RTLWidth(size));
		b->connect(trunc_op1);

		if (isa<SExtInst>(vop0) && isa<SExtInst>(vop1)) {
			sign = "\"SIGNED\"";
		}

		d->addIn("dataa")->connect(a);
		d->addIn("datab")->connect(b);
	} else {
		d->addIn("dataa")->connect(op0);
		d->addIn("datab")->connect(op1);
	}

	RTLSignal *FU_actual = rtl->addWire(
			"lpm_mult_" + verilogName(instr) + "_out_actual",
			RTLWidth(size * 2));

	d->addOut("result")->connect(FU_actual);

	RTLSignal *FU = rtl->addWire("lpm_mult_" + verilogName(instr) + "_out",
			RTLWidth(origSize));

	RTLOp *trunc = rtl->addOp(RTLOp::Trunc);
	trunc->setCastWidth(FU->getWidth());
	trunc->setOperand(0, FU_actual);

	FU->connect(trunc);

	RTLSignal *en = rtl->addWire(getEnableName(instr));

	unsigned pipelineStages = Scheduler::getNumInstructionCycles(instr);
	if (pipelineStages == 0) {
		RTLSignal *NONE = rtl->addConst("");
		d->addIn("clock")->connect(NONE);
	} else {
		d->addIn("clock")->connect(rtl->find("clk"));
	}
	d->addIn("aclr")->connect(ZERO);
	d->addIn("clken")->connect(en);
	d->addIn("sum")->connect(ZERO);

	d->addParam("lpm_pipeline", utostr(pipelineStages));

	// multiplier input sizes must be the same in LLVM
	d->addParam("lpm_widtha", utostr(size));
	d->addParam("lpm_widthb", utostr(size));

	// product width must be double
	d->addParam("lpm_widthp", utostr(size * 2));

	d->addParam("lpm_representation", sign);
	//lpm_mult_component.lpm_hint = "DEDICATED_MULTIPLIER_CIRCUITRY=YES,MAXIMIZE_SPEED=5",
	d->addParam("lpm_hint", "\"\"");

	return FU;
}

unsigned GenerateRTL::getOpSizeShared(Instruction *instr, RTLSignal *op,
		unsigned opIndex) {
	assert(
			(opIndex == 0 || opIndex == 1)
					&& "opIndex has to be 0 or 1 since instr should be a div or rem");
	unsigned minSize = op->getWidth().numBits(rtl, alloc);
	unsigned maxMinSize = minSize;
	std::string fuId = "";
	if (this->binding->existsBindingInstrFU(instr))
		fuId = this->binding->getBindingInstrFU(instr);
	if (fuId != ""
			&& instructionsAssignedToFU.find(fuId)
					!= instructionsAssignedToFU.end()) {
		for (std::set<Instruction *>::iterator i =
				instructionsAssignedToFU[fuId].begin(), ie =
				instructionsAssignedToFU[fuId].end(); i != ie; ++i) {
			Instruction *thisInstr = *i;
			RTLSignal *thisSig = rtl->findExists(
					verilogName(thisInstr->getOperand(opIndex)));
			if (thisSig)
				maxMinSize = thisSig->getWidth().numBits(rtl, alloc);
			else if (USE_MB
					&& MBW->bitwidthIsKnown(thisInstr->getOperand(opIndex))) {
				maxMinSize = MBW->getMinBitwidth(
						thisInstr->getOperand(opIndex));
			} else
				continue;
			if (maxMinSize > minSize) {
				minSize = maxMinSize;
			}
		}
	}
	return minSize;
}

RTLWidth GenerateRTL::getOutSizeShared(Instruction *instr) {
	RTLWidth w;
	if (USE_MB && MBW->bitwidthIsKnown(instr)) {
		w = RTLWidth(instr, MBW);
		unsigned size = MBW->getMinBitwidth(instr);
		std::string fuId = "";
		if (this->binding->existsBindingInstrFU(instr))
			fuId = this->binding->getBindingInstrFU(instr);
		if (fuId != ""
				&& instructionsAssignedToFU.find(fuId)
						!= instructionsAssignedToFU.end()) {
			for (std::set<Instruction *>::iterator i =
					instructionsAssignedToFU[fuId].begin(), ie =
					instructionsAssignedToFU[fuId].end(); i != ie; ++i) {
				Instruction *thisInstr = *i;
				unsigned thisMinSize = MBW->getMinBitwidth(thisInstr);
				if (thisMinSize > size) {
					size = thisMinSize;
					w = RTLWidth(thisInstr, MBW);
				}
			}
		}
	} else {
		w = RTLWidth(instr->getType());
	}
	return w;
}

// Instantiate a pipelined divider module
RTLSignal *GenerateRTL::createDivFU(Instruction *instr, RTLSignal *op0, RTLSignal *op1) {

  
  std::set<Instruction *>::iterator instIter;

  RTLModule *d;

  // registers retain their value so we just need
  // to connect up the divider

  // We support TWO styles different divider implementations:
  // 1) Altera's LPM divider
  // 2) A generic divider from opencores.org

  // We are keeping both options available, because the Altera one
  // seems to use less Si area

  std::map<std::string, std::string> nm; // port name map
  nm["width_d"] = "width_d";
  nm["width_n"] = "width_n";
  nm["sign_d"] = "sign_d";
  nm["sign_n"] = "sign_n";
  nm["quotient"] = "quotient";
  nm["remain"] = "remain";
  nm["clock"] = "clock";
  nm["clken"] = "clken";
  nm["numer"] = "numer";
  nm["denom"] = "denom";
  nm["stages"] = "stages";
  if (LEGUP_CONFIG->getParameter("DIVIDER_MODULE") == "generic") {
    // Figure out if this is a signed or unsigned unit
    // For the generic case, there are separate Verilog modules for
    // signed vs unsigned.  For the Altera case, there's only a single module.
      if (instr->getOpcode() == Instruction::SDiv
              || instr->getOpcode() == Instruction::SRem) {
         nm["module"] = "div_signed";
      } else {
         nm["module"] = "div_unsigned";
      }
  } else {
      assert (LEGUP_CONFIG->getParameter("DIVIDER_MODULE") == "altera");
      nm["module"] = "lpm_divide";
      nm["width_d"] = "lpm_widthd";
      nm["width_n"] = "lpm_widthn";
      nm["sign_d"] = "lpm_drepresentation";
      nm["sign_n"] = "lpm_nrepresentation";
      nm["stages"] = "lpm_pipeline";
  }

  d = rtl->addModule(nm["module"], nm["module"] + "_" + verilogName(instr));

  // add a comment
  std::string tmp;
  raw_string_ostream Out(tmp);
  Out << "/* " << getValueStr(instr) << "*/";
  d->setBody(Out.str());

  RTLSignal *FU = rtl->addWire("lpm_divide_" + verilogName(instr) + "_temp_out",
			       RTLWidth(instr->getType()));

  RTLSignal *unused = rtl->addWire(verilogName(instr) + "_unused",
				   RTLWidth(instr->getType()));
  
  if (isDiv(instr)) {
    d->addOut(nm["quotient"])->connect(FU);
    d->addOut(nm["remain"])->connect(unused);
  } else {
    assert(isRem(instr));
    d->addOut(nm["quotient"])->connect(unused);
    d->addOut(nm["remain"])->connect(FU);
  }

  RTLSignal *en = rtl->addWire(getEnableName(instr));

  d->addIn(nm["clock"])->connect(rtl->find("clk"));
  if (LEGUP_CONFIG->getParameter("DIVIDER_MODULE") == "altera")
      d->addIn("aclr")->connect(ZERO);
  d->addIn(nm["clken"])->connect(en);

  unsigned pipelineStages = Scheduler::getNumInstructionCycles(instr);

  if (LEGUP_CONFIG->getParameter("DIVIDER_MODULE") == "generic") {
      // janders note the "-1" for generic divider
      // This is because in the generic divider, if the width is 16, it actually takes 17 cycles to complete its work.
      pipelineStages = pipelineStages - 1;
  }

  if (LEGUP_CONFIG->getParameter("DIVIDER_MODULE") == "altera") {
      // Check whether this divider should be multi-cycled or pipelined
      if (LEGUP_CONFIG->getParameterInt("MULTI_CYCLE_REMOVE_REG_DIVIDERS")) {
          // Will insert multi-cycle constraints for this divider after binding
          alloc->add_multicycled_divider(instr);
      } else {
      }
  } else {
      if (LEGUP_CONFIG->getParameterInt("MULTI_CYCLE_REMOVE_REG_DIVIDERS")) {
          errs() << "Generic dividers not supported with MULTI_CYCLE_REMOVE_REG_DIVIDERS set.\n";
          exit(-1);
      }
  }

  d->addParam(nm["stages"], utostr(pipelineStages));


  // numerator/denominator sizes must be the same in LLVM
  std::string sign = "\"UNSIGNED\"";
  if (instr->getOpcode() == Instruction::SDiv || instr->getOpcode() == Instruction::SRem) 
    sign = "\"SIGNED\"";

  //Get the size of the numerator
  unsigned size = op0->getWidth().numNativeBits(rtl, alloc);
  unsigned minSize = getOpSizeShared(instr, op0, 0);
  if (USE_MB) {
    bool op0Signed = op0->getWidth().getSigned();
    op0->setWidth(RTLWidth(minSize, size, op0Signed));
    if (sign == "\"SIGNED\"" && !op0Signed && !(size == minSize)) {
      minSize++;
    }
    size = min(minSize, size);
    if (size == 1)
      errs() << "minSize:" << utostr(minSize) << "\n";
  }

  d->addIn(nm["numer"], RTLWidth(size))->connect(op0);

  FU->setWidth(RTLWidth(size));
  if (!isDiv(instr))
      unused->setWidth(RTLWidth(size));

  d->addParam(nm["width_n"], utostr(size));

  size = instr->getOperand(1)->getType()->getPrimitiveSizeInBits();
  minSize = getOpSizeShared(instr, op1, 1);
  if (USE_MB) {
    bool op1Signed = op1->getWidth().getSigned();
    op1->setWidth(RTLWidth(minSize, size, op1Signed));
    if (sign == "\"SIGNED\"" && !op1Signed && !(size == minSize)) {
      minSize++;
    }
    size = min(size, minSize);
  }
  
  d->addIn(nm["denom"], RTLWidth(size))->connect(op1);

  if (isDiv(instr))
    unused->setWidth(RTLWidth(size));
  else
      FU->setWidth(RTLWidth(size));

  d->addParam(nm["width_d"], utostr(size));

  if (LEGUP_CONFIG->getParameter("DIVIDER_MODULE") != "generic") {
      d->addParam(nm["sign_d"], sign);
      d->addParam(nm["sign_n"], sign);
  }

  if (LEGUP_CONFIG->getParameter("DIVIDER_MODULE") == "altera") {
      d->addParam("lpm_hint", "\"LPM_REMAINDERPOSITIVE=FALSE\"");
  }

  RTLWidth w = getOutSizeShared(instr);
  
  RTLSignal *FUout = rtl->addWire("lpm_divide_" + verilogName(instr) + "_out",w);
  FUout->connect(FU);
  return FUout;
}  

RTLSignal *GenerateRTL::createFPFU(Instruction *instr, RTLSignal *op0,
		RTLSignal *op1, unsigned opCode) {
	// registers retain their value so we just need
	// to connect up the FP cores

	int width = instr->getOperand(0)->getType()->getPrimitiveSizeInBits();

	assert(width == 32 || width == 64);

	std::string name;
	switch (opCode) {
	case Instruction::FDiv:
		name = "altfp_divider";
		break;
	case Instruction::FAdd:
		name = "altfp_adder";
		break;
	case Instruction::FSub:
		name = "altfp_subtractor";
		break;
	case Instruction::FMul:
		name = "altfp_multiplier";
		break;
	}
	if (width == 64) {
		name = name + utostr(width);
	}

	return createFP_FU_Helper(name, instr, op0, op1, /*fu_module=*/NULL);
}

RTLSignal *GenerateRTL::createFPFUUnary(Instruction *instr, RTLSignal *op0,
		unsigned opCode) {

	int width = instr->getOperand(0)->getType()->getPrimitiveSizeInBits();

	std::string name;
	switch (opCode) {
	case Instruction::FPTrunc:
		name = "altfp_truncate";
		break;
	case Instruction::FPExt:
		name = "altfp_extend";
		break;
	case Instruction::FPToSI:
		name = "altfp_fptosi";
		break;
	case Instruction::SIToFP:
		name = "altfp_sitofp";
		CastInst *I = dyn_cast<CastInst>(instr);
		width = I->getDestTy()->getPrimitiveSizeInBits();
		break;
	}

	assert(width == 32 || width == 64);

	if (!(isa<FPTruncInst>(instr) || isa<FPExtInst>(instr))) { // trunc/ext do not spec width
		name = name + utostr(width);
	}

	return createFP_FU_Helper(name, instr, op0, /*op1*/NULL, /*fu_module=*/NULL);
}

RTLSignal *GenerateRTL::createFCmpFU(Instruction *instr, RTLSignal *op0,
		RTLSignal *op1) {

	int width = instr->getOperand(0)->getType()->getPrimitiveSizeInBits();

	assert(width == 32 || width == 64);

	int latency = Scheduler::getNumInstructionCycles(instr);

	std::string name = "altfp_compare" + utostr(width) + "_" + utostr(latency);

	RTLModule *d = rtl->addModule(name, name + "_" + verilogName(instr));

	RTLSignal *FU = createFP_FU_Helper(name, instr, op0, op1, /*fu_module=*/d);

	RTLSignal *unused = rtl->addWire(verilogName(instr) + "_unused",
			RTLWidth(instr->getType()));

	if (const FCmpInst *cmp = dyn_cast<FCmpInst>(instr)) {
		switch (cmp->getPredicate()) {
		case FCmpInst::FCMP_OEQ:
		case FCmpInst::FCMP_UEQ:
			d->addOut("aeb")->connect(FU);
			d->addOut("aneb")->connect(unused);
			d->addOut("alb")->connect(unused);
			d->addOut("aleb")->connect(unused);
			d->addOut("agb")->connect(unused);
			d->addOut("ageb")->connect(unused);
			d->addOut("unordered")->connect(unused);
			break;
		case FCmpInst::FCMP_ONE:
		case FCmpInst::FCMP_UNE:
			d->addOut("aeb")->connect(unused);
			d->addOut("aneb")->connect(FU);
			d->addOut("alb")->connect(unused);
			d->addOut("aleb")->connect(unused);
			d->addOut("agb")->connect(unused);
			d->addOut("ageb")->connect(unused);
			d->addOut("unordered")->connect(unused);
			break;
		case FCmpInst::FCMP_OLT:
		case FCmpInst::FCMP_ULT:
			d->addOut("aeb")->connect(unused);
			d->addOut("aneb")->connect(unused);
			d->addOut("alb")->connect(FU);
			d->addOut("aleb")->connect(unused);
			d->addOut("agb")->connect(unused);
			d->addOut("ageb")->connect(unused);
			d->addOut("unordered")->connect(unused);
			break;
		case FCmpInst::FCMP_OLE:
		case FCmpInst::FCMP_ULE:
			d->addOut("aeb")->connect(unused);
			d->addOut("aneb")->connect(unused);
			d->addOut("alb")->connect(unused);
			d->addOut("aleb")->connect(FU);
			d->addOut("agb")->connect(unused);
			d->addOut("ageb")->connect(unused);
			d->addOut("unordered")->connect(unused);
			break;
		case FCmpInst::FCMP_OGT:
		case FCmpInst::FCMP_UGT:
			d->addOut("aeb")->connect(unused);
			d->addOut("aneb")->connect(unused);
			d->addOut("alb")->connect(unused);
			d->addOut("aleb")->connect(unused);
			d->addOut("agb")->connect(FU);
			d->addOut("ageb")->connect(unused);
			d->addOut("unordered")->connect(unused);
			break;
		case FCmpInst::FCMP_OGE:
		case FCmpInst::FCMP_UGE:
			d->addOut("aeb")->connect(unused);
			d->addOut("aneb")->connect(unused);
			d->addOut("alb")->connect(unused);
			d->addOut("aleb")->connect(unused);
			d->addOut("agb")->connect(unused);
			d->addOut("ageb")->connect(FU);
			d->addOut("unordered")->connect(unused);
			break;
		default:
			llvm_unreachable("Illegal FCmp predicate");
		}
	}

	return FU;
}

// this helper function creates an RTLModule named fu_name (unless you
// pass in an RTLModule *fu_module). Connects the dataa and datab
// ports to op0 and op1 respectively. Also creates the clock enable
// signals. Arguments: op1 and fu_module are optional (set to NULL to ignore
// them)
RTLSignal *GenerateRTL::createFP_FU_Helper(std::string fu_name,
		Instruction *instr, RTLSignal *op0, RTLSignal *op1,
		RTLModule *fu_module) {
	// registers retain their value so we just need
	// to connect up the FP cores

	RTLSignal *FU = rtl->addWire(fu_name + "_" + verilogName(instr) + "_out",
			RTLWidth(instr->getType()));

	// module is specified for altfp_compare which has special output ports
	if (fu_module == NULL) {
		int latency = Scheduler::getNumInstructionCycles(instr);
		fu_name = fu_name + "_" + utostr(latency);

		fu_module = rtl->addModule(fu_name, fu_name + "_" + verilogName(instr));
		fu_module->addOut("result")->connect(FU);
	}

	// add a comment
	std::string tmp;
	raw_string_ostream Out(tmp);
	Out << "/* " << getValueStr(instr) << "*/";
    fu_module->setBody(Out.str());

    // enable signal
    create_fu_enable_signals(instr);
    RTLSignal *en = rtl->addWire(getEnableName(instr));

    fu_module->addIn("dataa",
                     RTLWidth(op0->getWidth().numNativeBits(rtl, alloc)))
        ->connect(op0);
    if (op1) {
        fu_module->addIn("datab",
                         RTLWidth(op1->getWidth().numNativeBits(rtl, alloc)))
            ->connect(op1);
    }
    fu_module->addIn("clock")->connect(rtl->find("clk"));
    fu_module->addIn("clk_en")->connect(en);

    return FU;
}

// create a functional unit (fu) module instantiation for the given
// instruction and input operand signals
RTLSignal *GenerateRTL::createFU(Instruction *instr, RTLSignal *op0,
		RTLSignal *op1) {

	if (isDiv(instr) || isRem(instr)) {
		return createDivFU(instr, op0, op1);
	} else if (EXPLICIT_LPM_MULTS && alloc->useExplicitDSP(instr)) {
		return createMulFU(instr, op0, op1);
	}

	//If the instruction is one of the floating point operation, call FP create module
	//with opCode (unsigned) as additional parameter
	unsigned opCode = instr->getOpcode();
	switch (instr->getOpcode()) {
	case Instruction::FAdd:
	case Instruction::FSub:
	case Instruction::FMul:
	case Instruction::FDiv:
		return createFPFU(instr, op0, op1, opCode);
	case Instruction::FCmp:
		return createFCmpFU(instr, op0, op1);
	case Instruction::FPTrunc:
	case Instruction::FPExt:
	case Instruction::FPToSI:
	case Instruction::SIToFP:
		return createFPFUUnary(instr, op0, opCode);
	}

	// fixes to match gcc: case where shifting by more than the number
	// of bits in the number
	// should probably ignore this case because it's undefined in the C
	// standard.
	if (isLogicalShift(instr)) {
		RTLOp *truncate = rtl->addOp(RTLOp::Rem);

		const Type *T = instr->getOperand(1)->getType();
		unsigned size = T->getPrimitiveSizeInBits();

		truncate->setOperand(0, op1);
		truncate->setOperand(1, rtl->addConst(utostr(size), size));

		op1 = truncate;
	}

	if (op1Signed(instr)) {
		RTLOp *sext = rtl->addOp(RTLOp::SExt);
		//sext->setCastWidth(w);
		RTLWidth w = op0->getWidth();
		//if adding keyword $signed to an unsigned number, we need to create a temp
		//signal that pads the bitwidth with a 0, to make sure $signed doesn't accidentally
		//convert an unsigned number to a signed number
		if (!w.getSigned()
				&& w.numBits(rtl, alloc) < w.numNativeBits(rtl, alloc)) {
			w = RTLWidth(w.numBits(rtl, alloc) + 1, w.numNativeBits(rtl, alloc),
					false);
			RTLSignal *op0_old = op0;
			op0 = rtl->addWire(verilogName(instr) + "_op0_temp", w);
			op0->connect(op0_old);
		}
		sext->setCastWidth(w);
		sext->setOperand(0, op0);
		op0 = sext;
	}

	if (op2Signed(instr)) {
		RTLOp *sext = rtl->addOp(RTLOp::SExt);
		//sext->setCastWidth(w);
		RTLWidth w = op1->getWidth();
		//if adding keyword $signed to an unsigned number, we need to create a temp
		//signal that pads the bitwidth with a 0, to make sure $signed doesn't accidentally
		//convert an unsigned number to a signed number
		if (!w.getSigned()
				&& w.numBits(rtl, alloc) < w.numNativeBits(rtl, alloc)) {
			w = RTLWidth(w.numBits(rtl, alloc) + 1, w.numNativeBits(rtl, alloc),
					false);
			RTLSignal *op1_old = op1;
			op1 = rtl->addWire(verilogName(instr) + "_op1__temp", w);
			op1->connect(op1_old);
		}
		sext->setCastWidth(w);
		sext->setOperand(0, op1);
		op1 = sext;
	}

	RTLOp *FUop = rtl->addOp(instr);
	FUop->setOperand(0, op0);
	FUop->setOperand(1, op1);
	RTLWidth outWidth = RTLWidth(instr, MBW);
	FUop->setWidth(outWidth);

	RTLSignal *FUoutput = FUop;

//        FUop->setWidth(RTLWidth(MBW->getMinBitwidth(instr)));
//        FUop->setNativeWidth(RTLWidth(instr->getType()));
//        if(MBW->isSigned(instr)) FUop->setSigned(true);
//    if(MBW->bitwidthIsKnown(instr) && MBW->isSigned(instr)) FUop->getWidth().setSigned(true);
//    FUop->getWidth().setSigned(MBW->isSigned(instr));

	int latency = Scheduler::getNumInstructionCycles(instr);
	if (latency > 0 && !LEGUP_CONFIG->does_flow_support_multicycle_paths()) {

		// add flops for user specified set_operation_latency
		// this is for adders/subtractors/shifts - functional units without
		// lpm_* module instantiations

		RTLSignal *en = rtl->addWire(getEnableName(instr));

		RTLOp *enCond = rtl->addOp(RTLOp::EQ);
		enCond->setOperand(0, en);
		enCond->setOperand(1, ONE);

		// create shift register
		RTLSignal *prev_stage_reg = NULL;
		for (int i = 0; i < latency; i++) {
			RTLSignal *stage_reg = rtl->addReg(
					verilogName(instr) + "_stage" + utostr(i) + "_reg",
					outWidth);
			stage_reg->setCheckXs(false);

			RTLSignal *driver = prev_stage_reg;
			if (prev_stage_reg == NULL) {
				// first register is driven by FU wire
				driver = FUoutput;
			}

			stage_reg->addCondition(enCond, driver, instr);

			prev_stage_reg = stage_reg;
		}
		FUoutput = prev_stage_reg;
	}

	assert(FUoutput);
	return FUoutput;
}

void GenerateRTL::visitReturnInst(ReturnInst &I) {
    // don't print anything for void return
    if (I.getNumOperands() != 0) {
        RTLSignal *return_val = rtl->find("return_val");
        connectSignalToDriverInState(
            return_val, getOp(this->state, I.getOperand(0)), this->state, &I);
    }

    PropagatingSignals *ps = alloc->getPropagatingSignals();
    bool shouldConnectMemorySignals = ps->functionUsesMemory(Fp->getName());

    if (shouldConnectMemorySignals) {
		// finish = 1 when waitrequest == 0
        RTLOp *wait = rtl->addOp(RTLOp::EQ);
        wait->setOperand(0, rtl->find("memory_controller_waitrequest"));
        wait->setOperand(1, ZERO);
        connectSignalToDriverInState(rtl->find("finish"), wait, this->state,
                                     &I);
    } else {
        connectSignalToDriverInState(rtl->find("finish"), ONE, this->state, &I);
    }
}

void GenerateRTL::visitUnreachableInst(UnreachableInst &I) {
}

std::string getPipelineLabel(const BasicBlock *BB) {
	const TerminatorInst *TI = BB->getTerminator();
	static std::map<std::string, int> numLabels;
	static std::map<const BasicBlock *, std::string> bbUniqueLabel;
	std::string label = getMetadataStr(TI, "legup.label");
	if (bbUniqueLabel.find(BB) == bbUniqueLabel.end()) {
		numLabels[label]++;
		bbUniqueLabel[BB] = label + "_" + utostr(numLabels[label]);
	}
	return bbUniqueLabel[BB];
}

Instruction *getInductionVar(BasicBlock *BB) {
	Instruction *inductionVar = NULL;
	for (BasicBlock::iterator I = BB->begin(), ie = BB->end(); I != ie; ++I) {
		if (getMetadataInt(I, "legup.canonical_induction")) {
			inductionVar = I;
			break;
		}
	}
	assert(inductionVar);
    return inductionVar;
}

RTLOp *GenerateRTL::getPipelineStateCondition(RTLSignal *signal,
                                              Instruction *instr,
                                              PIPELINE_STATE pipelineState) {
    bool PIPELINED = isPipelined(instr);
    std::string label = "";
	int II = 0;

	if (!PIPELINED)
		return 0;

	BasicBlock *BB = instr->getParent();
	Instruction *inductionVar = getInductionVar(BB);
	label = getPipelineLabel(BB);
	II = getPipelineII(BB);

	// induction variable signals are hard coded for now
	if (signal == rtl->find(verilogName(inductionVar) + "_reg")
			|| instr == inductionVar) {
		return 0;
	}

	TerminatorInst *TI = BB->getTerminator();
	if (instr == TI->getOperand(0)) {
		signal->connect(rtl->find(label + "_pipeline_finish"));
		return 0;
	}

	int startTime = getMetadataInt(instr, "legup.pipeline.start_time");
	int timeAvail = getMetadataInt(instr, "legup.pipeline.avail_time");
	int expectedAvailTime = startTime
			+ Scheduler::getNumInstructionCycles((Instruction*) instr);

    int time = timeAvail;

    if (pipelineState == INPUT_READY) {
        // load/store or floating point instructions take multiple cycles to
        // complete. Sometimes we want to connect the memory_controller_addr
        // and other signals to *start* the operation
        time = startTime;
	} else if (timeAvail != expectedAvailTime) {
		// this is caused when we have an operation, say an 'add' that
		// is normally chained in this scheduler. But since IMS doesn't
		// support chaining, the IMS schedules the add into the next
		// cycle.
		assert(timeAvail == expectedAvailTime + 1);
		time = expectedAvailTime;
	}

	RTLSignal *ii_state = rtl->find(label + "_ii_state");

	// connect the signal during the correct ii_state and valid_bit time
	RTLOp *cond = rtl->addOp(RTLOp::And)->setOperands(
			rtl->addOp(RTLOp::EQ)->setOperands(ii_state,
					new RTLConst(utostr(time % II), ii_state->getWidth())),
			rtl->find(label + "_valid_bit_" + utostr(time)));
	if (signal->isReg()) {
		//it it's a register, add the waitrequest condition to it
		RTLSignal *waitrequest = getWaitRequest(BB->getParent());
		RTLOp *regCond = rtl->addOp(RTLOp::And)->setOperands(
				rtl->addOp(RTLOp::Not)->setOperands(waitrequest), cond);
		return regCond;
	}
    return cond;
}

RTLOp *GenerateRTL::createOptoCheckState(State *state) {

    RTLOp *cond;
    cond = rtl->addOp(RTLOp::EQ);
    cond->setOperand(0, rtl->find("cur_state"));
    cond->setOperand(1, getStateSignal(state));

    return cond;
}

void GenerateRTL::connectSignalToDriverInState(RTLSignal *signal,
                                               RTLSignal *driver, State *state,
                                               Instruction *instr,
                                               PIPELINE_STATE pipelineState,
                                               bool setToDriverBits) {

    assert(state);
    assert(driver);

    RTLOp *cond;

    RTLOp *pipeline_cond =
        getPipelineStateCondition(signal, instr, pipelineState);
    if (isPipelined(instr) && pipeline_cond) {
        cond = pipeline_cond;
    } else {
        cond = createOptoCheckState(state);
    }

    signal->addCondition(cond, driver, instr, setToDriverBits);
}

// create signal which checks state AND another condition
void GenerateRTL::connectSignalToDriverInStateWithCondition(
    RTLSignal *signal, RTLSignal *driver, State *state, RTLOp *newCond,
    Instruction *instr) {

    assert(state);
    assert(driver);

    RTLOp *stateCond = createOptoCheckState(state);
    ;

    RTLOp *cond;
    if (newCond) {
        cond = rtl->addOp(RTLOp::And);
        cond->setOperands(stateCond, newCond);
    } else {
        cond = stateCond;
    }

    signal->addCondition(cond, driver, instr);
}

void GenerateRTL::visitGetElementPtrInst(GetElementPtrInst &I) {
    // RAM pointer

    RTLSignal *gep = rtl->addWire(verilogName(&I),
                                  RTLWidth("`MEMORY_CONTROLLER_ADDR_SIZE-1"));

    connectSignalToDriverInState(gep, getGEP(this->state, &I), this->state, &I);
}

int GenerateRTL::connectedToPortB(Instruction *instr) {
	if (!this->binding->existsBindingInstrFU(instr))
		return 0;

	std::string fuId = this->binding->getBindingInstrFU(instr);
	size_t found;
	found = fuId.find("mem_dual_port_0");
	if (found != string::npos) {
		return 0;
	} else {
		found = fuId.find("mem_dual_port_1");
		if (found != string::npos) {
			return 1;
		} else {
			errs() << "Error: mem_port not matched! FuId: " << fuId << "\n";
			return -1;
		}
	}
}

void GenerateRTL::visitLoadInst(LoadInst &I) {
	LoadInst *instr = &I;
	Value *addr = I.getPointerOperand();

	std::cout<<"Visiting Load"<<std::endl;
	I.print(outs());
	std::cout<<std::endl;

	State *endState = fsm->getEndState(&I);
	assert(endState);

	RTLWidth w(instr->getType());
	//if the ranges aren't dynamic, then minimize loads as well.  When dynamic ranges are specific
	//in a file, then comparators could be used to check the ranges coming from the loads, so they
	//shouldn't be minimized.
	if (LEGUP_CONFIG->getParameter("MB_RANGE_FILE") == "")
		w = RTLWidth(instr, MBW);
	RTLSignal *loadWire = rtl->addWire(verilogName(instr), w);

    std::string regName = verilogName(instr) + "_reg";
    if (!rtl->exists(regName)) {
        RTLSignal *loadReg = rtl->addReg(regName, w);
        connectSignalToDriverInState(loadReg, loadWire, endState, instr,
                                     OUTPUT_READY);
    }

    if (LEGUP_CONFIG->isInterfacePort(addr->getName())){

    	std::string label = addr->getName().str();



    	if (!rtl->exists(label + "_in")){

    		bool isInternal = LEGUP_CONFIG->isInternalInterface(label);

    		rtl->addIn(label + "_in",w);
    		PropagatingSignals *ps = alloc->getPropagatingSignals();

			RTLSignal *temp_port_signal = new RTLSignal(label + "_in","",w);
			temp_port_signal ->setType("input");
			PropagatingSignal propInterfacePort(temp_port_signal , isInternal, false);

			ps->addPropagatingSignalToFunctionNamed(Fp->getName(),propInterfacePort);
    	}

		RTLOp *trunc = rtl->addOp(RTLOp::Trunc);
		trunc->setCastWidth(loadWire->getWidth());
		trunc->setOperand(0, rtl->find(label + "_in"));
		connectSignalToDriverInState(loadWire, trunc, endState, instr);

		return;
	}

    assert(connectedToPortB(instr) != -1 && "FU doesn't match the mem port");
    std::string port = connectedToPortB(instr) ? "b" : "a";

	RAM *ram = NULL;
	if (LEGUP_CONFIG->getParameterInt("LOCAL_RAMS")) {
		ram = alloc->getLocalRamFromValue(addr);
	}

	if (ram && alloc->isRAMLocaltoFct(Fp, ram)) {
		std::string name = ram->getName();

		//errs() << "Connecting local RAM: " << ram->getName() << "\n";

		// convert byte address to word address
		RTLOp *wordAddr = rtl->addOp(RTLOp::Shr);
		wordAddr->setOperand(0, getOp(this->state, addr));
		int bytes = ram->getDataWidth() / 8;
		int ignore = (bytes == 0) ? 0 : (int) log2(bytes);
		wordAddr->setOperand(1, new RTLConst(utostr(ignore), RTLWidth(3)));

		connectSignalToDriverInState(rtl->find(name + "_address_" + port), 
                wordAddr, this->state, instr);
		connectSignalToDriverInState(rtl->find(name + "_write_enable_" + port), 
                ZERO, this->state, instr);
		connectSignalToDriverInState(loadWire, rtl->find(name + "_out_" + port),
                endState, instr);
	} else {

		loadStoreCommon(&I, addr);
        RTLSignal *memOut;

        // for parallel function 
        // readdata needs to be taken from stored register        
        bool isParallelFunction = Fp->hasFnAttribute("totalNumThreads");
        if (isParallelFunction) {
		    memOut = rtl->find("memory_controller_out_stored_on_datavalid_" + port);
        } else {
		    memOut = rtl->find("memory_controller_out_" + port);
        }

		RTLSignal *memWe = rtl->find("memory_controller_write_enable_" + port);

        connectSignalToDriverInState(memWe, ZERO, this->state, instr);

        // need to truncate memory_controller_out, which is usually
        // bigger than loadWire
        RTLOp *trunc = rtl->addOp(RTLOp::Trunc);
        trunc->setCastWidth(loadWire->getWidth());
        trunc->setOperand(0, memOut);
        connectSignalToDriverInState(loadWire, trunc, endState, instr);
    }
}

void GenerateRTL::visitStoreInst(StoreInst &I) {

	Value *addr = I.getPointerOperand();
	RTLWidth w(I.getValueOperand()->getType());

	std::cout<<"Visiting Store"<<std::endl;
	I.print(outs());
	std::cout<<std::endl;

    if (LEGUP_CONFIG->isInterfacePort(addr->getName())){

    	std::string label = addr->getName().str();

    	if (!rtl->exists(label)){

			bool isInternal = LEGUP_CONFIG->isInternalInterface(label);

			rtl->addOutReg(label,w);
			rtl->addOutReg(label + "_valid",1);

			PropagatingSignals *ps = alloc->getPropagatingSignals();

			RTLSignal *temp_port_signal = new RTLSignal(label,"",w);
			temp_port_signal ->setType("output");
			PropagatingSignal propInterfacePort(temp_port_signal , isInternal, false);

			RTLSignal *temp_port_valid_signal = new RTLSignal(label + "_valid", "",1);
			temp_port_valid_signal->setType("output");
			PropagatingSignal propInterfacePortValid(temp_port_valid_signal , isInternal, false);


			ps->addPropagatingSignalToFunctionNamed(Fp->getName(),propInterfacePort);
			ps->addPropagatingSignalToFunctionNamed(Fp->getName(),propInterfacePortValid);
    	}

    	RTLOp *ext = rtl->addOp(RTLOp::ZExt);
		ext->setCastWidth(w);
		ext->setOperand(0, getOp(this->state, I.getOperand(0)));

    	connectSignalToDriverInState(rtl->find(label), ext, this->state, &I);
    	RTLSignal *validPortSignal = rtl->find(label + "_valid");
    	connectSignalToDriverInState(validPortSignal,ONE, this->state, &I);
    	validPortSignal->setDefaultDriver(ZERO);

    	return;
	}

	assert(connectedToPortB(&I) != -1 && "FU doesn't match the mem port");

	std::string port = connectedToPortB(&I) ? "b" : "a";

	RAM *ram = NULL;
	if (LEGUP_CONFIG->getParameterInt("LOCAL_RAMS")) {

		//NC changes...
		//TODO: DEBUGGING PROCEDURE IN THIS BLOCK NEEDS TO BE RE-THINKED
		ram = alloc->getLocalRamFromValue(addr);
	}

	if (ram && alloc->isRAMLocaltoFct(Fp, ram)) {
		std::string name = ram->getName();

		assert(!ram->isROM());
		// todo: refactor with visitLoadInst
		// convert byte address to word address
		RTLOp *wordAddr = rtl->addOp(RTLOp::Shr);
		wordAddr->setOperand(0, getOp(this->state, addr));
		int bytes = ram->getDataWidth() / 8;
        int ignore = (bytes == 0) ? 0 : (int)log2(bytes);
        wordAddr->setOperand(1, new RTLConst(utostr(ignore), RTLWidth(3)));

        connectSignalToDriverInState(rtl->find(name + "_address_" + port),
                                     wordAddr, this->state, &I);
        connectSignalToDriverInState(rtl->find(name + "_write_enable_" + port),
                                     ONE, this->state, &I);
        connectSignalToDriverInState(rtl->find(name + "_in_" + port),
                                     getOp(this->state, I.getOperand(0)),
                                     this->state, &I);

    } else {

        loadStoreCommon(&I, addr);
        RTLSignal *memIn = rtl->find("memory_controller_in_" + port);
        RTLSignal *memWe = rtl->find("memory_controller_write_enable_" + port);

        connectSignalToDriverInState(memWe, ONE, this->state, &I);

        // zero extend the operand to be the same size as the
        // memory_controller_in
        RTLOp *ext = rtl->addOp(RTLOp::ZExt);
        ext->setCastWidth(memIn->getWidth());
        ext->setOperand(0, getOp(this->state, I.getOperand(0)));
        connectSignalToDriverInState(memIn, ext, this->state, &I);

        // NC changes
        if (LEGUP_CONFIG->getParameterInt("INSPECT_DEBUG")) {
            int adrOffsetValue = 0;
			RTLSignal* adrSig = getOp(this->state, addr, adrOffsetValue);
			if (adrOffsetValue == 0)
				adrOffsetValue = -1;

			StateStoreInfo* storeInfo = new StateStoreInfo(this->state, port,
					adrSig, adrOffsetValue, &I);
			statesStoreMapping.push_back(storeInfo);
		}
	}
}

// size: 0 for bool/byte, 1 for short, 2 for word, 3 for long/other (struct, ptr, etc...)
unsigned GenerateRTL::getInstrMemSize(Instruction *instr) {
	int bitwidth;
	if (isa<StoreInst>(*instr)) {
		bitwidth = instr->getOperand(0)->getType()->getPrimitiveSizeInBits();
	} else {
		bitwidth = instr->getType()->getPrimitiveSizeInBits();
	}
	if (bitwidth == 0) {
		// other ie. struct, pointer
        bitwidth = alloc->getDataLayout()->getPointerSize() * 8;
	}

	switch (bitwidth) {
	case 1:
		return 0;
		break; // bool
	case 8:
		return 0;
		break; // byte
	case 16:
		return 1;
		break; // short
	case 32:
		return 2;
		break; // word
	case 64:
		return 3;
		break; // long/other
	default:
		errs() << "Invalid bitwidth '" << bitwidth << "' for instr: " << *instr
				<< "\n";
		return 0;
	}
}

void GenerateRTL::loadStoreCommon(Instruction *instr, Value *addr) {

	assert(isa<PointerType>(addr->getType()));

	assert(connectedToPortB(instr) != -1 && "FU doesn't match the mem port");
	std::string port = connectedToPortB(instr) ? "b" : "a";

	RTLSignal *memAddr = rtl->find("memory_controller_address_" + port);
    RTLSignal *memSize = rtl->find("memory_controller_size_" + port);
    RTLSignal *memEn = rtl->find("memory_controller_enable_" + port);

    connectSignalToDriverInState(memAddr, getOp(this->state, addr), this->state,
                                 instr);
    connectSignalToDriverInState(memEn, ONE, this->state, instr);

    if (alloc->usesGenericRAMs()) {
        unsigned size = getInstrMemSize(instr);
        connectSignalToDriverInState(memSize,
                                     rtl->addConst(utostr(size), RTLWidth(2)),
                                     this->state, instr);
    }
}

// ignore switch/branch/phi instructions
// these are handled already by the FSM generated in scheduling
void GenerateRTL::visitBranchInst(BranchInst &I) {
}
void GenerateRTL::visitSwitchInst(SwitchInst &I) {
}

void GenerateRTL::visitPHINode(PHINode &phi) {
}

// printf statements in C are replaced with $display() verilog statements for
// modelsim simulation
void GenerateRTL::visitPrintf(CallInst *CI, Function *called) {
	RTLOp *printf = NULL;
	if (called->getName() == "puts") {
		// puts expects a newline added
		printf = rtl->addOp(RTLOp::Display);
	} else {
		// $write() is $display() but without the newline.
		printf = rtl->addOp(RTLOp::Write);
	}
	Value *str = *CI->op_begin();

	// handle getelementptr
	if (const User *U = dyn_cast<User>(str)) {
		if (U->getNumOperands() > 1) {
			str = U->getOperand(0);
		}
	}

	GlobalVariable *G = dyn_cast<GlobalVariable>(str);
	if (!G) {
		outs() << "Cannot statically resolve char pointer for "
				<< "printf call. Skipping verilog $display statement for:\n"
				<< *CI << "\n";
		return;
	}
	assert(G);
	Constant *C = G->getInitializer();

	int index = 0;
		//errs() << "printf: " << *CA << "\n";
    //if (ConstantArray *CA = dyn_cast<ConstantArray>(C)) {
    if (ConstantDataArray *CA = dyn_cast<ConstantDataArray>(C)) {
        //errs() << "printf: " << *CA << "\n";
		// LLVM 3.4 update:
        //std::string s = "\"" + arrayToString(CA) + "\"";
		std::string st = CA->getAsString().str();
		st = st.substr(0, st.size() - 1);
		std::string s = "\"" + st + "\"";

		printf->setOperand(index, rtl->addConst(s));
		index++;
	}

	for (CallSite::arg_iterator AI = CI->op_begin() + 1, AE = CI->op_end() - 1;
			AI != AE; ++AI) {
		Value *arg = *AI;
		printf->setOperand(index, getOp(this->state, arg));
        index++;
    }

    connectSignalToDriverInState(rtl->getUnsynthesizableSignal(), printf,
                                 this->state, CI);
}

// this function is used to create function_memory_controller_out_port_instNum signal
// used to connect parallel module "instantiations"
// It creates a 2-bit shift register (for 2-cycle memory latency)
// where the MSB is asserted in the cycle when the data comes back from memory
// this needs to be stored in this cycle when sending it down to a parallel instance
// before it is overwritten by readdata for another parallel instance
// similar function, "createMemoryReaddataStorageForParallelFunction" used to create
// storage "inside" the parallel module. Both functions are needed to get the correct
// data from memory
void GenerateRTL::createMemoryReaddataLogicForParallelInstance(RTLSignal *gnt,
		const std::string name, const std::string postfix, const std::string instanceNum) {

    // 2-bit shift register
    // data is "ready" (readdata has come back)
    // when dataReady1 is asserted
	RTLSignal *dataReady0, *dataReady1;
	dataReady0 = rtl->addReg(name + "_dataReady0" + postfix + instanceNum);
	dataReady1 = rtl->addReg(name + "_dataReady1" + postfix + instanceNum);

	// read and not write
	RTLSignal *memRead = rtl->addOp(RTLOp::And)->setOperands(
			rtl->find(name + "_enable" + postfix + instanceNum),
			rtl->addOp(RTLOp::Not)->setOperands(
					rtl->find(name + "_write_enable" + postfix + instanceNum)));
	// read and granted
	RTLSignal *memReadGranted = rtl->addOp(RTLOp::And)->setOperands(gnt,
			memRead);

	RTLSignal *wait, *memoryControllerOut;
	// choose the correct memory controller signal depending on 
    // whether this function uses Pthreads or not
	if (usesPthreads) {
		wait = rtl->find("memory_controller_waitrequest_arbiter");
		memoryControllerOut = rtl->find("memory_controller_out_arbiter" + postfix);
	} else {
		wait = rtl->find("memory_controller_waitrequest");
		memoryControllerOut = rtl->find("memory_controller_out" + postfix);
	}
	
    RTLSignal *reset;
	reset = rtl->find("reset");
	RTLOp *notWait = rtl->addOp(RTLOp::Not)->setOperands(wait);

    // this signal is high one state after the read is granted
    dataReady0->addCondition(reset, ZERO);    
    dataReady0->addCondition(notWait, memReadGranted);

    // this signal is high when the data read is ready to be stored
	dataReady1->addCondition(reset, ZERO);
    // for hybrid flow
    if (LEGUP_CONFIG->isHybridFlow()) {
        // it has to be a different for the hybrid flow
        // since the top level of the hybrid sends down readdata
        // two states after the read
        // hence this
	    dataReady1->addCondition(notWait, dataReady0);
    } else {
        // for pure HW flow, the data is available on 
        // the next clock edge after dataReady0
    	dataReady1->connect(dataReady0);
    }

    // create the memory_controller_out signals to be connected
    // to a parallel instance
	RTLSignal *out = rtl->find(name + "_out" + postfix + instanceNum);
	RTLSignal *out_reg = rtl->addReg(name + "_out_reg" + postfix + instanceNum,
            RTLWidth("`MEMORY_CONTROLLER_DATA_SIZE-1"));

    // connect memory_controller_out when the data is ready
    // retain this data to avoid inferring a latch
    out->setDefaultDriver(out_reg);
    out->addCondition(
            dataReady1, 
            memoryControllerOut);
    
    // register used to avoid inferring a latch
    // stores the readdata on posedge clk
    out_reg->addCondition(reset,
            rtl->addConst("0", RTLWidth("`MEMORY_CONTROLLER_DATA_SIZE-1")));
    out_reg->addCondition(
            dataReady1,
            memoryControllerOut);
}

//create state1 and state2 to start/stop module instance and set state transitions
void GenerateRTL::createStateTransitions(CallInst *CI, State *&state1,
		State *&state2, bool &isStateTerminating) {

	BasicBlock *bb = CI->getParent();
	assert(bb == this->state->getBasicBlock());

	FiniteStateMachine* fsm = sched->getFSM(Fp);
    state1 = fsm->newState(this->state, "LEGUP_function_call");
    stateSignals[state1] = rtl->addParam("state_placeholder", "placeholder");
    state1->setBasicBlock(bb);
    //	state1->setFunctionCall(true);

    isStateTerminating = this->state->isTerminating();
    if (isStateTerminating) {
        state2 = fsm->newState(state1, "LEGUP_function_call");
		stateSignals[state2] = rtl->addParam("state_placeholder",
				"placeholder");
		state2->setBasicBlock(bb);
		state2->setTerminating(this->state->isTerminating());

		State::Transition origTransition = this->state->getTransition();
		state2->setTransition(origTransition);
	} else {
		// No need for an extra call state, just set it to the state's default transition
		state2 = this->state->getDefaultTransition();
	}
	this->state->setTerminating(false);

	// update FSM. CI will be removed from state when we return
	state1->push_back(CI);
	fsm->setStartState(CI, state1);
	fsm->setEndState(CI, state1);

	// need to clear all original transitions.
	// 'state' must have only 1 transition - because we must go to state1
	// where we'll wait for the call to complete.
	State::Transition blank;
	this->state->setTransition(blank);
	this->state->setDefaultTransition(state1);
	assert(this->state->getNumTransitions() == 1);

    state1->setDefaultTransition(state1);
}

void GenerateRTL::connectStartSignal(CallInst *CI, State *endState,
                                     const std::string moduleName,
                                     const std::string instanceName,
                                     RTLOp *oneCond, RTLOp *zeroCond) {

    RTLSignal *startReg = rtl->addReg(moduleName + "_start" + instanceName);

    // connect one in the call state
    connectSignalToDriverInStateWithCondition(startReg, ONE, this->state,
                                              oneCond, CI);

    // connect zero in the next state
    connectSignalToDriverInStateWithCondition(startReg, ZERO, endState,
                                              zeroCond);
}

int GenerateRTL::getNumThreads(const CallInst *CI) {

    int numThreads = getMetadataInt(CI, "NUMTHREADS");
    // if it's a OpenMP wrapper function,
    // don't create multiple instances
    std::string functionType = getMetadataStr(CI, "TYPE");
    if (functionType == "legup_wrapper_omp") {
        numThreads = 0;
    }

    return numThreads;
}

// given a call inst, get its metadata
// to determine the instance number
int GenerateRTL::getInstanceNum(const CallInst *CI, const int loopIndex) {

    int instanceNum;
    const int numThreads = getMetadataInt(CI, "NUMTHREADS");

    // if the loop is unrolled
    if (numThreads == 1) {
        instanceNum = getMetadataInt(CI, "THREADID");
    } else {
        instanceNum = loopIndex;
    }

    return instanceNum;
}

// prepend "_inst" to instanceNum
std::string GenerateRTL::getInstanceName(const CallInst *CI,
                                         const int loopIndex) {

    std::string functionType = getMetadataStr(CI, "TYPE");
    // if this a call to a parallel function
    // if (getMetadataInt(CI, "NUMTHREADS") && functionType !=
    // "legup_wrapper_omp")
    if (getNumThreads(CI))
        return "_inst" + utostr(getInstanceNum(CI, loopIndex));
    else
        return "";
}

RTLOp *GenerateRTL::getOpToCheckThreadID(RTLSignal *threadIDSignal,
                                         const int threadIDValue) {

    RTLOp *checkthreadID = rtl->addOp(RTLOp::EQ)->setOperands(
        threadIDSignal,
        rtl->addConst(utostr(threadIDValue), threadIDSignal->getWidth()));

    return checkthreadID;
}

// create and connect start signal for module instance
void GenerateRTL::createStartSignal(CallInst *CI, State *state1,
                                    const std::string moduleName,
                                    const int numThreads,
                                    const std::string functionType) {

    RTLSignal *wait;
    // get the waitrequest signal
    if (functionType == "legup_wrapper_pthreadcall") {
        wait = rtl->find("memory_controller_waitrequest_arbiter");
    } else {
        wait = rtl->find("memory_controller_waitrequest");
    }

    RTLOp *noWait = rtl->addOp(RTLOp::EQ)->setOperands(wait, ZERO);

    // setting up the start signal
    if (numThreads > 0) {
        // if there are parallel functions,
        // connect the start signal to all parallel instances
        for (int i = 0; i < numThreads; i++) {
            RTLOp *checkthreadID = 0;
            // for pthread_create, create Op to check threadID
            if (functionType == "legup_wrapper_pthreadcall") {
                RTLSignal *threadIDValue = getPthreadThreadID(CI, moduleName);
                checkthreadID =
                    getOpToCheckThreadID(threadIDValue, getInstanceNum(CI, i));
            }
            connectStartSignal(CI, state1, moduleName, getInstanceName(CI, i),
                               checkthreadID, noWait);
        }
    } else {
        // if sequential function,
        // just connect it to the one instance
        connectStartSignal(CI, state1, moduleName, getInstanceName(CI));
    }
}

// create and connect argument signals to module instance
void GenerateRTL::createArgumentSignals(CallInst *CI, Function *called,
                                        const std::string moduleName,
                                        const int numThreads,
                                        const std::string functionType) {

    RTLSignal *argSignal;

    // iterate through each argument
    CallSite::arg_iterator AI = CI->op_begin(), AE = CI->op_end() - 1;
    for (Function::arg_iterator FI = called->arg_begin(),
                                Fe = called->arg_end();
         FI != Fe; ++FI) {
        assert(AI != AE);
		Value *arg = *AI;
		assert(arg);

		std::string name = moduleName + "_"
				+ alloc->verilogNameFunction(FI, called);
		RTLWidth w(arg, MBW);

		// adjust width of arguments for bitcast cases
        // ie. %2 = call i8* bitcast (void (i32*, i32, i32)* @legup_memset_4 to
        // i8* (i8*, i8, i64)*)(i8* %1, i8 0, i64 40)
        multi_cycle_set_force_wire_operand(true); // Temporary solution...
        RTLSignal *argDriver = getOp(this->state, arg);
        multi_cycle_set_force_wire_operand(false);
        argDriver->setWidth(w);

        if (numThreads > 0) {
            // if there are parallel functions,
            // connect signal to all parallel instances
            for (int i = 0; i < numThreads; i++) {
                RTLOp *checkthreadID = 0;
                argSignal = rtl->addReg(name + getInstanceName(CI, i), w);
                // for pthread_create, create Op to check threadID
                if (functionType == "legup_wrapper_pthreadcall") {
                    RTLSignal *threadIDValue =
                        rtl->find(moduleName + "_threadID");
                    checkthreadID = getOpToCheckThreadID(threadIDValue,
                                                         getInstanceNum(CI, i));
                }
                connectSignalToDriverInStateWithCondition(
                    argSignal, argDriver, this->state, checkthreadID, CI);
            }
        } else {
            // if sequential function,
            // just connect it to the one instance
            connectSignalToDriverInState(rtl->addReg(name, w), argDriver,
                                         this->state, CI);
        }
        ++AI;
    }
}

RTLSignal *GenerateRTL::getPthreadThreadID(CallInst *CI,
                                           const std::string moduleName) {

    // get the threadID which is an operand of the store instruction
    // right before the call to the pthread function
    Value *threadIDValueArg;
    Instruction *threadID = CI->getPrevNode();
    if (StoreInst *st = dyn_cast<StoreInst>(threadID)) {
        if (getMetadataInt(threadID, "legup_pthread_functionthreadID")) {
            // get the value operand of the store instruction
            threadIDValueArg = st->getValueOperand();
        } else {
            assert (0 && "The Pthread function threadID cannot be found\n");
        }
    } else {
        assert (0 && "The store instruction after the call to pthread function cannot be found\n");
    }
    assert(threadIDValueArg);

    // get bottom 16 bits of the value being stored
    // this is the threadID
    RTLSignal *threadIDValue = rtl->addWire(moduleName + "_threadID", RTLWidth(16));
    RTLOp *trunc_op = rtl->addOp(RTLOp::Trunc);
    //set the cast width to the bottom 16 bits
    trunc_op->setCastWidth(RTLWidth("15", "0"));
    // get the bottom 16 bits of threadVar signal
    trunc_op->setOperand(0, getOpReg(threadIDValueArg, this->state));

    connectSignalToDriverInState(threadIDValue, trunc_op, this->state, CI);

    return threadIDValue;
}

void GenerateRTL::connectReturnSignal(State *callState, CallInst *CI,
                                      Function *calledFunction,
                                      const std::string moduleName,
                                      const int numThreads,
                                      const int loopIndex) {

    const Type *rT = calledFunction->getReturnType();
    RTLWidth T(rT);

    RTLOp *resetCond = rtl->addOp(RTLOp::Or)->setOperands(
        rtl->find("reset"),
        rtl->addOp(RTLOp::EQ)
            ->setOperands(rtl->find("cur_state"), stateSignals[this->state]));

    RTLSignal *ret = rtl->addWire(
        moduleName + "_return_val" + getInstanceName(CI, loopIndex), T);

    RTLSignal *retReg = rtl->addReg(moduleName + "_return_val" +
                                        getInstanceName(CI, loopIndex) + "_reg",
                                    T);
    retReg->addCondition(resetCond, rtl->addConst("0", T));

    RTLSignal *finish =
        rtl->find(moduleName + "_finish" + getInstanceName(CI, loopIndex));
    retReg->addCondition(finish, ret);

    if (!numThreads)
        connectSignalToDriverInState(rtl->addWire(verilogName(CI), T), retReg,
                                     callState, CI);
}

// create return signal for module instance
void GenerateRTL::createReturnSignal(State *callState, CallInst *CI,
                                     Function *called,
                                     const std::string moduleName,
                                     const int numThreads,
                                     const std::string functionType) {

    std::string instanceNum;
    // setting up return value
    const Type *rT = called->getReturnType();

    if (rT->getTypeID() != Type::VoidTyID) {
        if (numThreads > 0) {
            if (functionType == "legup_wrapper_pthreadpoll") {
                RTLWidth T(rT);
                RTLSignal *ret = rtl->addWire(moduleName + "_return_val", T);
                connectSignalToDriverInState(rtl->addWire(verilogName(CI), T),
                                             ret, callState, CI);
            } else {
                // if there are parallel functions,
                // connect the return signal to all parallel instances
                for (int i = 0; i < numThreads; i++) {

                    connectReturnSignal(callState, CI, called, moduleName,
                                        numThreads, i);
                }
            }
        } else {
            // if sequential function,
            // just connect it to the one instance
            connectReturnSignal(callState, CI, called, moduleName, numThreads);
        }
    }
}

void GenerateRTL::connectFinishSignal(CallInst *CI, RTLSignal *finish_final,
                                      const std::string moduleName,
                                      const std::string functionType,
                                      const int numThreads,
                                      std::vector<RTLSignal *> &finishVector,
                                      const int loopIndex) {

    std::string finishName = moduleName + "_finish";
    std::string instanceName = getInstanceName(CI, loopIndex);

    // adding finish signal for each instance
    RTLSignal *instanceFinishReg =
        rtl->addReg(finishName + instanceName + "_reg");
    RTLSignal *finish_inst = rtl->addWire(finishName + instanceName);

    RTLOp *resetCond;
    // To clear finish_reg signal for each instance
    if (functionType == "legup_wrapper_pthreadcall") {
        // for pthreads, since the calls are non-blocking
        // we need to clear it after it has been detected by pthread_join
        // so it's safe to clear it whenever each instance is started
        RTLSignal *start_inst = rtl->find(moduleName + "_start" + instanceName);
        resetCond =
            rtl->addOp(RTLOp::Or)->setOperands(rtl->find("reset"), start_inst);
    } else {
        // otherwise, for sequential and OpenMP functions
        // calls are blocking, hence reset in the
        // state before the call state
        resetCond = rtl->addOp(RTLOp::Or)->setOperands(
            rtl->find("reset"),
            rtl->addOp(RTLOp::EQ)->setOperands(rtl->find("cur_state"),
                                               stateSignals[this->state]));
    }

    //	if (resetCond)
    //		finishName_reg_inst <= 0;
    instanceFinishReg->addCondition(resetCond, ZERO);

    // if (finishName_inst)
    //		finishName_reg_inst <= 1'b1;
    instanceFinishReg->addCondition(finish_inst, ONE);

    // for OpenMP, you need to AND all finish signal together
    // push all signals into a vector
    if (functionType == "omp_function") {
        finishVector.push_back(instanceFinishReg);

        // if in last iteration of loop
        if (getInstanceNum(CI, loopIndex) == numThreads - 1) {
            // now AND the finish signals together
            RTLOp *op_and =
                rtl->recursivelyAddOp(RTLOp::And, finishVector, numThreads);
            finish_final->connect(op_and);
        }
    } else {
        assert(instanceFinishReg);
        finish_final->connect(instanceFinishReg);
    }
}

void GenerateRTL::createFinishSignal(CallInst *CI, State *callState,
                                     State *callEndState,
                                     const std::string moduleName,
                                     const int numThreads,
                                     const std::string functionType) {

    // create finish signal
    std::string finishName_final = moduleName + "_finish_final";
    RTLSignal *finish_final = rtl->addWire(finishName_final);

    // set the transition from callState to callEndState
    if (functionType == "legup_wrapper_pthreadcall") {
        // for pthread functions, just move onto next state
        // without checking the finish signal
        // since it's non-blocking
        callState->setDefaultTransition(callEndState);
    } else {
        // if not pthreads, check the finish signal to move to next state
        callState->setTransitionSignal(finish_final);
        callState->addTransition(callEndState);
    }

    // finish signal for pthread poll is create later
    if (functionType != "legup_wrapper_pthreadpoll") {
        vector<RTLSignal *> finishVector;
        if (numThreads > 0) {
            // for parallel functions, the finish signal from each instance
            // needs to be registered
            for (int i = 0; i < numThreads; i++) {
                connectFinishSignal(CI, finish_final, moduleName, functionType,
                                    numThreads, finishVector, i);
            }
        } else {
            // you need to register the finish signal
            // since if there is memory access to shared memory space in the
            // very last state a function
            // the finish signal goes may go high then low while the waitrequest
            // is asserted
            // in which case the calling function's FSM will be able to move
            // onto the next state due to the waitrequest
            connectFinishSignal(CI, finish_final, moduleName, functionType,
                                numThreads, finishVector);
        }
    }
}

void GenerateRTL::connectWaitrequestForParallelFunctions(
    CallInst *CI, State *callState, const std::string name,
    const std::string funcName, const std::string functionType,
    const int loopIndex) {

    std::string instanceName = getInstanceName(CI, loopIndex);

    RTLSignal *wait, *wait_local, *gnt, *gnt_reg, *gntNotGiven, *waitDriver;
    RTLOp *avalonStall;

    // waitrequest is asserted when
    // 1. this instance is accessing shared memory space and Avalon waitrequest
    // is asserted
    // 2. enable is asserted but gnt is not given
    wait_local = rtl->addWire(name + "_waitrequest" + instanceName);
    if (usesPthreads) {
        wait = rtl->find("memory_controller_waitrequest_arbiter");
    } else {
        wait = rtl->find("memory_controller_waitrequest");
    }
    RTLOp *notWait_local = rtl->addOp(RTLOp::Not)->setOperands(wait_local);

    int instanceIndex = getInstanceNum(CI, loopIndex);
    gnt =
        rtl->find(funcName + "_memory_controller_gnt_" + utostr(instanceIndex));
    gnt_reg = rtl->addReg(funcName + "_memory_controller_gnt_" +
                          utostr(instanceIndex) + "_reg");

    RTLSignal *en_a = rtl->find(name + "_enable_a" + instanceName);
    RTLSignal *en_b = rtl->find(name + "_enable_b" + instanceName);
    RTLSignal *notGnt = rtl->addOp(RTLOp::Not)->setOperands(gnt);
    RTLSignal *memAccess = rtl->addOp(RTLOp::Or)->setOperands(en_a, en_b);
    gntNotGiven = rtl->addOp(RTLOp::And)->setOperands(memAccess, notGnt);

    if (LEGUP_CONFIG->isHybridFlow()) {
        // in hybrid case, waitrequest is asserted when
        // there is a memory request but the grant is not given at the current
        // level
        // or when there is an waitrequest over avalon from parent module
        // for avalon waitrequest, grant is registered since Avalon memory
        // accesses
        // are pipelined, hence the avalon waitrequest comes one state after
        // memory request from current level
        gnt_reg->addCondition(notWait_local, gnt);
        avalonStall = rtl->addOp(RTLOp::And)->setOperands(wait, gnt_reg);
        waitDriver =
            rtl->addOp(RTLOp::Or)->setOperands(gntNotGiven, avalonStall);
    } else {
        // pure HW case, waitrequest is asserted when
        // there is a memory request but the grant is not given at the current
        // level
        // or when the grant is given but wait request is asserted from the
        // parent module
        // (this happens when the grant is not given from the parent module)
        waitDriver = rtl->addOp(RTLOp::Or)->setOperands(
            gntNotGiven, rtl->addOp(RTLOp::And)->setOperands(gnt, wait));
    }

    assert(waitDriver);
    // connect waitrequest signal
    if (functionType == "legup_wrapper_pthreadcall") {
        // can't check the state for pthreads case
        // as the FSM will be moving to execute other things with the
        // pthread instances running in parallel
        wait_local->connect(waitDriver);
    } else {
        connectSignalToDriverInState(wait_local, waitDriver, callState, CI);
    }
}

void GenerateRTL::createWaitrequestLogic(CallInst *CI, State *callState,
                                         std::string name, const int numThreads,
                                         const std::string functionType) {

    std::string funcName;
    Function *called = CI->getCalledFunction();
    if (!called) {
        // indirect call, for example:
        // tail call void bitcast (i32 (...)* @exit to void (i32)*)(i32 1)
        // noreturn nounwind
        Value *Callee = CI->getCalledValue();
		if (ConstantExpr *CE = dyn_cast<ConstantExpr>(Callee)) {
			if (Function *RF = dyn_cast<Function>(CE->getOperand(0))) {
				funcName = RF->getName();
			}
		}
	} else {
		funcName = called->getName();
	}

	PropagatingSignals *ps = alloc->getPropagatingSignals();
	bool shouldConnectMemorySignals = ps->functionUsesMemory(funcName)
			|| usesPthreads;

    stripInvalidCharacters(funcName);

    // setting up the waitrequest signal
    if (numThreads > 0) {
        for (int i = 0; i < numThreads; i++) {

            connectWaitrequestForParallelFunctions(CI, callState, name,
                                                   funcName, functionType, i);
        }
    } else if (shouldConnectMemorySignals) {
        RTLSignal *wait_local = rtl->addWire(name + "_waitrequest");
        // connectSignalToDriverInState(wait_local,
        // rtl->find("memory_controller_waitrequest"), callState, CI);
        wait_local->connect(rtl->find("memory_controller_waitrequest"));
    }
}

// connect pthreadID and functionID signals to operand
// based on state
void GenerateRTL::connectPthreadIDSignals(CallInst *CI, RTLSignal *pollThreadID,
                                          RTLSignal *pollFunctionID) {

    // get the state in which the wrapper is called
    State *callState = fsm->getEndState(CI);

    // get the thread variable from the call instruction
    Value *threadVar = CI->getArgOperand(0);
    assert(threadVar);

    // get and connect threadID signal from the bottom half
    // of thread variable
    RTLOp *op = selectTopOrBottomHalfBits(threadVar, callState, false);
    connectSignalToDriverInState(pollThreadID, op, callState, CI);

    // get and connect functionID signal from the top half
    // of thread variable
    RTLOp *op2 = selectTopOrBottomHalfBits(threadVar, callState, true);
    connectSignalToDriverInState(pollFunctionID, op2, callState, CI);
}

RTLOp *GenerateRTL::selectTopOrBottomHalfBits(Value *V, State *state,
                                              bool top) {

    // get the RTLSignal for that value
    RTLSignal *signal = getOpReg(V, state);

    RTLOp *op;
    RTLConst *constant;

    // if V is a constant int
    if (dyn_cast<ConstantInt>(V)) {
        if (top) {
            // if you want the top half, then
            // right shift by half the bitwidth
            op = rtl->addOp(RTLOp::Shr);
            constant = rtl->addConst(utostr(16), RTLWidth("4", "0"));
        } else {
            // if you want the bottom half, then
            // AND with FFFF
            op = rtl->addOp(RTLOp::And);
            constant = rtl->addConst(utostr(0xFFFF), RTLWidth("15", "0"));
        }
        op->setOperands(signal, constant);
    } else {
        // else if it's a signal
        // then select the correct width
        op = rtl->addOp(RTLOp::Trunc);
        if (top) {
            op->setCastWidth(RTLWidth("31", "16"));
        } else {
            op->setCastWidth(RTLWidth("15", "0"));
        }
        op->setOperand(0, signal);
    }

    return op;
}

void GenerateRTL::connectPthreadPollFinishAndReturnVal(
    CallInst *CI, RTLSignal *pollThreadID, RTLSignal *pollFunctionID) {

    /*
    we want to make the following signals for finish
    when there are two functions, A & B, each with two threads,
    legup_pthreadpoll_finish = 0;
    if (legup_pthreadpoll_threadID == 0 && legup_pthreadpoll_functionID == 0 &&
    legup_pthreadcall_A_finish_final0 == 1)
          legup_pthreadpoll_finish = 1;
    if (legup_pthreadpoll_threadID == 1 && legup_pthreadpoll_functionID == 0 &&
    legup_pthreadcall_A_finish_final1 == 1)
          legup_pthreadpoll_finish = 1;
    if (legup_pthreadpoll_threadID == 0 && legup_pthreadpoll_functionID == 1 &&
    legup_pthreadcall_B_finish_final0 == 1)
          legup_pthreadpoll_finish = 1;
    if (legup_pthreadpoll_threadID == 1 && legup_pthreadpoll_functionID == 1 &&
    legup_pthreadcall_B_finish_final1 == 1)
          legup_pthreadpoll_finish = 1;

    also make the following signals for return_val
    when there are two functions, A & B, each with two threads,
    legup_pthreadpoll_return_val = 0;
    if (legup_pthreadpoll_threadID == 0 && legup_pthreadpoll_functionID == 0 &&
    legup_pthreadcall_A_finish_final0 == 1)
          legup_pthreadpoll_return_val = legup_pthreadcall_A_return_val_inst0;
    if (legup_pthreadpoll_threadID == 1 && legup_pthreadpoll_functionID == 0 &&
    legup_pthreadcall_A_finish_final1 == 1)
          legup_pthreadpoll_return_val = legup_pthreadcall_A_return_val_inst1;
    if (legup_pthreadpoll_threadID == 0 && legup_pthreadpoll_functionID == 1 &&
    legup_pthreadcall_B_finish_final0 == 1)
          legup_pthreadpoll_return_val = legup_pthreadcall_B_return_val_inst0;
    if (legup_pthreadpoll_threadID == 1 && legup_pthreadpoll_functionID == 1 &&
    legup_pthreadcall_B_finish_final1 == 1)
          legup_pthreadpoll_return_val = legup_pthreadcall_B_return_val_inst1;
    */

    // get the name of the pthread function
    std::string pthreadFuncName = CI->getCalledFunction()->getName();

    // get the number of threads for that pthread function
    int numThreads = getNumThreads(CI);

    // find the finish signal for pthread polling wrapper
    RTLSignal *finish = rtl->addWire("legup_pthreadpoll_finish_final");
    finish->setDefaultDriver(ZERO);

    // iterate through each thread of the pthread function
    for (int i = 0; i < numThreads; i++) {

        std::string instNum = utostr(getInstanceNum(CI, i));

        // find the finish signal from pthread calling wrapper
        RTLSignal *pthreadCallFinish =
            rtl->addWire(pthreadFuncName + "_finish_inst" + instNum + "_reg");

        // if (legup_pthreadpoll_threadID == 0 &&
        // legup_pthreadcall_A_finish_final0 == 1)
        //       legup_pthreadpoll_finish = 1;
        RTLSignal *finishCond = rtl->addOp(RTLOp::And)->setOperands(
            rtl->addOp(RTLOp::EQ)->setOperands(
                pollThreadID, rtl->addConst(instNum, RTLWidth(16))),
            pthreadCallFinish);

        // if there is more than one function in the pthread polling wrapper
        // need to check the functionID as well
        // if (legup_pthreadpoll_functionID == 0 && legup_pthreadpoll_threadID
        // == 0 && legup_pthreadcall_A_finish_final0 == 1)
        //       legup_pthreadpoll_finish = 1;
        //
        // get the functionID for this pthread function
        int functionID = getMetadataInt(CI, "FUNCTIONID");
        RTLSignal *functionIDCond = rtl->addOp(RTLOp::EQ)->setOperands(
            pollFunctionID, rtl->addConst(utostr(functionID), RTLWidth(16)));

        RTLSignal *finishCond_final =
            rtl->addOp(RTLOp::And)->setOperands(finishCond, functionIDCond);

        finish->addCondition(finishCond_final, ONE);

        // if there are any non-void pthead functions
        // connect the return value signal
        if (!CI->getCalledFunction()->getReturnType()->isVoidTy()) {
            const Type *rT =
                PointerType::get(IntegerType::get(CI->getContext(), 8), 0);
            // make the return val signal
            RTLSignal *pthreadReturnVal =
                rtl->addWire("legup_pthreadpoll_return_val", RTLWidth(rT));
            // set default to 0
            pthreadReturnVal->setDefaultDriver(
                rtl->addConst(utostr(0), RTLWidth(rT)));
            // add register for return val
            RTLSignal *pthreadReturnVal_reg = rtl->addWire(
                pthreadFuncName + "_return_val_inst" + instNum + "_reg",
                RTLWidth(rT));
            // connect register if instance is finished
            pthreadReturnVal->addCondition(finishCond_final,
                                           pthreadReturnVal_reg);

            // could move this entire function to merge into createfunction
            // rather than having something separate for pthreads..
        }
    }
}

void GenerateRTL::createPthreadSignals(CallInst *CI) {

    // create a signal for threadID
    RTLSignal *pollThreadID =
        rtl->addWire("legup_pthreadpoll_threadID", RTLWidth(16));
    // create a signal for functionID
    RTLSignal *pollFunctionID =
        rtl->addWire("legup_pthreadpoll_functionID", RTLWidth(16));

    // get the type of this function
    std::string functionType = getMetadataStr(CI, "TYPE");

    if (functionType == "legup_wrapper_pthreadpoll") {
        // connect pthreadpoll threadID and functionID
        connectPthreadIDSignals(CI, pollThreadID, pollFunctionID);
    }

    if (functionType == "legup_wrapper_pthreadcall") {
        // connect finish and return val signals
        connectPthreadPollFinishAndReturnVal(CI, pollThreadID, pollFunctionID);
    }
}

void GenerateRTL::connectFunctionMemorySignals(
    State *callState, CallInst *CI, std::string name, std::string postfix,
    const int numThreads, const std::string functionType, const int loopIndex) {

    std::string instanceName = getInstanceName(CI, loopIndex);

    // creating memory_controller signals
    RTLSignal *en = rtl->addWire(name + "_enable" + postfix + instanceName);
    RTLSignal *we =
        rtl->addWire(name + "_write_enable" + postfix + instanceName);
    RTLSignal *addr = rtl->addWire(name + "_address" + postfix + instanceName,
                                   RTLWidth("`MEMORY_CONTROLLER_ADDR_SIZE-1"));
    RTLSignal *in = rtl->addWire(name + "_in" + postfix + instanceName,
                                 RTLWidth("`MEMORY_CONTROLLER_DATA_SIZE-1"));
    RTLSignal *out = rtl->addWire(name + "_out" + postfix + instanceName,
                                  RTLWidth("`MEMORY_CONTROLLER_DATA_SIZE-1"));

    RTLSignal *gnt;
    if (numThreads) {
        // for parallel functions, an arbiter is used to grant memory accesses
        gnt = rtl->addWire(name + "_gnt_" +
                           utostr(getInstanceNum(CI, loopIndex)));
        // this decides which data is sent down to memory_controller_out
        // in which cycle
        createMemoryReaddataLogicForParallelInstance(gnt, name, postfix,
                                                     instanceName);
    } else {
        // for sequential functions, just connect memory_controller_out directly
        connectSignalToDriverInState(
            out, rtl->find("memory_controller_out" + postfix), callState, CI);
    }

    RTLOp *eq = NULL;
    if (functionType == "omp_function" && numThreads) {
        // for OpenMP, you need to check the gnt signal and the state
        // since multiple instances are started in the same state
        // (gnt0 == 1) ...
        eq = rtl->addOp(RTLOp::EQ)->setOperands(gnt, ONE);
    }

    // pthread functions are treated specially
    // since they connect to memory_controller_*_arbiter_postfix
    if (functionType != "legup_wrapper_pthreadcall") {
        // Check cur_state == state && gnt0 == 1 for OpenMP
        // Check cur_state == state for Pthreads and sequential functions
        connectSignalToDriverInStateWithCondition(
            rtl->find("memory_controller_enable" + postfix), en, callState, eq,
            CI);
        connectSignalToDriverInStateWithCondition(
            rtl->find("memory_controller_write_enable" + postfix), we,
            callState, eq, CI);
        connectSignalToDriverInStateWithCondition(
            rtl->find("memory_controller_address" + postfix), addr, callState,
            eq, CI);
        connectSignalToDriverInStateWithCondition(
            rtl->find("memory_controller_in" + postfix), in, callState, eq, CI);
        if (alloc->usesGenericRAMs()) {
            // creating memory_controller_size_inst signals
            RTLSignal *size = rtl->addWire(
                name + "_size" + postfix + instanceName, RTLWidth(2));
            size->setDefaultDriver(ZERO);
            connectSignalToDriverInStateWithCondition(
                rtl->find("memory_controller_size" + postfix), size, callState,
                eq);
        }
    }
}

// create memory controller signals for the function and
// connect them to parent function's memory signals
void GenerateRTL::createFunctionMemorySignals(State *callState, CallInst *CI,
                                              std::string name,
                                              std::string postfix,
                                              const int numThreads,
                                              const std::string functionType) {

    std::string funcName;
    Function *called = CI->getCalledFunction();
    if (!called) {
        // indirect call, for example:
        // tail call void bitcast (i32 (...)* @exit to void (i32)*)(i32 1)
        // noreturn nounwind
        Value *Callee = CI->getCalledValue();
		if (ConstantExpr *CE = dyn_cast<ConstantExpr>(Callee)) {
			if (Function *RF = dyn_cast<Function>(CE->getOperand(0))) {
				funcName = RF->getName();
			}
		}
	} else {
		funcName = called->getName();
	}

	PropagatingSignals *ps = alloc->getPropagatingSignals();
	bool shouldConnectMemorySignals = ps->functionUsesMemory(funcName)
			|| usesPthreads;

    stripInvalidCharacters(funcName);

    if (numThreads > 0) {
        for (int i = 0; i < numThreads; i++) {
            connectFunctionMemorySignals(callState, CI, name, postfix,
                                         numThreads, functionType, i);
        }
    } else if (shouldConnectMemorySignals) {
        connectFunctionMemorySignals(callState, CI, name, postfix, numThreads,
                                     functionType);
    }
}

void GenerateRTL::createFunctionPropagatingSignals(
    State *state1, CallInst *CI, std::string name, const int parallelInstances,
    const std::string functionType) {

    std::string instanceNum, funcName;
    Function *called = CI->getCalledFunction();
	if (!called) {
		// indirect call, for example:
		// tail call void bitcast (i32 (...)* @exit to void (i32)*)(i32 1) noreturn nounwind
		Value *Callee = CI->getCalledValue();
		if (ConstantExpr *CE = dyn_cast<ConstantExpr>(Callee)) {
			if (Function *RF = dyn_cast<Function>(CE->getOperand(0))) {
				funcName = RF->getName();
			}
		}
	} else {
		funcName = called->getName();
	}

	// Get a pointer to the PropagatingSignals singleton
	//
	PropagatingSignals *ps = alloc->getPropagatingSignals();
	std::vector<PropagatingSignal *> propagatingSignals =
			ps->getPropagatingSignalsForFunctionNamed(funcName);

    stripInvalidCharacters(funcName);
        
	// Iterate through propagating signals and add wires and states for them
	//
    for (std::vector<PropagatingSignal *>::iterator si =
             propagatingSignals.begin();
         si != propagatingSignals.end(); ++si) {

        PropagatingSignal *propSignal = *si;
        std::string signalType = propSignal->getType();

        // TODO: Instead, use parallelInstances variable and generate arbitrator
        //
        if (propSignal->isMemory() && usesPthreads)
            continue;

        // if the signal is an output, only one module can have access to it
        // at a single time, so we must add it to the state machine
        //
        if (signalType == "output") {

            RTLSignal *connection =
                rtl->addWire(funcName + "_" + propSignal->getName(),
                             propSignal->getSignal()->getWidth());
            RTLSignal *outputPort;
            outputPort = rtl->find(propSignal->getName());
            connectSignalToDriverInState(outputPort, connection, state1, CI,
                                         INPUT_READY, true);
        }
    }
}

// calling semantics: when calling a function there are 2 states
// 1) assign inputs/outputs of the module. set start=1
// 2) wait until finish=1
//    make sure ram signals registers are connected
void GenerateRTL::createFunction(CallInst &I) {

    CallInst *CI = &I;

    Function *called = getCalledFunction(CI);

    // get the number of parallel instances of this function
    std::string functionType = getMetadataStr(CI, "TYPE");

    int numThreads = getNumThreads(CI);

    State *callState, *callEndState = NULL;
    bool isStateTerminating;

    createStateTransitions(CI, callState, callEndState, isStateTerminating);

    std::string moduleName = verilogName(called);

    createStartSignal(CI, callState, moduleName, numThreads, functionType);

    std::string name = moduleName + "_" + "memory_controller";

    if (functionType != "legup_wrapper_pthreadpoll") {

        // setting up argument signals
        createArgumentSignals(CI, called, moduleName, numThreads, functionType);

        // MATHEW: Is there a better way to do this?
        if (!(LEGUP_CONFIG->isCustomVerilog(*called) &&
              !(LEGUP_CONFIG->customVerilogUsesMemory(*called)))) {

            // Setting up the memory controller signals
            createFunctionMemorySignals(callState, CI, name, "_a", numThreads,
                                        functionType);
            createFunctionMemorySignals(callState, CI, name, "_b", numThreads,
                                        functionType);

            // create waitrequest logic
            createWaitrequestLogic(CI, callState, name, numThreads,
                                   functionType);
        }

        // MATHEW: Please generalize this to work for openmp
        if (functionType != "legup_wrapper_omp" &&
            functionType != "omp_function") {
            // setting up propagating signals
            createFunctionPropagatingSignals(callState, CI, name, numThreads,
                                             functionType);
        }
    }

    createFinishSignal(CI, callState, callEndState, moduleName, numThreads,
                       functionType);

    createReturnSignal(callState, CI, called, moduleName, numThreads,
                       functionType);

    // signal for disabling the divider and other multicycle functional units
    // for two states while we call the function
    RTLSignal *fct_call = rtl->addWire("legup_function_call");
    fct_call->setDefaultDriver(ZERO);
    connectSignalToDriverInState(fct_call, ONE, callState, CI);
    if (isStateTerminating) {
        connectSignalToDriverInState(fct_call, ONE, callEndState, CI);
    }
}

void GenerateRTL::visitCallInst(CallInst &CI) {
	Function *called = getCalledFunction(&CI);

	if (called->getName() == "printf" || called->getName() == "puts") {
		visitPrintf(&CI, called);

	} else if (called->getName() == "putchar") {
		unsigned char C = cast<ConstantInt>(CI.getOperand(1))->getZExtValue();
		bool LastWasHex = false;

        RTLOp *write = rtl->addOp(RTLOp::Write);
        write->setOperand(0, rtl->addConst(charToString(C, LastWasHex)));

        connectSignalToDriverInState(rtl->getUnsynthesizableSignal(), write,
                                     this->state, &CI);

    } else if (called->getName() == "exit") {

        RTLSignal *finish = rtl->addOp(RTLOp::Finish);

        connectSignalToDriverInState(rtl->getUnsynthesizableSignal(), finish,
                                     this->state, &CI);

    } else if (isaDummyCall(&CI)) {
        // ignore
    } else {
		// normal function calls are already handled by generateAllCallInsts
	}
}

// get the first state of this basic block
State *GenerateRTL::getFirstState(BasicBlock *BB) {
	for (FiniteStateMachine::iterator state = ++fsm->begin(), se = fsm->end();
			state != se; ++state) {
		if (state->getBasicBlock() == BB)
			return state;
	}
	assert(0 && "Couldn't find state for BB");
}

void GenerateRTL::modifyFSMForAllLoopPipelines() {
	std::set<BasicBlock *> visited;

	for (FiniteStateMachine::iterator state = ++fsm->begin(), se = fsm->end();
			state != se; ++state) {
		for (State::iterator instr = state->begin(), ie = state->end();
				instr != ie; ++instr) {
			BasicBlock *BB = (*instr)->getParent();
			if (visited.find(BB) != visited.end())
				continue;
			visited.insert(BB);
			if (getMetadataInt(BB->getTerminator(), "legup.pipelined")) {
				this->pipelinedBBs.insert(BB);
				assert(getFirstState(BB) == state);
			}
		}
	}

	for (std::set<BasicBlock *>::iterator BB = this->pipelinedBBs.begin(), be =
			this->pipelinedBBs.end(); BB != be; ++BB) {
		modifyFSMForLoopPipeline(*BB);
	}
}

void GenerateRTL::generateAllLoopPipelines() {
	pipeRTLFile() << "Found " << this->pipelinedBBs.size()
			<< " loops to pipeline\n";

	for (std::set<BasicBlock *>::iterator BB = this->pipelinedBBs.begin(), be =
			this->pipelinedBBs.end(); BB != be; ++BB) {
		generateLoopPipeline(*BB);
	}

}

// there are two possibilities for the loop bounds:
// 1) there is a constant bound - just use the tripCount from the metadata
// 2) there is a variable bound - use LoopInfo to get the tripCount LLVM value
//    The LLVM IR will look like:
//      %indvar = phi i32 [ %indvar.next, %.lr.ph ], [ 0, %.lr.ph.preheader ]
//      %indvar.next = add i32 %indvar, 1
//      %exitcond = icmp eq i32 %13, %bound
RTLSignal* GenerateRTL::getLoopExitCond(BasicBlock *BB, RTLSignal *indvar) {
	const Instruction *inductionVar = getInductionVar(BB);
	RTLWidth inductionWidth = RTLWidth(inductionVar->getType());
	TerminatorInst *TI = BB->getTerminator();

	RTLSignal *bound = NULL;

	int tripCount = getMetadataInt(TI, "legup.tripCount");
	if (tripCount > 0) {
		pipeRTLFile() << "Constant tripCount: " << tripCount << "\n";
		bound = new RTLConst(utostr(tripCount - 1), inductionWidth);

	} else {

		LoopInfo *LI = alloc->getLI(BB->getParent());
		assert(LI);

		Loop *loop = LI->getLoopFor(BB);
		// TODO: LLVM 3.4 update: getTripCount() has been removed.
		// reproduce it here to get same functionality
        //Value *tripCountVal = loop->getTripCount();

		Value *tripCountVal = 0;

		PHINode *IV = loop->getCanonicalInductionVariable();
		if (IV == 0 || IV->getNumIncomingValues() != 2)
		{
			tripCountVal = 0;
		}
		else
		{
			bool P0InLoop = loop->contains(IV->getIncomingBlock(0));
			Value *Inc = IV->getIncomingValue(!P0InLoop);
			BasicBlock *BackedgeBlock = IV->getIncomingBlock(!P0InLoop);

			if (BranchInst *BI = dyn_cast<BranchInst>(BackedgeBlock->getTerminator())) {
				if (BI->isConditional()) {
					if (ICmpInst *ICI = dyn_cast<ICmpInst>(BI->getCondition())) {
						if (ICI->getOperand(0) == Inc) {
							if (BI->getSuccessor(0) == loop->getHeader()) {
								if (ICI->getPredicate() == ICmpInst::ICMP_NE)
									tripCountVal = ICI->getOperand(1);
							} else if (ICI->getPredicate() == ICmpInst::ICMP_EQ) {
								tripCountVal = ICI->getOperand(1);
							}
						}
					}
				}
			}
		}
		// TODO: end LLVM 3.4 update changes



		//errs() << "isLoopSimplifyForm?: " << loop->isLoopSimplifyForm() << "\n";

		if (tripCountVal) {

			pipeRTLFile() << "Variable tripCount: " << *tripCountVal << "\n";

			bound = rtl->addOp(RTLOp::Sub)->setOperands(
					rtl->find(verilogName(tripCountVal)),
					rtl->addConst("1", inductionWidth));

		} else {
			// use the signals manually. For instance (%13 is loop-invariant
			// from outside the loop BB):
			//      %tmp248 = add i32 %tmp178, %indvar237
			//      %16 = icmp sgt i32 %tmp248, %13
			//      br i1 %16, label %loopexit, label %loop
			//assert(TI->getNumTransitions() == 2);
			//

			ICmpInst *cmp = dyn_cast<ICmpInst>(TI->getOperand(0));
			assert(cmp);

			Value *op0val = cmp->getOperand(0);
			Value *op1val = cmp->getOperand(1);

			State *pipelineWaitState = getFirstState(BB);
			assert(pipelineWaitState->isWaitingForPipeline());

			RTLSignal *op0 = NULL;
			if (isPipelined(op0val)) {
				op0 = getPipelineSignal(op0val, 0);
				assert(
						op0
								&& "Branch condition operation not available at time=0");
			} else {
				op0 = getOp(pipelineWaitState, op0val);
			}

			RTLSignal *op1 = NULL;
			if (isPipelined(op1val)) {
				op1 = getPipelineSignal(op1val, 0);
				assert(
						op1
								&& "Branch condition operation not available at time=0");
			} else {
				op1 = getOp(pipelineWaitState, op1val);
			}

			return rtl->addOp(cmp)->setOperands(op0, op1);

		}
	}

	return rtl->addOp(RTLOp::EQ)->setOperands(indvar, bound);

}

// if the function has memory then returns waitrequest signal
// otherwise returns 0 (to ignore the waitrequest)
RTLSignal* GenerateRTL::getWaitRequest(Function *F) {
	PropagatingSignals *ps = alloc->getPropagatingSignals();
	RTLSignal *waitrequest;
	std::string functionName = F->getName().str();
	if (ps->functionUsesMemory(functionName)) {
		waitrequest = rtl->find("memory_controller_waitrequest");
	} else {
		waitrequest = ZERO;
	}
	return waitrequest;
}

// this function generates all the control signals and registers
// required for the loop pipeline for basic block BB
// the main control signals are:
//      ii_state = 0, 1, 2, 3, ..., II-1, 0, 1, 2, ..., II-1, ...
//      valid_bit_0 -> valid_bit_1 -> ... -> valid_bit_maxTime (shift register)
// using these signals you can turn on an operation for a particular stage of
// the pipeline. valid_bit makes sure the inputs are valid for that time slot,
// and the ii_state makes sure you only perform the operation once per pipeline
// stage.
//
void GenerateRTL::generateLoopPipeline(BasicBlock *BB) {

	const Instruction *inductionVar = getInductionVar(BB);

	//rtl->addRegLEGUP_pipeline_start

	TerminatorInst *TI = BB->getTerminator();
	int II = getMetadataInt(TI, "legup.II");
	int totalTime = getMetadataInt(TI, "legup.totalTime");
	int maxStage = getMetadataInt(TI, "legup.maxStage");
//    std::string label = getMetadataStr(TI, "legup.label");
	std::string label = getPipelineLabel(BB);

	// generate valid bits

	pipeRTLFile() << "Generating Loop Pipeline for label: \"" << label
			<< "\"\n";
	pipeRTLFile() << "BB: " << getLabel(BB) << "\n";
	pipeRTLFile() << "II: " << II << "\n";
	pipeRTLFile() << "Time: " << totalTime << "\n";
	pipeRTLFile() << "maxStage: " << maxStage << "\n";
	pipeRTLFile() << "Induction var: " << *inductionVar << "\n";
	pipeRTLFile() << "Label: " << label << "\n";

	RTLSignal *waitrequest = rtl->addOp(RTLOp::EQ)->setOperands(
			getWaitRequest(BB->getParent()), ZERO);

	RTLSignal *start = rtl->addWire(label + "_pipeline_start");
	start->setDefaultDriver(ZERO);
	start->addCondition(rtl->find("reset"), ZERO);

	// started bit is high when pipeline is active
	RTLSignal *started = rtl->addReg(label + "_started");
	started->addCondition(rtl->find("reset"), ZERO);

	// begin = (start & ~started & ~waitrequest)
	RTLOp *not_started = rtl->addOp(RTLOp::Not)->setOperands(started);
	RTLOp *begin = rtl->addOp(RTLOp::And)->setOperands(waitrequest,
			rtl->addOp(RTLOp::And)->setOperands(start, not_started));
//    RTLOp *begin = rtl->addOp(RTLOp::And)->setOperands(start, not_started);

	started->addCondition(begin, ONE);

	// ii_state = 0, 1, 2, 3, ..., II-1, 0, 1, 2, ..., II-1, ...
	RTLWidth ii_state_width = RTLWidth(requiredBits(II - 1));
	RTLSignal *ii_state = rtl->addReg(label + "_ii_state", ii_state_width);
	ii_state->addCondition(rtl->find("reset"),
			new RTLConst("0", ii_state_width));
	ii_state->addCondition(begin, new RTLConst("0", ii_state_width));
	for (int i = 1; i <= II; i++) {
		// ii_state == i-1
		RTLOp *eq = rtl->addOp(RTLOp::And)->setOperands(waitrequest,
				rtl->addOp(RTLOp::EQ)->setOperands(ii_state,
						new RTLConst(utostr(i - 1), ii_state_width)));
//        RTLOp *eq = rtl->addOp(RTLOp::EQ)->setOperands( ii_state, new
		//              RTLConst(utostr(i-1), ii_state_width));
		int next = (i == II) ? 0 : i;
		ii_state->addCondition(eq, new RTLConst(utostr(next), ii_state_width));
	}

	// generate induction variable for stages
	map<int, RTLSignal*> inductionVarStages;
	// can't use this minimum width - if the induction variable gets used
	// by another instruction there will be a bitwidth mismatch
	//RTLWidth inductionWidth = RTLWidth(requiredBits(tripCount-1));
	RTLWidth inductionWidth = RTLWidth(inductionVar->getType());
	RTLConst *ZERO_induction = new RTLConst("0", inductionWidth);
	inductionVarStages[0] = rtl->addReg(label + "_i_stage0", inductionWidth);
	inductionVarStages[0]->addCondition(rtl->find("reset"), ZERO_induction);

	// epilogue bit is high when the epilogue has started
	RTLSignal *epilogue = rtl->addReg(label + "_epilogue");
	epilogue->addCondition(rtl->find("reset"), ZERO);

	// generate the valid shift register
	// high when data is valid on the pipeline step
	/*
	 valid_bit_1 <= valid_bit_0;
	 valid_bit_2 <= valid_bit_1;
	 valid_bit_3 <= valid_bit_2;
	 valid_bit_4 <= valid_bit_3;
	 valid_bit_5 <= valid_bit_4;
	 valid_bit_6 <= valid_bit_5;
	 */
	std::vector<RTLSignal *> validBits;
	for (int i = 0; i < totalTime; i++) {
		validBits.push_back(rtl->addReg(label + "_valid_bit_" + utostr(i)));
		if (i > 0) {
			//intialize on reset
			validBits.at(i)->addCondition(waitrequest, validBits.at(i - 1));
			//validBits.at(i)->connect(validBits.at(i-1));
			validBits.at(i)->addCondition(rtl->find("reset"), ZERO); //reset needs to be added after to avoid X assertion
		}
	}

	// if (start & ~started)
	//    i_stage0 <= 0;
	inductionVarStages[0]->addCondition(begin, ZERO_induction);
	RTLOp *lastII = rtl->addOp(RTLOp::And)->setOperands(waitrequest,
			rtl->addOp(RTLOp::EQ)->setOperands(ii_state,
					new RTLConst(utostr(II - 1), ii_state_width)));
//    RTLOp *lastII = rtl->addOp(RTLOp::EQ)->setOperands( ii_state, new
//            RTLConst(utostr(II-1), ii_state_width));
	RTLOp *incrementCond = rtl->addOp(RTLOp::And)->setOperands(waitrequest,
			rtl->addOp(RTLOp::And)->setOperands(lastII, validBits.at(II - 1)));
//    RTLOp *incrementCond = rtl->addOp(RTLOp::And)->setOperands( lastII,
//            validBits.at(II-1));
	RTLOp *incrementInduction = rtl->addOp(RTLOp::Add)->setOperands(
			inductionVarStages[0], ONE);
	// else if (ii_state == 2 & valid_bit_2 == 1)
	//    i_stage0 <= i_stage0 + 1;
	inductionVarStages[0]->addCondition(incrementCond, incrementInduction);

	/* if (ii_state == 2) begin
	 i_stage1 <= i_stage0;
	 i_stage2 <= i_stage1;
	 end */
	for (int i = 1; i <= maxStage; i++) {
		inductionVarStages[i] = rtl->addReg(label + "_i_stage" + utostr(i),
				inductionWidth);
		inductionVarStages[i]->addCondition(begin, ZERO_induction);
		inductionVarStages[i]->addCondition(lastII, inductionVarStages[i - 1]);
	}

	// add reset logic
	for (int i = 0; i <= maxStage; i++) {
		inductionVarStages[i]->addCondition(rtl->find("reset"), ZERO_induction);
	}

	//rtl->find(verilogName(inductionVar)+"_reg")->connect(inductionVarStages[maxStage]);

	// every variable which gets used in another stage must be flopped
	findAllPipelineStageRegisters(BB);

	RTLSignal *exitCondBoundCheck = rtl->addWire(label + "_pipeline_exit_cond");
	exitCondBoundCheck->connect(getLoopExitCond(BB, inductionVarStages[0]));

	//RTLSignal *exitcond = rtl->find(verilogName(TI->getOperand(0)));
	RTLOp *exitcond = rtl->addOp(RTLOp::And)->setOperands(waitrequest,
			rtl->addOp(RTLOp::And)->setOperands(started,
					rtl->addOp(RTLOp::And)->setOperands(
					// don't check the loop bound until we have completed at
					// least II cycles
							rtl->addOp(RTLOp::EQ)->setOperands(ii_state,
									new RTLConst("0", ii_state_width)),

							exitCondBoundCheck)));

	/*    RTLOp *exitcond = rtl->addOp(RTLOp::EQ)->setOperands(
	 inductionVarStages[0],
	 new RTLConst(utostr(tripCount-1),
	 inductionWidth));*/
	RTLSignal *not_exitcond = rtl->addOp(RTLOp::Not)->setOperands(exitcond);

	epilogue->addCondition(exitcond, ONE);

	// if ((start & ~started) | (started & ~epilogue & i_stage0 != 3))
	RTLSignal *not_epilogue = rtl->addOp(RTLOp::Not)->setOperands(epilogue);
	RTLSignal *done1 = rtl->addOp(RTLOp::And)->setOperands(started,
			not_epilogue);
//    RTLSignal *done2 = rtl->addOp(RTLOp::And)->setOperands(waitrequest, 
//		rtl->addOp(RTLOp::And)->setOperands(done1, not_exitcond));
	RTLSignal *done2 = rtl->addOp(RTLOp::And)->setOperands(done1, not_exitcond);
	RTLSignal *valid = rtl->addOp(RTLOp::Or)->setOperands(begin, done2);
//    validBits.at(0)->connect(valid);
	//validBits.at(0)->addCondition(rtl->addOp(RTLOp::EQ)->setOperands(rtl->find("reset"), ZERO), valid);
//    validBits.at(0)->setDefaultDriver(valid);
	validBits.at(0)->addCondition(waitrequest, valid);
	validBits.at(0)->addCondition(rtl->find("reset"), ZERO); //reset needs to added after to avaid X assertion

	RTLOp *finishCond2 = NULL;
	if (totalTime == 1) {
		// only one valid bit
		finishCond2 = rtl->addOp(RTLOp::Not)->setOperands(validBits.at(0));
	} else {
		// check prior two valid bits
		finishCond2 = rtl->addOp(RTLOp::And)->setOperands(
				rtl->addOp(RTLOp::Not)->setOperands(
						validBits.at(totalTime - 2)),
				validBits.at(totalTime - 1));
	}

	RTLOp *finishCond = rtl->addOp(RTLOp::And)->setOperands(waitrequest,
			rtl->addOp(RTLOp::And)->setOperands(epilogue, finishCond2));

	RTLSignal *finish = rtl->addWire(label + "_pipeline_finish");
	finish->connect(finishCond);

	epilogue->addCondition(finishCond, ZERO);
	started->addCondition(finishCond, ZERO);

	State *pipelineWaitState = getFirstState(BB);
	assert(pipelineWaitState->isWaitingForPipeline());
	pipelineWaitState->setTransitionSignal(
			rtl->find(label + "_pipeline_finish"));

	// connect the phi_temp register for cross-iteration dependencies
	for (BasicBlock::iterator I = BB->begin(), ie = BB->end(); I != ie; ++I) {
		if ((Instruction*) I == inductionVar)
			continue;
		if (PHINode *phi = dyn_cast<PHINode>(I)) {

			// we need to connect the phi to the incoming value
			RTLSignal *phi_reg = rtl->addReg(verilogName(phi) + "_reg",
					RTLWidth(phi->getType()));
			RTLSignal *phi_wire = rtl->find(verilogName(phi));

			Instruction *IV = dyn_cast<Instruction>(
					phi->getIncomingValueForBlock(BB));
			assert(IV);
			int incomingTime = getMetadataInt(IV, "legup.pipeline.avail_time");

			RTLSignal *ii_state = rtl->find(label + "_ii_state");

			// connect the phi_temp register to the incoming value as soon
			// as it is available
			RTLOp *cond = rtl->addOp(RTLOp::And)->setOperands(waitrequest,
					rtl->addOp(RTLOp::And)->setOperands(
							rtl->addOp(RTLOp::EQ)->setOperands(ii_state,
									new RTLConst(utostr(incomingTime % II),
											ii_state->getWidth())),
							rtl->find(
									label + "_valid_bit_"
											+ utostr(incomingTime))));
			this->time = incomingTime;
			phi_wire->addCondition(cond, getOp(pipelineWaitState, IV), phi);
			phi_reg->addCondition(cond, phi_wire, phi);

		}
	}
}

// every variable which gets used in another stage must be flopped
// this function populates pipelineSignalAvailableTable
void GenerateRTL::findAllPipelineStageRegisters(BasicBlock *BB) {

	const Instruction *inductionVar = getInductionVar(BB);
	TerminatorInst *TI = BB->getTerminator();
	int totalTime = getMetadataInt(TI, "legup.totalTime");
	int II = getMetadataInt(TI, "legup.II");
	std::string label = getPipelineLabel(BB);

	RTLSignal *waitrequest = rtl->addOp(RTLOp::EQ)->setOperands(
			getWaitRequest(BB->getParent()), ZERO);

	// every variable which gets used in another stage must be flopped
	for (BasicBlock::iterator I = BB->begin(), ie = BB->end(); I != ie; ++I) {
		if ((Instruction*) I == inductionVar)
			continue;

		int startTime = getMetadataInt(I, "legup.pipeline.start_time");
		int timeAvail = getMetadataInt(I, "legup.pipeline.avail_time");
		int expectedAvailTime = startTime
				+ Scheduler::getNumInstructionCycles(I);

		assert(timeAvail < totalTime);

		int maxTimeUse = -1;
		int minTimeUse = 1e6;
		for (Value::user_iterator ui = I->user_begin(), ue = I->user_end();
				ui != ue; ++ui) {
			Instruction *I2 = dyn_cast<Instruction>(*ui);
			if (!I2)
				continue;
			if (I2->getParent() != BB)
				continue;

			int time2 = getMetadataInt(I2, "legup.pipeline.start_time");
			if (isa<PHINode>(I2)) {
				// the current instruction gets used by a phi node
				time2 = timeAvail;
			}
			maxTimeUse = max(maxTimeUse, time2);
			minTimeUse = min(minTimeUse, time2);

		}

		// never used in the pipelined basic block
		if (maxTimeUse == -1)
			continue;
		assert(minTimeUse != 1e6);

		initializePipelineSignal(I, totalTime);

		// this saves a bunch of registers by only using registers on the
		// pipeline stage boundaries. Instead of using a register for every
		// single time step
		bool saveRegisters = LEGUP_CONFIG->getParameterInt("PIPELINE_SAVE_REG");

		if (timeAvail != expectedAvailTime) {
			// this is caused when we have an operation, say an 'add' that
			// is normally chained in this scheduler. But since IMS doesn't
			// support chaining, the IMS schedules the add into the next
			// cycle. We need to build up the register from the add wire
			// to the add pipeline stage registers
			assert(timeAvail == expectedAvailTime + 1);
			timeAvail = expectedAvailTime;
		}
		int iiAvail = timeAvail % II;

		if (saveRegisters) {
			setPipelineSignal(I, timeAvail, rtl->find(verilogName(I)));

			std::set<int> stageSeen;

			for (int i = timeAvail + 1; i <= maxTimeUse; i++) {
				int stage = i / II;
				if (stageSeen.find(stage) == stageSeen.end()) {
					// create a new pipeline stage register
					stageSeen.insert(stage);
					setPipelineSignal(I, i,
							rtl->addReg(
									verilogName(I) + "_reg_stage"
											+ utostr(stage),
									RTLWidth(I->getType())));

					RTLSignal *ii_state = rtl->find(label + "_ii_state");

					int iiCond = II - 1;
					if (i == timeAvail + 1) {
						// the first stage register, 1 cycle after available
						// time might be in the middle of a stage
						iiCond = iiAvail;
					}

					RTLOp *cond = rtl->addOp(RTLOp::And)->setOperands(
							waitrequest,
							rtl->addOp(RTLOp::And)->setOperands(
									rtl->addOp(RTLOp::EQ)->setOperands(ii_state,
											new RTLConst(utostr(iiCond),
													ii_state->getWidth())),
									rtl->find(
											label + "_valid_bit_"
													+ utostr(i - 1))));

					getPipelineSignal(I, i)->addCondition(cond,
							getPipelineSignal(I, i - 1));
				} else {
					// still in the same stage
					setPipelineSignal(I, i, getPipelineSignal(I, i - 1));
				}
			}
		} else {
			setPipelineSignal(I, timeAvail, rtl->find(verilogName(I)));
			// build a shift register to hold the previous values
			for (int i = timeAvail + 1; i <= maxTimeUse; i++) {
				RTLSignal *reg_time = rtl->addReg(
						verilogName(I) + "_reg_time" + utostr(i),
						RTLWidth(I->getType()));
				RTLSignal *prev = getPipelineSignal(I, i - 1);
				if (i == timeAvail + 1) {
					// need to add a condition on the first one...
                    RTLSignal *reg_time_wire = rtl->addWire(
                        verilogName(I) + "_reg_time_wire" + utostr(i),
                        RTLWidth(I->getType()));
                    reg_time_wire->setDefaultDriver(ZERO);
                    RTLOp *pipelineCond = getPipelineStateCondition(
                        reg_time_wire, I, OUTPUT_READY);
                    reg_time_wire->addCondition(pipelineCond, prev, I);
                    reg_time->connect(reg_time_wire);
                } else {
                    reg_time->connect(prev);
				}
				setPipelineSignal(I, i, reg_time);
			}
		}

		// special case phi nodes
		if (PHINode *phi = dyn_cast<PHINode>(I)) {

			Instruction *IV = dyn_cast<Instruction>(
					phi->getIncomingValueForBlock(BB));
			assert(IV);
			int incomingTime = getMetadataInt(IV, "legup.pipeline.avail_time");

			/*
			 errs() << "pipelineSignalAvailableTable for: " << *phi << "\n";
			 errs() << "timeAvail: " << timeAvail << "\n";
			 errs() << "maxTimeUse: " << maxTimeUse << "\n";
			 errs() << "minTimeUse: " << minTimeUse << "\n";
			 errs() << "incomingTime: " << incomingTime << "\n";
			 errs() << "II: " << II << "\n";
			 */

			// consider the case of a schedule of a phi node:
			// II = 3
			// t = 0   1   2 | 3   4   5 | 6   7   8 | 9   10   11 |
			//                                 X           X
			// where | = pipeline stage register
			// The phi node isn't updated with an incoming value from the loop
			// basic block (BB) until t=7, ii=1 (incomingTime = 7)
			// Lets assume now an instruction uses the phi as an operand at the
			// time given below:
			// first iteration:
			// t = 0: impossible, the phi operand wouldn't work in second
			//        iteration (phi would stay the same)
			// t = 1: impossible
			// t = 2: impossible
			// second iteration:
			// t = 3: impossible
			// t = 4: possible - *only* if you use the wire attached to the phi
			//        in this case, you'll get first get the default phi value
			//        (from outside loop) in this iteration (2nd). And get the
			//        updated value from the phi node in the 3rd iteration.
			//        **** this is time: incomingTime - II
			// t = 5: possible - must use phi register
			// third iteration:
			// t = 6: possible - must use phi register
			// t = 7: possible - must use phi register
			// t = 8: possible - but, now must use the phi value stored in the
			//        pipeline stage register 2 (i / II = 8 / 3 = 2)
			assert(minTimeUse >= (incomingTime - II));
			assert(timeAvail >= (incomingTime - II));

			RTLSignal *phi_wire = rtl->find(verilogName(phi));
			RTLSignal *phi_reg = rtl->find(verilogName(phi) + "_reg");

			for (int i = timeAvail; i <= maxTimeUse; i++) {
				RTLSignal *avail = phi_reg;
				if (i == incomingTime - II) {
					avail = phi_wire;
				} else if (i > incomingTime) {
					stage = i / II;
					avail = rtl->find(
							verilogName(I) + "_reg_stage" + utostr(stage));
				}

				setPipelineSignal(phi, i, avail);
				//errs() << "\t" << i << ": " <<
				//    getPipelineSignal(phi, i)->getName() << "\n";
			}
		}
	}

}

// this function deletes all the existing states of BB
// except the very first state. This state is renamed
// to LEGUP_loop_pipeline_wait.
// All instructions are deleted from this state - so it is empty
// This state has two transitions:
//     pipeline_finish is false: loop back to itself
//     pipeline_finish is true: transition to the next basic block
//                              outside the loop
// this state also has a special flag: isWaitingForPipeline(), for
// generateDatapath() to create the pipeline
//
void GenerateRTL::modifyFSMForLoopPipeline(BasicBlock *BB) {
	State *pipelineWaitState = getFirstState(BB);

	//const Instruction *inductionVar = getInductionVar(BB);
	//int II = getPipelineII(BB);

	// delete everything up until the terminating state of the basic block
	if (!pipelineWaitState->isTerminating()) {
		assert(pipelineWaitState->getNumTransitions() == 1);

		// find first state
		FiniteStateMachine::iterator i = fsm->begin();
		while ((State*) i != pipelineWaitState) {
			++i;
		}
		// don't delete first state
		++i;

		// delete all states after first state
		while (i != fsm->end()) {
			if (i->isTerminating()) {
				// preserve FSM transition information in first state
				State *terminatingState = i;
				State::Transition origTransition =
						terminatingState->getTransition();
				pipelineWaitState->setTransition(origTransition);
				pipelineWaitState->setTerminating(true);
				i = fsm->erase(i);
				break;
			} else {
				i = fsm->erase(i);
			}
		}
	}

	// what's the next state after this basic block?
	// one of the transitions should be back to this basic block (a loop)
	// the other transition is what we want to know (nextStateAfterBB)
	assert(pipelineWaitState->isTerminating());
	assert(pipelineWaitState->getNumTransitions() == 2);
	State *nextStateAfterBB = getStateAfterLoop(pipelineWaitState);

	// delete all instructions from pipelineWaitState (except phi nodes)
	// this is so they don't get iterated over in generateDatapath()
	// don't delete phi nodes so generatePHICopiesForSuccessor() works for
	// the predecessor basic block of the pipelined loop
	State::iterator j = pipelineWaitState->begin();
	unsigned size = pipelineWaitState->size();
	for (unsigned i = 0; i < size; i++) {
		if (isa<PHINode>(*j)) {
			j++;
		} else {
			j = pipelineWaitState->erase(j);
		}
	}

	std::string label = getPipelineLabel(BB);
	FiniteStateMachine* fsm = sched->getFSM(Fp);
	pipeRTLFile() << "Changing state name of '" << pipelineWaitState->getName()
			<< "' to '";
	pipelineWaitState->setName("LEGUP_loop_pipeline_wait_" + label);
	pipeRTLFile() << pipelineWaitState->getName() << "'\n";

	pipelineWaitState->setWaitingForPipeline(true);

	// need to clear all original transitions.
	// where must wait for the pipeline to complete.
	assert(pipelineWaitState->getBasicBlock() == BB);
	State::Transition blank;
	pipelineWaitState->setTransition(blank);
	pipelineWaitState->setDefaultTransition(pipelineWaitState);
	pipelineWaitState->addTransition(nextStateAfterBB);

	// all instructions should be executed in pipelineWaitState - while we wait for the
	// pipeline to finish
	for (BasicBlock::iterator I = BB->begin(), ie = BB->end(); I != ie; ++I) {
		fsm->setStartState(I, pipelineWaitState);
		fsm->setEndState(I, pipelineWaitState);
	}

}

raw_fd_ostream &GenerateRTL::pipeRTLFile() {
	return alloc->getPipeliningRTLFile();
}

raw_fd_ostream &GenerateRTL::File() {
	return alloc->getGenerateRTLFile();
}

// Adjust Finite State Machine for function calls
void GenerateRTL::generateAllCallInsts() {

    std::set<CallInst *> visited;
    FiniteStateMachine *fsm = sched->getFSM(Fp);

    for (FiniteStateMachine::iterator state = ++fsm->begin(), se = fsm->end();
         state != se; ++state) {

        State::iterator instr = state->begin();

        while (instr != state->end()) {
            CallInst *CI = dyn_cast<CallInst>(*instr);
            if (CI && !isaDummyCall(CI) & !visited.count(CI)) {
                this->state = state;

                // create states and signals for this function
                createFunction(*CI);

                // create and connect threadID, functionID,
                // finish and return_val signals for pthread functions
                createPthreadSignals(CI);

                instr = state->remove(CI);
                visited.insert(CI);
            } else {
                ++instr;
            }
        }
    }
}

// print out the finite state machine
void GenerateRTL::printFSMDot() {
	std::string fileName = "fsm." + rtl->getName() + ".dot";
	printFSMDotFile(sched->getFSM(Fp), fileName);
}

// Update state width to account for called functions
void GenerateRTL::updateStatesAfterCallInsts() {
	unsigned stateNum = fsm->getNumStates();
	assert(stateNum > 0);
	// remember that states are from 0 to stateNum-1
	unsigned statewidth = requiredBits(stateNum - 1);

	if (!LEGUP_CONFIG->getParameterInt("CASEX"))
		statewidth = requiredBits(stateNum - 1);
	else
		// If we are using CASEX then we set the state codes in a "one hot" style instead of binary encoding
		statewidth = stateNum;

	rtl->find("cur_state")->setWidth(RTLWidth(statewidth));

	// this code uses Verilog "parameter" statements
	// to give a numerical value to each state name
	// the state names are, in essence, an enumerated type
	unsigned stateCount = 0;
	FiniteStateMachine::iterator stateIter = fsm->begin();
	for (; stateIter != fsm->end(); stateIter++) {
		State* s = stateIter;

		// append the state number to the end of the state name parameter
		std::string pName = s->getName() + "_" + utostr(stateCount);
		s->setName(pName);

		RTLSignal *stateParam = getStateSignal(s);
		stateParam->setName(pName);
		stateParam->setWidth(RTLWidth(statewidth));
		if (!LEGUP_CONFIG->getParameterInt("CASEX"))
			stateParam->setValue(utostr(stateCount));
		else {
			// So, when we are using CASEX for the state machine, we need two sets of parameters
			// the first looks like this:
			// LEGUP_STATE2 10'b0000100000
			// and the second looks like this:
			// LEGUP_STATE2_X 10'bxxxx1xxxxx
			// The first set is used in state assignements.
			// The second set is used in the casex(...) conditions.

#if 0 // janders: old way of doing the param name generation -- see new way below
			std::string stateParamName = utostr(stateNum);
			std::string stateParamNameX = utostr(stateNum);
			stateParamName = stateParamName + "'b";
			stateParamNameX = stateParamNameX + "'b";
			for (int i = statewidth-1; i >= 0; i--)
			if (i == stateCount) {
				stateParamName = stateParamName + "1";
				stateParamNameX = stateParamNameX + "1";
			}
			else {
				stateParamName = stateParamName + "0";
				stateParamNameX = stateParamNameX + "x";
			}
#endif

			// incorporate Lanny's suggestion to avoid long strings of 0's and x's in the params
			// but using the concatenation construct in Verilog

			std::string stateParamName = "{";
			std::string stateParamNameX = "{";

			// leading 0's and x's on the param
			if (stateNum - stateCount - 1 > 0) {
				stateParamName = stateParamName
						+ utostr(stateNum - stateCount - 1) + "'b0, ";
				stateParamNameX = stateParamNameX
						+ utostr(stateNum - stateCount - 1) + "'bx, ";
			}

			// the one-hot bit
			stateParamName = stateParamName + "1'b1";
			stateParamNameX = stateParamNameX + "1'b1";

			// trailing 0's and x's on the param
			if (stateCount) {
				stateParamName = stateParamName + ", " + utostr(stateCount)
						+ "'b0";
				stateParamNameX = stateParamNameX + ", " + utostr(stateCount)
						+ "'bx";
			}

			stateParamName = stateParamName + "}";
			stateParamNameX = stateParamNameX + "}";

			stateParam->setValue(stateParamName);
			RTLSignal *casexParam = rtl->addParam(pName + "_X",
					stateParamNameX);
			casexParam->setWidth(RTLWidth(statewidth));
		}



		stateCount++;
	}
	// some states might have been removed, delete the parameter placeholders
	rtl->remove("state_placeholder");
}

RTLSignal *GenerateRTL::getLeftHandSide(Instruction *instr) {

	RTLWidth w(instr, MBW);
	RTLSignal *instSig = rtl->addWire(verilogName(instr), w);

    if (!rtl->exists(verilogName(instr) + "_reg") &&
        usedAcrossStates(instr, this->state)) {
        // need a wire for chaining
        RTLSignal *instReg = rtl->addReg(verilogName(instr) + "_reg", w);
        connectSignalToDriverInState(instReg, instSig, this->state, instr,
                                     OUTPUT_READY);
    }

    return instSig;
}

void GenerateRTL::visitSelectInst(SelectInst &I) {

	RTLSignal *instSig = getLeftHandSide(&I);

	RTLOp *FU = rtl->addOp(RTLOp::Sel);
    FU->setOperand(0, getOp(this->state, I.getOperand(0)));
    FU->setOperand(1, getOp(this->state, I.getOperand(1)));
    FU->setOperand(2, getOp(this->state, I.getOperand(2)));
    connectSignalToDriverInState(instSig, FU, this->state, &I);
}

bool GenerateRTL::isMultipumped(Instruction *I) {
    return (isMul(I) && MULTIPUMPING
			&& multipumpOperations.find(I) != multipumpOperations.end());
}

RTLSignal *GenerateRTL::createBindingFU(Instruction *instr, RTLSignal *op0,
		RTLSignal *op1) {
	RTLSignal *FU;
	std::string fuId = this->binding->getBindingInstrFU(instr);

	bool binOp = instr->isBinaryOp();

	//*** Don't know about change to Multipump... Joy
	//*** Check for binary operation
	if (isMultipumped(instr)) {

		//errs() << "I: " << *instr << "\n";
		// use multipump multiplier
		MultipumpOperation &multipump = multipumpOperations[instr];
		std::string fuOutput = multipump.out;
		//errs() << fuOutput << "\n";

		unsigned size = MBW->getMinBitwidth(instr->getOperand(0));
		if (binOp) {
			size = max(MBW->getMinBitwidth(instr->getOperand(0)),
					MBW->getMinBitwidth(instr->getOperand(1)));
		}

		RTLOp *trunc_op0 = rtl->addOp(RTLOp::Trunc);
		trunc_op0->setCastWidth(size);
		trunc_op0->setOperand(0, op0);

		RTLOp *trunc_op1;
		if (binOp) {
			trunc_op1 = rtl->addOp(RTLOp::Trunc);
			trunc_op1->setCastWidth(size);
            trunc_op1->setOperand(0, op1);
        }

        connectSignalToDriverInState(rtl->find(multipump.op0), trunc_op0,
                                     this->state, instr);
        if (binOp) {
            connectSignalToDriverInState(rtl->find(multipump.op1), trunc_op1,
                                         this->state, instr);
        }

        FU = rtl->find(fuOutput);

    } else {

        connectSignalToDriverInState(rtl->find(fuId + "_op0"), op0, this->state,
                                     instr);
        if (binOp) {
            connectSignalToDriverInState(rtl->find(fuId + "_op1"), op1,
                                         this->state, instr);
        }
        FU = rtl->find(fuId);

        // Also, if this is a divider or remainder, and dividers are
		// multi-cycled, remember that we also need to multi-cycle
		// this instruction
		if (isDiv(instr) || isRem(instr)) {
			if (LEGUP_CONFIG->getParameterInt(
					"MULTI_CYCLE_REMOVE_REG_DIVIDERS")) {
				// Insert multi-cycle constraints for this divider after binding
				alloc->add_multicycled_divider(instr);
			}
		}
	}

	return FU;
}

std::string GenerateRTL::getEnableName(Instruction *instr) {
	std::string en_name;
	if (isDiv(instr) || isRem(instr)) {
		en_name = "lpm_divide_";
	} else if (isFPArith(instr) || isFPCmp(instr) || isFPCast(instr)) {
		en_name = "altfp_";
	} else {
		en_name = "lpm_mult_";
	}
	en_name += verilogName(instr) + "_en";

	return en_name;
}

// we must take into account the waitrequest signal: it could take 100
// cycles just to get to the next state.
// also need to disable the divider while making function calls
// TODO: should only be enabled when being used to save power
void GenerateRTL::create_fu_enable_signals(Instruction *instr) {
	RTLSignal *en = rtl->addWire(getEnableName(instr));

	PropagatingSignals *ps = alloc->getPropagatingSignals();
	bool functionUsesMemory = ps->functionUsesMemory(Fp->getName())
			|| usesPthreads;

	// wait_done = 1 when waitrequest == 0
	RTLOp *wait_done;
	if (functionUsesMemory) {
		wait_done = rtl->addOp(RTLOp::EQ);
		wait_done->setOperand(0, rtl->find("memory_controller_waitrequest"));
		wait_done->setOperand(1, ZERO);
	} else {
		wait_done = rtl->addOp(RTLOp::EQ);
		wait_done->setOperand(0, ZERO);
		wait_done->setOperand(1, ZERO);
	}

	if (rtl->exists("legup_function_call")) {
		RTLOp *fct_done = rtl->addOp(RTLOp::EQ);
		fct_done->setOperand(0, rtl->find("legup_function_call"));
		fct_done->setOperand(1, ZERO);

		RTLOp *div_en = rtl->addOp(RTLOp::And);
		div_en->setOperand(0, wait_done);
		div_en->setOperand(1, fct_done);
		en->connect(div_en);
	} else {
		en->connect(wait_done);
	}
}

// visitBinaryOperator is called on every LLVM binary operation (add, sub, etc)
// in the program. This function creates the necessary functional units for the
// operation and connects the operation's wire and register to the output of
// the function unit during the correct state of the FSM
void GenerateRTL::visitBinaryOperator(Instruction &I) {
	Instruction *instr = &I;

	// Unfortunately, visitBinaryOperator is called for every instruction
	// This includes those already bound in createBindingSignals, so we need
	// to check if this instruction is in a graph and skip it (log lookup
	// time, but needs to be done for every binary operation...)
	if (this->InstructionsInGraphs.find(instr)
			!= this->InstructionsInGraphs.end()) {
		return;
	}

	// instWire is the wire associated with this operation. For instance the
	// LLVM instruction:
	//      %13 = add i32 %6, %4
	// Might have a wire named:
	//      main_1_13
	// Function: main, Basic Block: %1, Instruction: %13
	RTLSignal *instWire = getLeftHandSide(instr);
	RTLSignal *op0 = getOp(this->state, instr->getOperand(0));
	RTLSignal *op1 = getOp(this->state, instr->getOperand(1));

	// FU holds the output of the functional unit associated with this operation
	RTLSignal *FU;
	if (this->binding->existsBindingInstrFU(instr)) {
		FU = createBindingFU(instr, op0, op1);
	} else {
		FU = createFU(instr, op0, op1);
	}

	unsigned pipelineStages = Scheduler::getNumInstructionCycles(instr);
	if (pipelineStages > 0) {

		create_fu_enable_signals(instr);

		// drive the instruction wire signal with the output of the functional
		// unit making sure the bitwidth is correct
		instWire->connect(FU);
		instWire->setWidth(FU->getWidth());

		// store the instruction's value in a register during the ending state
		// of the instruction (when the functional unit output is available).
        // Now we can access the instruction's value in another cycle by
        // reading from this register
        RTLSignal *instReg = rtl->find(verilogName(instr) + "_reg");
        connectSignalToDriverInState(instReg, instWire, fsm->getEndState(instr),
                                     instr, OUTPUT_READY);

    } else {
        assert(pipelineStages == 0);
        // connect the instruction wire to the functional unit output
        // during the active state of this operation
        connectSignalToDriverInState(instWire, FU, this->state, instr);
    }
}

// Similar to visitBinaryOperator for handling unary operators
// Assumes FP unary operators
void GenerateRTL::visitUnaryOperator(CastInst &I) {
	Instruction *instr = &I;

	// Unfortunately, visitUnaryOperator is called for every instruction
	// This includes those already bound in createBindingSignals, so we need
	// to check if this instruction is in a graph and skip it (log lookup
	// time, but needs to be done for every binary operation...)
	if (this->InstructionsInGraphs.find(instr)
			!= this->InstructionsInGraphs.end()) {
		return;
	}

	// instWire is the wire associated with this operation. For instance the
	// LLVM instruction:
	//      %13 = add i32 %6, %4
	// Might have a wire named:
	//      main_1_13
	// Function: main, Basic Block: %1, Instruction: %13
	RTLSignal *instWire = getLeftHandSide(instr);
	RTLSignal *op0 = getOp(this->state, instr->getOperand(0));

	// Sanity checks for FPToSI/SIToFP
	if (isa<SIToFPInst>(instr) || isa<FPToSIInst>(instr)) {
		int int_width = 0;
		int FP_width = 0;

		if (isa<SIToFPInst>(instr)) {
			int_width =
					instr->getOperand(0)->getType()->getPrimitiveSizeInBits();
			FP_width = I.getDestTy()->getPrimitiveSizeInBits();
		} else if (isa<FPToSIInst>(instr)) {
			int_width = I.getDestTy()->getPrimitiveSizeInBits();
			FP_width =
					instr->getOperand(0)->getType()->getPrimitiveSizeInBits();
		}

		if (FP_width != 32 && FP_width != 64) {
			errs() << "Invalid Float type for: " << *instr << "\n";
			llvm_unreachable(0);
		}

		if (int_width != 32) {
			errs() << "Invalid Integer type for: " << *instr << "\n";
			llvm_unreachable(0);
		}

		assert(FP_width == 32 || FP_width == 64);
	}

	// FU holds the output of the functional unit associated with this operation
	RTLSignal *FU;
	if (this->binding->existsBindingInstrFU(instr)) {
		FU = createBindingFU(instr, op0, /*op1*/NULL);
	} else {
		FU = createFU(instr, op0, /*op1*/NULL);
	}
	unsigned pipelineStages = Scheduler::getNumInstructionCycles(instr);
	assert(pipelineStages > 0);

	create_fu_enable_signals(instr);

	// drive the instruction wire signal with the output of the functional
	// unit making sure the bitwidth is correct
	instWire->connect(FU);
	instWire->setWidth(FU->getWidth());

	// store the instruction's value in a register during the ending state
	// of the instruction (when the functional unit output is available).
    // Now we can access the instruction's value in another cycle by
    // reading from this register
    RTLSignal *instReg = rtl->find(verilogName(instr) + "_reg");
    connectSignalToDriverInState(instReg, instWire, fsm->getEndState(instr),
                                 instr, OUTPUT_READY);
}

void GenerateRTL::visitFCastInst(CastInst &I) {
    Instruction *instr = &I;

	// Unfortunately, visitFCastInst is called for every instruction
	// This includes those already bound in createBindingSignals, so we need
	// to check if this instruction is in a graph and skip it (log lookup
	// time, but needs to be done for every binary operation...)
	if (this->InstructionsInGraphs.find(instr)
			!= this->InstructionsInGraphs.end()) {
		return;
	}

	RTLSignal *instWire = getLeftHandSide(&I);
	RTLSignal *op0 = getOp(this->state, instr->getOperand(0));

	std::string name;
	if (dyn_cast<FPTruncInst>(instr)) {
		name = "altfp_truncate";
	} else {
		name = "altfp_extend";
	}

	RTLSignal *FU = createFP_FU_Helper(name, instr, op0, /*op1=*/NULL,
	/*fu_module=*/NULL);

	instWire->connect(FU);
    instWire->setWidth(FU->getWidth());

    RTLSignal *instReg = rtl->find(verilogName(instr) + "_reg");
    connectSignalToDriverInState(instReg, instWire, fsm->getEndState(instr),
                                 instr, OUTPUT_READY);
}

void GenerateRTL::visitFPCastInst(CastInst &I) {
    RTLSignal *instWire = getLeftHandSide(&I);
	Instruction *instr = &I;

	// Unfortunately, visitFPCastInst is called for every instruction
	// This includes those already bound in createBindingSignals, so we need
	// to check if this instruction is in a graph and skip it (log lookup
	// time, but needs to be done for every binary operation...)
	if (this->InstructionsInGraphs.find(instr)
			!= this->InstructionsInGraphs.end()) {
		return;
	}

	int int_width = 0;
	int FP_width = 0;
	RTLSignal *op0 = getOp(this->state, instr->getOperand(0));
	if (isa<SIToFPInst>(instr)) {
		int_width = instr->getOperand(0)->getType()->getPrimitiveSizeInBits();
		FP_width = I.getDestTy()->getPrimitiveSizeInBits();
	} else if (isa<FPToSIInst>(instr)) {
		int_width = I.getDestTy()->getPrimitiveSizeInBits();
		FP_width = instr->getOperand(0)->getType()->getPrimitiveSizeInBits();
	}

	if (FP_width != 32 && FP_width != 64) {
		errs() << "Invalid Float type for: " << *instr << "\n";
		llvm_unreachable(0);
	}

	if (int_width != 32) {
		errs() << "Invalid Integer type for: " << *instr << "\n";
		llvm_unreachable(0);
	}

	assert(FP_width == 32 || FP_width == 64);
	std::string name;
	if (isa<SIToFPInst>(instr)) {
		name = "altfp_sitofp";
	} else if (isa<FPToSIInst>(instr)) {
		name = "altfp_fptosi";
	} else {
		assert(0);
	}
	name = name + utostr(FP_width);
	RTLSignal *FU = createFP_FU_Helper(name, instr, op0, /*op1=*/NULL,
	/*fu_module=*/NULL);

	instWire->connect(FU);
    instWire->setWidth(FU->getWidth());

    RTLSignal *instReg = rtl->find(verilogName(instr) + "_reg");
    connectSignalToDriverInState(instReg, instWire, fsm->getEndState(instr),
                                 instr, OUTPUT_READY);
}

void GenerateRTL::visitCastInst(CastInst &I) {
    RTLSignal *instSig = getLeftHandSide(&I);
	Instruction *instr = &I;
	RTLSignal *op0 = getOp(this->state, instr->getOperand(0));

	if (isa<SExtInst>(instr) || isa<ZExtInst>(instr)) {
		RTLOp *ext = NULL;
		if (isa<SExtInst>(instr)) {
			ext = rtl->addOp(RTLOp::SExt);
		} else {
			ext = rtl->addOp(RTLOp::ZExt);
        }
        ext->setCastWidth(instSig->getWidth());
        ext->setOperand(0, op0);
        connectSignalToDriverInState(instSig, ext, this->state, instr);
    } else if (isa<TruncInst>(instr)) {
        RTLOp *trunc = rtl->addOp(RTLOp::Trunc);
        trunc->setCastWidth(instSig->getWidth());
        trunc->setOperand(0, op0);
        connectSignalToDriverInState(instSig, trunc, this->state, instr);
    } else if (isa<BitCastInst>(instr) || isa<PtrToIntInst>(instr) ||
               isa<IntToPtrInst>(instr)) {
        connectSignalToDriverInState(instSig, op0, this->state, instr);
    } else if (isa<FPToSIInst>(instr) || isa<SIToFPInst>(instr)) {
        visitFPCastInst(I);
    } else {
        errs() << "Unrecognized Instruction: " << *instr << "\n";
		llvm_unreachable(0);
	}
}

// pairFUsForMultipumpFU() assigns two multiplier FUs from traditional binding
// and assigns one to each 'port' of the multipump unit (AxB and CxD)
// Also, since multiple instructions can be assigned to a FUs, this function
// updates the multipumpOperations map for each instruction assigned to this
// multipump unit. Finally the RTL is generated for the multipump unit by
// calling createMultiPumpMultiplierFU()
// If this is the first multipump unit, the multipump_fu_name would be:
//      multipump_0
// We also create the signals:
//      multipump_0_inA
//      multipump_0_inB
//      multipump_0_outAxB_actual
//      multipump_0_outCxD_actual
//      multipump_0_inC
//      multipump_0_inD
int GenerateRTL::pairFUsForMultipumpFU(std::string FuName1, std::string FuName2,
		int multipump_fu_num, raw_ostream &out) {

	int num_multipump_ops = 0;

	std::string multipump_fu_name = "multipump";

	// multipump fu name. For instance "multipump_0"
	std::string fu = multipump_fu_name + "_" + utostr(multipump_fu_num);

	MultipumpOperation multipump;
	multipump.name = fu;
	multipump.out = fu + "_AxB";
	multipump.op0 = fu + "_inA";
	multipump.op1 = fu + "_inB";

	MultipumpOperation multipump2;
	multipump2.name = fu;
	multipump2.out = fu + "_CxD";
	multipump2.op0 = fu + "_inC";
	multipump2.op1 = fu + "_inD";

	out << "Multipump FU: " << fu << ", pairing: " << FuName1 << " and "
			<< FuName2 << "\n";

	out << "\tFU1: " << FuName1 << "\n";

	std::vector<Instruction*> &FUInsts1 =
			this->binding->getInstructionsAssignedToFU(FuName1);
	for (unsigned n = 0; n < FUInsts1.size(); n++) {
		Instruction *I1 = FUInsts1.at(n);
		out << "\t\tI: " << *I1 << "\n";
		multipumpOperations[I1] = multipump;
		num_multipump_ops++;
	}

	out << "\tFU2: " << FuName2 << "\n";

	std::vector<Instruction*> &FUInsts2 =
			this->binding->getInstructionsAssignedToFU(FuName2);
	for (unsigned n = 0; n < FUInsts2.size(); n++) {
		Instruction *I2 = FUInsts2.at(n);
		out << "\t\tI: " << *I2 << "\n";
		multipumpOperations[I2] = multipump2;
		num_multipump_ops++;
	}

	createMultiPumpMultiplierFU(FUInsts1.at(0), FUInsts2.at(0));

	return num_multipump_ops;
}

// createMultipumpSignals() is similar to createBindingSignals but for
// multi-pump functional units.
// Recall, a multipump multiply unit can perform two multiply operations
// per cycle: AxB and CxD (input ports: A, B, C, D)
// However, binding has no knowledge of multipumping, so each multiplier FU is
// assumed to only perform one multiply operation per cycle.
// Hence, the multipump unit is equivalent to *two* normal multiply
// functional units from traditional multiplier binding.
// This function groups pairs of compatible multiply FUs and assigning
// them to the same multi-pump unit.
// So there are three levels of datastructures:
//      1) Individual multiplier operations -- these correspond to LLVM mul
//         instructions
//      2) Multiplier functional units (FUs) that execute one or more multiplier
//         operations. Binding determines which multipliers are assigned to a FU.
//         To get the multiplier FU name for an operation use:
//              getBindingInstrFU(I)
//         For instance, if the following two multipliers are paired by binding:
//              %37 = mul nsw i32 %36, %35
//              %28 = mul nsw i32 %27, %26
//         getBindingInstrFU(I) might return the FU name:
//              multipump_main_22_37
//      3) Multi-pump functional units -- to get the signaling information for
//         a multiply operation use the map:
//              multipumpOperations[I2]
//         The multipumpOperations map is updated in pairFUsForMultipumpFU()
void GenerateRTL::createMultipumpSignals() {
	formatted_raw_ostream out(alloc->getMultipumpingFile());

	unsigned multipump_fu_num = 0;
	map<bool, map<unsigned, unsigned> > pairCount;
	map<bool, map<unsigned, std::string> > prevFU;
	std::set<std::string> unPairedFUs;

	// multiplierFUs contains the binding FU name for each multiplier FU
	// there may be many multipliers assigned to the same multiplier FU
	std::set<std::string> multiplierFUs;
	int num_multiply_ops = 0;
	for (Binding::iterator i = this->binding->begin(), ie =
			this->binding->end(); i != ie; ++i) {
		Instruction *I = i->first;
		if (!isMul(I))
			continue;
		num_multiply_ops++;
		std::string bindingFU = this->binding->getBindingInstrFU(I);
		multiplierFUs.insert(bindingFU);
	}
	unPairedFUs = multiplierFUs;

	int num_multipump_ops = 0;

	// Iterate over all multiply FUs and greedily finds pairs
	// of compatible FUs to assign to one multipump functional unit.
	// Compatible multiply operations have the same:
	//      1. bitwidth (size)
	//      2. sign (isSigned)
	// We keep track of the number of multiply operations using the map:
	//      pairCount[isSigned][size]
	// Once we find two multiply FU to pair then we call pairFUsForMultipumpFU()

	for (std::set<std::string>::iterator i = multiplierFUs.begin();
			i != multiplierFUs.end(); ++i) {
		std::string fuId = *i;

		std::vector<Instruction*> &FUInsts =
				this->binding->getInstructionsAssignedToFU(fuId);
		Instruction *I = FUInsts.at(0);
		assert(I);

		Value *vop0 = I->getOperand(0);
		Value *vop1 = I->getOperand(1);
		bool isSigned = false;

		unsigned size = max(MBW->getMinBitwidth(vop0),
				MBW->getMinBitwidth(vop1));

		unsigned origSize = I->getType()->getPrimitiveSizeInBits();

		if (size < origSize) {
			if (isa<SExtInst>(vop0) && isa<SExtInst>(vop1)) {
				isSigned = true;
			}
		}

		out << "FU: " << fuId << "\n";
        out << "\tFirst inst assigned to FU: " << *I << "\n";
        out << "\tisSigned: " << isSigned << "\n";
        out << "\tsize: " << size << "\n";
        if (LEGUP_CONFIG->getParameterInt("MB_MINIMIZE_HW")) {
            out << "\tminBW: " << MBW->getMinBitwidth(I) << " - " << *I << "\n";
            out << "\tminBW op0: " << MBW->getMinBitwidth(I->getOperand(0))
                << " - " << *I->getOperand(0) << "\n";
            out << "\tminBW op1: " << MBW->getMinBitwidth(I->getOperand(1))
					<< " - " << *I->getOperand(1) << "\n";
		}

		if (pairCount[isSigned].find(size) == pairCount[isSigned].end()) {
			pairCount[isSigned][size] = 0;
		}
		pairCount[isSigned][size]++;

		if (pairCount[isSigned][size] == 2) {
			std::string prevFuId = prevFU[isSigned][size];
			assert(prevFuId != "");

			num_multipump_ops += pairFUsForMultipumpFU(prevFuId, fuId,
					multipump_fu_num, out);
			multipump_fu_num++;

			unPairedFUs.erase(prevFuId);
			unPairedFUs.erase(fuId);

			pairCount[isSigned][size] = 0;
			prevFU[isSigned][size] = "";
		} else {
			prevFU[isSigned][size] = fuId;
		}
	}

	if (unPairedFUs.empty()) {
		assert(num_multiply_ops == num_multipump_ops);
	} else {

		out << "Some multiplier FUs were not paired with a multipump unit due "
				<< "to an odd number of multiply FUs or incompatibilities "
				<< "(sign/bitwidth):\n";
		for (std::set<std::string>::iterator i = unPairedFUs.begin(), ie =
				unPairedFUs.end(); i != ie; ++i) {
			out << "\t" << *i << "\n";
		}
	}

}

// create necessary signals for binding
// also see: visitBinaryOperator()
void GenerateRTL::createBindingSignals() {

	for (Binding::iterator i = this->binding->begin(), ie =
			this->binding->end(); i != ie; ++i) {
		Instruction *instr = i->first;
		std::string fuId = i->second;

		if (isMultipumped(instr)) {
			continue;
		}

		if (isMem(instr))
			continue;

		if (rtl->exists(fuId))
			continue;

		RTLSignal *op0, *op1;
		RTLSignal *FU, *fu;
		op0 = rtl->addWire(fuId + "_op0", RTLWidth(instr->getOperand(0), MBW));
		if (instr->isBinaryOp()) {
			op1 = rtl->addWire(fuId + "_op1",
					RTLWidth(instr->getOperand(1), MBW));
			FU = createFU(instr, op0, op1);
		} else if (instr->isCast()) {
			FU = createFU(instr, op0, NULL);
		}
		fu = rtl->addWire(fuId, FU->getWidth());
		fu->connect(FU);
	}
}

// share registers for a group of instructions assigned to the same FU
void GenerateRTL::shareRegistersForFU(std::set<Instruction *> &Instructions,
		std::map<Instruction*, std::set<Instruction*> > &IndependentInstructions) {

	// the key is the instruction that remains the shared register
	// the set of instructions are all the instructions that share the register
	std::map<Instruction *, std::set<Instruction *> > registers;

	// loop over every instruction assigned to this functional unit
	for (std::set<Instruction *>::iterator j = Instructions.begin(), je =
			Instructions.end(); j != je; ++j) {
		Instruction *instr = *j;

		// if it is a store, the verilogName(*inst) couldn't get its reg name
		if (isMem(instr)) {
			continue;
		}

		bool isSharable = false;

		// loop over all the registers
		for (std::map<Instruction *, std::set<Instruction *> >::iterator a =
				registers.begin(), ae = registers.end(); a != ae; ++a) {
			Instruction *sharedRegInstr = a->first;
			std::set<Instruction *> &instructionsAssignedToReg = a->second;
			assert(sharedRegInstr != instr);

			// are we independent from every single instruction assigned to
			// this register?
			bool independent = true;
			for (std::set<Instruction *>::iterator k =
					instructionsAssignedToReg.begin(), je =
					instructionsAssignedToReg.end(); k != je; ++k) {
				Instruction *instrAssigned = *k;

				if (IndependentInstructions[instrAssigned].find(instr)
						== IndependentInstructions[instrAssigned].end()) {
					independent = false;
				}
			}
//            errs() << "Independent?:"<<utostr(independent)<<"\n";
			if (independent) {
				isSharable = true;
				//errs() << "Shared output: " << *sharedRegInstr << "\n";
				RTLSignal *sharedReg = rtl->find(
						verilogName(sharedRegInstr) + "_reg");
				assert(sharedReg->getType() == "reg");
				RTLSignal *oldReg = rtl->find(verilogName(instr) + "_reg");

				//determine whether new register has a signed value
				bool newIsSigned = sharedReg->getWidth().getSigned()
						|| oldReg->getWidth().getSigned();
				unsigned newWidth = sharedReg->getWidth().numBits(rtl, alloc);
				unsigned oldWidth = oldReg->getWidth().numBits(rtl, alloc);
				if (newIsSigned) {
					if (!sharedReg->getWidth().getSigned())
						newWidth++;
					else if (!oldReg->getWidth().getSigned())
						oldWidth++;
				}
				if (newWidth < oldWidth)
					newWidth = oldWidth;
				newWidth = min(newWidth,
						sharedRegInstr->getType()->getPrimitiveSizeInBits());
				//              errs() << "Setting sharedReg to width:"<<utostr(newWidth)<<"\n";
//                sharedReg->setWidth(RTLWidth(newWidth));
				sharedReg->setWidth(
						RTLWidth(newWidth,
								sharedReg->getWidth().numNativeBits(rtl, alloc),
								newIsSigned));
				//               errs() << "Setting sharedReg to signed:"<<utostr(newIsSigned)<<"\n";
//                sharedReg->getWidth().setSigned(newIsSigned);

                // now make sure the shared register is active at the
                // correct times
                State *state = sched->getFSM(Fp)->getEndState(instr);
                connectSignalToDriverInState(sharedReg,
                                             rtl->find(verilogName(instr)),
                                             state, instr, OUTPUT_READY);

                // convert the old register into a wire and drive it by the
                // shared register
                // errs() << "Converting reg to wire: " << *instr << "\n";
                oldReg->setType("wire");
				oldReg->connect(sharedReg, instr);
				registers[sharedRegInstr].insert(instr);
				break;
			}
		}
		if (!isSharable) {
//            errs()<<"Creating a new shared register\n";
			// create a new shared register
			registers[instr].insert(instr);
		}
	}
}

// share registers for div/rem and multiply functional units
void GenerateRTL::shareRegistersFromBinding() {
	/*
	 std::map<std::string, std::set<Instruction *> > instructionsAssignedToFU;
	 for(Binding::iterator i = binding->begin(), ie = binding->end(); i != ie;
	 ++i) {
	 Instruction *instr = i->first;
	 std::string fuId = i->second;
	 instructionsAssignedToFU[fuId].insert(instr);
	 }*/

	// loop over all functional unit types
	for (std::map<std::string, std::set<Instruction *> >::iterator i =
			instructionsAssignedToFU.begin(), ie =
			instructionsAssignedToFU.end(); i != ie; ++i) {
		std::string fuId = i->first;
		std::set<Instruction *> &Instructions = i->second;

		std::map<Instruction*, std::set<Instruction*> > IndependentInstructions;

		// use live variable analysis to determine independent instructions
		Binding::FindIndependentInstructions(Instructions,
				IndependentInstructions, alloc->getLVA(Fp), fsm);

		shareRegistersForFU(Instructions, IndependentInstructions);
	}
}

// This string contains: function_opcodename_pair#instruction#
// For example, if we are in function f, and this is the third
// pair, we could label the nodes in the graph as:
// f_signed_add_64_p3
// The problem is a graph may have multiple signed_add_64's, so we
// add also a label for the instruction # (i):
// f_signed_add_64_p3i0, f_signed_add_64_p3i1...
std::string GenerateRTL::getPatternFUName(Graph::GraphNodes_iterator &GNi,
		int PairNumber) {
	Instruction * I = GNi->first;

	// GNi->second is the Node with that instruction (a Graph object is made of
	// nodes, and each node has an instruction as well as other information,
	// see Graph.h)
	int label = GNi->second->label;

	return alloc->verilogNameFunction(Fp, Fp) + "_"
			+ LEGUP_CONFIG->getOpNameFromInst(I, alloc) + "_p"
			+ legup::IntToString(PairNumber) + "i" + legup::IntToString(label);
}

void GenerateRTL::connectPatternFU(Graph::GraphNodes_iterator &GNi,
		int PairNumber) {
	// GNi->first is the instruction corresponding to this node
	Instruction * I = GNi->first;
	assert(GNi->second->I == GNi->first);
	// get the state of the instruction
	this->state = sched->getFSM(Fp)->getEndState(I);

	RTLWidth width(I->getType());
	// create the wire that is the output of the FU
    RTLSignal *fu = rtl->addWire(getPatternFUName(GNi, PairNumber), width);
    // and also the output register
    RTLSignal *instSig = getLeftHandSide(I);
    connectSignalToDriverInState(instSig, fu, this->state, I);
}

void GenerateRTL::create_pattern_fu(
    // the name of this FU
    std::string name1,
    // the node in graph 1 corresponding to this FU
    Node *node1, Node *node2) {

    // and the instruction
	Instruction * I1 = node1->I;
	// get the state of the instruction (in graph 1)
	this->state = sched->getFSM(Fp)->getEndState(I1);
	assert(this->state);

	RTLWidth width(I1->getType());
	// this wire will either connect to an input mux, to an input
	// register from another FU, or an input wire from another FU
	// To see which, check if this node has a predecessor in the Graph
	RTLSignal *op0;

	// if the left predecessor of this node (p1) is an operation (as
	// opposed to an input), then the op0 wire connects to the output
	// of the previous FU (wire or register)
	if (node1->p1->is_op) {
		op0 = getOp(this->state, I1->getOperand(0));
	} else { // mux
             // otherwise, the left predecessor of this node is not an
             // operation in the graph, it is an input. So, add a mux
        op0 = rtl->addWire(name1 + "_op0", width);
        connectSignalToDriverInState(op0, getOp(this->state, I1->getOperand(0)),
                                     this->state, I1);
    }
    // repeat above for right predecessor, again connecting it to an
    // input wire, reg, or a mux
    RTLSignal *op1;
	if (node1->p2->is_op) {
		op1 = getOp(this->state, I1->getOperand(1));
	} else { // mux
             // otherwise, the left predecessor of this node is not an
             // operation in the graph, it is an input. So, add a mux
        op1 = rtl->addWire(name1 + "_op1", width);
        connectSignalToDriverInState(op1, getOp(this->state, I1->getOperand(1)),
                                     this->state, I1);
    }

    // Create this FU
	RTLSignal *FU = createFU(I1, op0, op1);
	RTLSignal *fu = rtl->find(name1);
	fu->connect(FU);

	// Now we need to bind the equivalent node in graph 2 to the
	// functional unit we just created

	// This is a little tricky because graphs can be equivalent but
	// topologically different (due to commutative operations), hence
	// we will need to use the Graph2_Labels map now (mapping nodes in
	// g1 to g2 using labels), so that we can check if operands need to
	// be swapped.

	Instruction * I2 = node2->I; // the instruction
	this->state = sched->getFSM(Fp)->getEndState(I2); // its state
	assert(this->state);

	// Now, as stated above, if this node represents a commutative
	// operation, it could be that its operands need to be swapped to
	// "fit" into the functional unit it needs to be bound to.
	// To tell if this is the case, compare this node to its equivalent
	// node in graph1 ("node1")

	// case 1: Neither operand is an operation (both are mux inputs).
    // In this case, no need to swap
    if (!node1->p1->is_op && !node1->p2->is_op) {
        // op0 from above, still mux input
        connectSignalToDriverInState(op0, getOp(this->state, I2->getOperand(0)),
                                     this->state, I2);
        // op1 from above, still mux input
        connectSignalToDriverInState(op1, getOp(this->state, I2->getOperand(1)),
                                     this->state, I2);
    }

    // case 2: Both operands are instructions, so to be sure if they
    // are in the right order, we check if the labels match although,
    // order doesn't matter because this is commutative
    else if (node1->p1->is_op && node1->p2->is_op) {
    }

	// case 3: One operand is an instruction, the other isn't. But we
	// need to be sure that instruction is on the right side
	else if (node1->p1->is_op) { // OK, so the left operand is an op,
								 // so the right operand is a mux
		Value *op = I2->getOperand(1); // right side, so connect normally
        if (!node2->p1->is_op) {
            op = I2->getOperand(0); // switch operands
        }
        connectSignalToDriverInState(op1, getOp(this->state, op), this->state,
                                     I2);
    } else { // node1->p2 is an op, so left operand is a mux
        Value *op = I2->getOperand(0);
        if (!node2->p2->is_op) {
            op = I2->getOperand(1);
        }
        connectSignalToDriverInState(op0, getOp(this->state, op), this->state,
                                     I2);
    }
}

// Iterate over every pair of graphs, and create functional units / connect
// wires and reg to functional units for each pair
void GenerateRTL::create_functional_units_for_pairs() {
	int PairNumber = 0; // for naming pairs uniquely
	for (std::map<Graph*, Graph*>::iterator p = this->GraphPairs.begin(), pe =
			this->GraphPairs.end(); p != pe; ++p) {
		Graph * g1 = p->first;	// first graph in this pair (p is a reference
								// to a pair)
		Graph * g2 = p->second;	// second in the pair

		// Part 1. Assign a unique name to every node in graph 1. This is the
		// functional unit name.
		// Also here, a wire and reg is created for each node in graph 1
		std::map<Node*, std::string> FUNames; // This map keeps track of the
											  // name for every node
		// Now iterate through all the nodes in graph1 and assign names to all
		// nodes
		for (Graph::GraphNodes_iterator GNi = g1->GraphNodes.begin(), GNe =
				g1->GraphNodes.end(); GNi != GNe; ++GNi) {
			connectPatternFU(GNi, PairNumber);
			// fill our FUNames map with this node and its name
			FUNames[GNi->second] = getPatternFUName(GNi, PairNumber);
		}

		// For the next part, we will need a map of every node in graph1 to its
		// corresponding node in graph2. We could make a map<Node*, Node*>, but
		// from previous analysis (Binding.cpp) we have already labeleld all
		// nodes in each graph the same way (so equivalent nodes have the same
		// label, each label is an integer)
		std::map<unsigned, Node*> Graph2_Labels;
		for (Graph::GraphNodes_iterator GNi = g2->GraphNodes.begin(), GNe =
				g2->GraphNodes.end(); GNi != GNe; ++GNi) {
			int label = GNi->second->label;
			// now we can map an int (label) to a node in graph2, and since we
			// have also labelled all nodes in graph1 the same way, we can map
			// graph1 nodes to graph2
			Graph2_Labels[label] = GNi->second;

			connectPatternFU(GNi, PairNumber);
		}

		// Now, every FU in graph 1 has a unique name. Next, create each FU and
		// connect them properly to make the hardware chain
		// Once each FU is made from the nodes in graph1, the corresponding
		// node in graph2 will be bound to that same functional unit

		// Iterate over all nodes in the graph again, but for which we now have
		// a unique name
		for (std::map<Node*, std::string>::iterator FUi = FUNames.begin(), FUe =
				FUNames.end(); FUi != FUe; ++FUi) {
			// the name of this FU (from part 1 above)
			std::string name1 = FUi->second;
			// the node in graph 1 corresponding to this FU
			Node * node1 = FUi->first;
			// equivalent node in graph 2
			Node *node2 = Graph2_Labels[node1->label];

			create_pattern_fu(name1, node1, node2);
		}

		PairNumber++;
	}

}

//	This function is responsible for two things which are necessary to perform
//	Binding with graph objects:
//
//	1. Creating a set of properly connected functional units for each pair
//	2. For two graphs which are bound together, mapping the equivalent
// 		 instructions in both graphs to the same functional units
//
// Note that all graphs which need to be paired are already contained in the
// map GraphPairs (mapping graph g1 to graph g2 if g1 and g2 need to be paired)

void GenerateRTL::updateRTLWithPatterns() {

	create_functional_units_for_pairs();

	// all instructions from the first graph are driven by their equivalent
	// instructions from the second graph
	for (std::map<Value*, Value*>::iterator i =
			this->AllBindingPairs.begin(), e = this->AllBindingPairs.end();
			i != e; ++i) {

		std::string firstName = verilogName(i->first);
        std::string secondName = verilogName(i->second);

        if (rtl->exists(secondName + "_reg")) {
            connectSignalToDriverInState(
                rtl->find(secondName + "_reg"), rtl->find(firstName),
                fsm->getEndState((Instruction *)(i->first)),
                (Instruction *)(i->first));
        }

        RTLSignal *first = rtl->findExists(firstName);
        RTLSignal *second = rtl->findExists(secondName);
		if (first && second) {
			first->connect(second, (Instruction*) (i->first));
			if (second->getWidth().numBits(rtl, alloc)
					< first->getWidth().numBits(rtl, alloc)) {
				second->setWidth(first->getWidth());
			}
		}

		first = rtl->findExists(firstName + "_reg");
		second = rtl->findExists(secondName + "_reg");
		if (first && second) {
			// this signal shares a register with the second graph
			first->setType("wire");
			first->connect(second, (Instruction*) (i->first));
			if (second->getWidth().numBits(rtl, alloc)
					< first->getWidth().numBits(rtl, alloc)) {
				second->setWidth(first->getWidth());
			}
		}
	}
}

std::vector<PropagatingSignal> GenerateRTL::addPropagatingMemorySignalsToModuleWithPostfix(
		RTLModule *_rtl, std::string postfix) {

	std::vector<RTLSignal *> signals;
	std::vector<PropagatingSignal> propSignals;

	signals.push_back(_rtl->addOut("memory_controller_enable" + postfix));
	signals.push_back(
			_rtl->addOut("memory_controller_address" + postfix,
					RTLWidth("`MEMORY_CONTROLLER_ADDR_SIZE-1")));
	signals.push_back(_rtl->addOut("memory_controller_write_enable" + postfix));
	signals.push_back(
			_rtl->addOut("memory_controller_in" + postfix,
					RTLWidth("`MEMORY_CONTROLLER_DATA_SIZE-1")));

	if (alloc->usesGenericRAMs()) {
		signals.push_back(
				_rtl->addOut("memory_controller_size" + postfix, RTLWidth(2)));
	}
	signals.push_back(
			_rtl->addIn("memory_controller_out" + postfix,
					RTLWidth("`MEMORY_CONTROLLER_DATA_SIZE-1")));

	for (std::vector<RTLSignal *>::iterator it = signals.begin();
			it != signals.end(); ++it) {

        if ((*it)->getType() == "output") {
            (*it)->setDefaultDriver(ZERO);
            connectSignalToDriverInState(*it, ZERO, sched->getFSM(Fp)->begin());
        }

        // Create a propagating signal wrapper that points to *it,
        // stops at the top level module, and is marked as a memory
        // signal.
        PropagatingSignal propSignal(*it, true, true);
		propSignals.push_back(propSignal);

	}

	return propSignals;

}

std::vector<PropagatingSignal> GenerateRTL::addPropagatingMemorySignalsToFunctionWithPostfix(
		Function *F, std::string postfix) {

	std::vector<RTLSignal *> signals;
	std::vector<PropagatingSignal> propSignals;

	signals.push_back(new RTLSignal("memory_controller_enable" + postfix, ""));
	signals.push_back(
			new RTLSignal("memory_controller_address" + postfix, "",
					RTLWidth("`MEMORY_CONTROLLER_ADDR_SIZE-1")));
	signals.push_back(
			new RTLSignal("memory_controller_write_enable" + postfix, ""));
	signals.push_back(
			new RTLSignal("memory_controller_in" + postfix, "",
					RTLWidth("`MEMORY_CONTROLLER_DATA_SIZE-1")));

	if (alloc->usesGenericRAMs()) {
		signals.push_back(
				new RTLSignal("memory_controller_size" + postfix, "",
						RTLWidth(2)));
	}
	for (std::vector<RTLSignal *>::iterator it = signals.begin();
			it != signals.end(); ++it) {

		(*it)->setType("output");

	}

	RTLSignal *controllerOut = new RTLSignal("memory_controller_out" + postfix,
			"", RTLWidth("`MEMORY_CONTROLLER_DATA_SIZE-1"));
	controllerOut->setType("input");
	signals.push_back(controllerOut);

	for (std::vector<RTLSignal *>::iterator it = signals.begin();
			it != signals.end(); ++it) {

		// Create a propagating signal wrapper that points to *it,
		// stops at the top level module, and is marked as a memory
		// signal.
		PropagatingSignal propSignal(*it, true, true);
		propSignals.push_back(propSignal);

	}

	return propSignals;

}

void GenerateRTL::addPropagatingMemorySignalsToFunction(Function *F) {

	std::vector<PropagatingSignal> aSignals, bSignals;
	aSignals = addPropagatingMemorySignalsToFunctionWithPostfix(F, "_a");
	bSignals = addPropagatingMemorySignalsToFunctionWithPostfix(F, "_b");

	RTLSignal *waitrequest = new RTLSignal("memory_controller_waitrequest", "");
	waitrequest->setType("input");
	PropagatingSignal propWaitrequest(waitrequest, true, true);

	PropagatingSignals *ps = alloc->getPropagatingSignals();
	ps->addPropagatingSignalsToFunctionNamed(F->getName().str(), aSignals);
	ps->addPropagatingSignalsToFunctionNamed(F->getName().str(), bSignals);
	ps->addPropagatingSignalToFunctionNamed(F->getName().str(),
			propWaitrequest);
}

void GenerateRTL::addPropagatingSignalsToCustomVerilog(Function *F) {

	bool isCV = LEGUP_CONFIG->isCustomVerilog(*F);
	assert(
			isCV
					&& "You can only add propagating signals to Custom Verilog functions.\n");

	bool requiresMemorySignals = LEGUP_CONFIG->customVerilogUsesMemory(*F);
	std::vector<CustomVerilogIO> cvIO =
			LEGUP_CONFIG->getCustomVerilogIOForFunction(F);

	for (std::vector<CustomVerilogIO>::iterator it = cvIO.begin();
			it != cvIO.end(); ++it) {

		CustomVerilogIO &cvIO = *it;
		RTLWidth width = RTLWidth(cvIO.bitFrom, cvIO.bitTo);
		RTLSignal *signal = new RTLSignal(cvIO.name, "", width);

		if (cvIO.isInput) {
			signal->setType("input");
		} else {
			signal->setType("output");
		}

		// Create the Propagating Signal wrapper
		//
		PropagatingSignal propSignal(signal);
		PropagatingSignals *ps = alloc->getPropagatingSignals();
		ps->addPropagatingSignalToFunctionNamed(F->getName().str(), propSignal);

	}

	if (requiresMemorySignals) {

        addPropagatingMemorySignalsToFunction(F);
    }
}

// Adds propagating ports to a module or a wire if
// the propagating signal stops propagating at this
// function.
//
void GenerateRTL::addPropagatingPortsToModule(RTLModule *_rtl) {

    PropagatingSignals *ps = alloc->getPropagatingSignals();
    std::string functionName = Fp->getName().str();

    bool propagatingMemoryAdded = false;

    // Adds a signal that will propagate to a custom verilog module
    //
    assert(!(LEGUP_CONFIG->isCustomVerilog(functionName)) &&
           "You can't process a custom verilog module!");

    std::vector<Function *> functions = getFunctionsCalledByFunction(Fp);
	std::vector<std::string> functionNames;

	for (std::vector<Function *>::iterator it = functions.begin();
			it != functions.end(); ++it) {

		Function *function = *it;

		std::vector<std::string>::iterator b = functionNames.begin();
		std::vector<std::string>::iterator e = functionNames.end();
		if (std::find(b, e, function->getName().str()) == e) {
			functionNames.push_back(function->getName().str());
		}

		if (LEGUP_CONFIG->isCustomVerilog(function->getName().str())) {

			// Custom Verilog Modules don't exist in the RTL, so we add
			// their propagating signals to the propagating signals
            // data structure whenever custom verilog modules are
            // instantiated.
            //
            addPropagatingSignalsToCustomVerilog(function);
        }
    }

    std::vector<PropagatingSignal *> signals =
        ps->getPropagatingSignalsForFunctionsWithNames(functionNames);

    for (std::vector<PropagatingSignal *>::iterator si = signals.begin();
         si != signals.end();) {

        PropagatingSignal propSignalCopy = **si;
        // PropagatingSignal *propSignal = *si;
        si++;
        RTLSignal *signal;

        // if local RAMs is turn on, and all RAMS are localized
        // for this function, then continue
        // MATHEW TODO: Fix this check for "memory_controller_waitrequest"
        /*
                if (LEGUP_CONFIG->getParameterInt("LOCAL_RAMS") &&
                        alloc->fctOnlyUsesLocalRAMs(Fp) &&
                        propSignalCopy.getName() !=
           "memory_controller_waitrequest")
                    continue;
        */
        if (propSignalCopy.stopsPropagatingAtFunction(Fp)) {

            // TODO: Account for multiple propagating signals that stop at the
            // same function and have the same name
            // What if two have the same name but one of them doesn't stop here?

            _rtl->addWire(propSignalCopy.getName(), propSignalCopy.getWidth());
            continue;
        }

        bool isPthreadsMemSignal = propSignalCopy.isMemory() && usesPthreads;
        string propSignalCopyName;

        if (isPthreadsMemSignal) {
            propSignalCopyName = propSignalCopy.getPthreadsMemSignalName();
            propSignalCopy.setShouldConnectToPthreadsMemName(true);
        } else {
            propSignalCopyName = propSignalCopy.getName();
        }
        if (propSignalCopy.getType() == "input") {
            signal = _rtl->addIn(propSignalCopyName, propSignalCopy.getWidth());
        } else if (propSignalCopy.getType() == "output") {
            signal =
                _rtl->addOut(propSignalCopyName, propSignalCopy.getWidth());
        }

        if (!isPthreadsMemSignal &&
            (propSignalCopy.isMerged() || propSignalCopy.isMemory()))
            signal->setDefaultDriver(ZERO);

        // RTLSignal *previousSignal = propSignal->getSignal();
        propSignalCopy.setSignal(signal);
        ps->addPropagatingSignalToFunctionNamed(functionName, propSignalCopy);

        // if one of the propagating signals is memory_controller_enable_a
        // then an instantiated module uses memory and we don't need to
        // manually add the memory.
        //
        if (!propagatingMemoryAdded && propSignalCopy.isMemory())
            propagatingMemoryAdded = true;
    }

    bool requiresMemorySignals = false;
    if (!propagatingMemoryAdded)
        requiresMemorySignals = functionRequiresMemory(Fp);

    // Add the memory signals if the function needs memory and if the signals
    // were not already added.
    //
    if (!propagatingMemoryAdded && requiresMemorySignals && !usesPthreads) {

        // MATHEW TODO: generalize this for waitrequest signal
        RTLSignal *waitrequest = _rtl->addIn("memory_controller_waitrequest");
        waitrequest->setDefaultDriver(ZERO);
        PropagatingSignal propWaitrequest(waitrequest, true, true);
        ps->addPropagatingSignalToFunctionNamed(functionName, propWaitrequest);

        if (!(LEGUP_CONFIG->getParameterInt("LOCAL_RAMS") &&
              alloc->fctOnlyUsesLocalRAMs(Fp))) {
            std::vector<PropagatingSignal> aSignals, bSignals;
            aSignals =
                addPropagatingMemorySignalsToModuleWithPostfix(_rtl, "_a");
            bSignals =
                addPropagatingMemorySignalsToModuleWithPostfix(_rtl, "_b");

            ps->addPropagatingSignalsToFunctionNamed(functionName, aSignals);
            ps->addPropagatingSignalsToFunctionNamed(functionName, bSignals);
        }
    }
}

void GenerateRTL::addDefaultPortsToModule(RTLModule *_rtl) {
    _rtl->addIn("clk");
	_rtl->addIn("clk2x");
	_rtl->addIn("clk1x_follower");
	_rtl->addIn("reset");
	_rtl->addIn("start");
	_rtl->addOutReg("finish");
}

void GenerateRTL::generateVariableDeclarationsSignalsMemory(
    RTLModule *t, Function *F, const std::string fctName,
    const std::string postfix, const std::string instanceName) {
    RTLSignal *en = rtl->find(fctName + "_memory_controller_enable" + postfix +
                              instanceName);

    RTLSignal *addr = rtl->addWire(fctName + "_memory_controller_address" +
                                       postfix + instanceName,
                                   RTLWidth("`MEMORY_CONTROLLER_ADDR_SIZE-1"));

    RTLSignal *we = rtl->find(fctName + "_memory_controller_write_enable" +
                              postfix + instanceName);

    RTLSignal *in =
        rtl->addWire(fctName + "_memory_controller_in" + postfix + instanceName,
                     RTLWidth("`MEMORY_CONTROLLER_DATA_SIZE-1"));

    RTLSignal *out =
        rtl->addReg(fctName + "_memory_controller_out" + postfix + instanceName,
                    RTLWidth("`MEMORY_CONTROLLER_DATA_SIZE-1"));

    const RTLSignal *defaultDriver = out->getDefaultDriver();
    if (!defaultDriver) {
        out->setDefaultDriver(ZERO);        
    }

	t->addOut("memory_controller_enable" + postfix)->connect(en);
	t->addOut("memory_controller_address" + postfix)->connect(addr);
	t->addOut("memory_controller_write_enable" + postfix)->connect(we);
	t->addOut("memory_controller_in" + postfix)->connect(in);

    if (alloc->usesGenericRAMs()) {
        RTLSignal *size = rtl->addWire(fctName + "_memory_controller_size" +
                                           postfix + instanceName,
                                       RTLWidth(2));
        t->addOut("memory_controller_size" + postfix)->connect(size);
    }
    t->addOut("memory_controller_out" + postfix)->connect(out);
}

void GenerateRTL::generatePropagatingSignalDeclarations(RTLModule *t,
		Function *F) {

	std::string fctName = F->getName();

	// Get a pointer to the PropagatingSignals singleton
	//
	PropagatingSignals *ps = alloc->getPropagatingSignals();
	std::vector<PropagatingSignal *> signals =
			ps->getPropagatingSignalsForFunctionNamed(F->getName().str());

	// Iterate through propagating signals and add them to the variable declarations
	//
	for (std::vector<PropagatingSignal *>::iterator si = signals.begin();
			si != signals.end(); ++si) {

		PropagatingSignal *propSignal = *si;
		std::string signalType = propSignal->getType();
        RTLSignal *signal;
        RTLSignal *
            wire; // For connecting the propagating signal to the current module

        // Add the propagating signal as either an input or an output
        //
        std::string propSignalName;
        if (propSignal->shouldConnectToPthreadsMemName()) {
            propSignal->setShouldConnectToPthreadsMemName(false);
            propSignalName = propSignal->getPthreadsMemSignalName();
        } else {
            propSignalName = propSignal->getName();
        }

        if (signalType == "input") {
            signal = t->addIn(propSignalName, propSignal->getWidth());

            std::string existingSignalName;
            existingSignalName = propSignal->getName();

            wire = rtl->find(existingSignalName); // For inputs we can connect
                                                  // the signal directly
        } else { // Propagating signals can only be inputs or outputs, so this
                 // is an output
            signal = t->addOut(propSignalName, propSignal->getWidth());
            wire = rtl->find(fctName + "_" +
                             propSignal->getName()); // Outputs must be
                                                     // connected through the
                                                     // state machine
        }

        signal->connect(wire);
    }
}

void GenerateRTL::addTagOffsetParamToModule(Function *F, const int numThreads,
                                            const int instanceNum,
                                            RTLModule *t) {

    // add a defparam for the tag
    // used to steer memory accesses to correct instance of RAM
    // for arrays (allocas) in parallel functions
    std::string tag_offset = "tag_offset";

    if (numThreads) {
        std::string totalThreads;
        if (F->hasFnAttribute("totalNumThreads")) {
            tag_offset +=
                "*" +
                F->getFnAttribute("totalNumThreads").getValueAsString().str();
        }
        tag_offset += "+" + utostr(instanceNum);
    }
    t->addParam("tag_offset", tag_offset);
}

void GenerateRTL::generateModuleInstantiation(Function *F, CallInst *CI,
                                              const int numThreads,
                                              const std::string fctName,
                                              const std::string functionType,
                                              int loopIndex) {

    std::string instanceName = getInstanceName(CI, loopIndex);

    RTLSignal *start = rtl->addReg(fctName + "_start" + instanceName);
    RTLSignal *finish = rtl->addWire(fctName + "_finish" + instanceName);

    RTLModule *t = rtl->addModule(fctName, fctName + instanceName);
    if (!numThreads) {
        calledModulesToRtlMap[F] = t;
        generatePropagatingSignalDeclarations(t, F);
    }

    t->addIn("clk")->connect(rtl->find("clk"));
    t->addIn("clk2x")->connect(rtl->find("clk2x"));
    t->addIn("clk1x_follower")->connect(rtl->find("clk1x_follower"));
    t->addIn("reset")->connect(rtl->find("reset"));
    t->addIn("start")->connect(start);
    t->addOut("finish")->connect(finish);

    if (!LEGUP_CONFIG->isCustomVerilog(*F)) {
        addTagOffsetParamToModule(F, numThreads, getInstanceNum(CI, loopIndex),
                                  t);
    }

    const Type *rT = F->getReturnType();
    // if it is a non-void function, or it is a pthread call wrapper with a
    // return value
    // insert the return_val output port and connect to the return_val wire
    // for the instance
    if (rT->getTypeID() != Type::VoidTyID) {
        RTLWidth T(rT);
        RTLSignal *ret =
            rtl->addWire(fctName + "_return_val" + instanceName, T);
        t->addOut("return_val", T)->connect(ret);
    }

    // MATHEW: this is commented out for sequential functions
    // can you generalize generatePropagatingSignalDeclarations
    // for parallel functions?
    if (numThreads) {
        generateVariableDeclarationsSignalsMemory(t, F, fctName, "_a",
                                                  instanceName);
        generateVariableDeclarationsSignalsMemory(t, F, fctName, "_b",
                                                  instanceName);

        RTLSignal *wait = rtl->addReg(
            fctName + "_memory_controller_waitrequest" + instanceName);
        wait->setDefaultDriver(ZERO);
        t->addOut("memory_controller_waitrequest")->connect(wait);
    }

    for (Function::arg_iterator i = F->arg_begin(), e = F->arg_end(); i != e;
         ++i) {
        //// TODO: fix this
        std::string argName = alloc->verilogNameFunction(i, F);
        std::string name = fctName + "_" + argName + instanceName;
        // if argument name is threadID and there are parallel instances
        // this means that it's using OpenMP threads
        // as the threadID pass in induction variable i
        // this assigns a threadID for each thread
        // for when they are accessing mutexes,
        // just using i will make threadID the same when they are from different
        // avalon accelerators
        // hence we use threadMutexID (which is equal to base address of that
        // avalon accelerator) + i
        if (numThreads && argName == "arg_threadID" &&
            functionType == "omp_function") {
            // for OpenMP
            t->addOut(argName, RTLWidth(i->getType()))
                ->connect(rtl->addConst(utostr(loopIndex), 32));
        } else if (numThreads && argName == "arg_threadMutexID") {
            RTLSignal *arg = rtl->addWire(name, RTLWidth(i->getType()));
            t->addOut(argName, RTLWidth(i->getType()))
                ->connect(rtl->addOp(RTLOp::Add)->setOperands(
                    arg, rtl->addConst(utostr(loopIndex), 32)));
        } else {
            RTLSignal *arg = rtl->addWire(name, RTLWidth(i->getType()));
            t->addOut(argName, RTLWidth(i->getType()))->connect(arg);
        }
    }
}

void GenerateRTL::generateVariableDeclarations(CallInst *CI,
                                               const std::string functionType) {

    // get the number of threads
    int numThreads = getNumThreads(CI);

    Function *F = getCalledFunction(CI);
    if (calledModules.find(F) != calledModules.end() && !numThreads)
        return;
    calledModules.insert(F);

    std::string fctName = verilogName(F);
    if (numThreads) {
        for (int index = 0; index < numThreads; index++) {
            generateModuleInstantiation(F, CI, numThreads, fctName,
                                        functionType, index);
        }
    } else {
        generateModuleInstantiation(F, CI, numThreads, fctName, functionType);
    }

    // create arbiter instance to arbitrate between memory signals
    // from parallel functions
    if (numThreads > 1 && functionType != "legup_wrapper_pthreadcall") {
        generateRoundRobinArbiterDeclaration(fctName, numThreads);
    }
}

// generate memory controller signals for the master thread (main FSM)
// i.e., waitrequest and readdata logic
void GenerateRTL::generatePthreadMasterThreadLogic() {

    std::string name = Fp->getName().str();
    RTLSignal *gnt = rtl->find(name + "_memory_controller_gnt_0");
    RTLSignal *wait = rtl->find("memory_controller_waitrequest");
    RTLSignal *waitParent = rtl->find("memory_controller_waitrequest_arbiter");
    RTLSignal *req = rtl->addOp(RTLOp::Or)
                         ->setOperands(rtl->find("memory_controller_enable_a"),
                                       rtl->find("memory_controller_enable_b"));
    RTLSignal *notGnt = rtl->addOp(RTLOp::Not)->setOperands(gnt);
	wait->connect(
			rtl->addOp(RTLOp::Or)->setOperands(waitParent,
					rtl->addOp(RTLOp::And)->setOperands(req, notGnt)));

	// create the logic to take in the readdata coming from the memory controller
	std::string funcName = "memory_controller";
	createMemoryReaddataLogicForParallelInstance(gnt, funcName, "_a");
	createMemoryReaddataLogicForParallelInstance(gnt, funcName, "_b");
}

//create arbiter instance for pthread parallel functions
void GenerateRTL::generatePthreadArbiter(
		const std::set<CallInst*> pthreadFunctions) {

	// set arbiter usage
	LEGUP_CONFIG->setArbiterUsage(true);

	std::string arbiterName = "round_robin_arbiter";

	std::string parentFctName =
			(*(pthreadFunctions.begin()))->getParent()->getParent()->getName();
    RTLModule *t = rtl->addModule(arbiterName,
                                  arbiterName + "_" + parentFctName + "_inst");

    t->addIn("clk")->connect(rtl->find("clk"));
    t->addIn("rst_an")
        ->connect(rtl->addOp(RTLOp::Not)->setOperands(rtl->find("reset")));

    // only connect the waitrequest signal to the arbiter in the hybrid case
    // you only need to stall the arbiter when waiting for off-chip memory
    if (LEGUP_CONFIG->isHybridFlow())
        t->addIn("waitrequest")
            ->connect(rtl->find("memory_controller_waitrequest"));
    else
        t->addIn("waitrequest")->connect(ZERO);

    // connect memory controller enable signals to arbiter request input
    // connect arbiter grant output to memory controller grant signals
    connectMemoryControllerSignalsToArbiter(t, pthreadFunctions, parentFctName);

    // connect all other memory controller signals to
    // module ouput depending on the grant signal
    connectMemoryControllerSignalsToModuleOutputWithArbiterGrant(
        pthreadFunctions, parentFctName, "_a");
    connectMemoryControllerSignalsToModuleOutputWithArbiterGrant(
        pthreadFunctions, parentFctName, "_b");
}

void GenerateRTL::connectMemoryControllerSignalsToArbiter(
    RTLModule *t, const std::set<CallInst *> pthreadFunctions,
    const std::string parentFctName) {

    // need to concatenate memory_controller_enable signals from each parallel
    // function instance
    // and connect to the request input of arbiter
    RTLSignal *req, *gnt, *en;
    std::vector<RTLSignal *> reqVector, gntVector;
    std::string instanceName, pthreadFuncName;
    int numThreads, arbiterSize = 0;
    CallInst *CI;
    int index;
    // build a vector of signals
    for (std::set<CallInst *>::const_iterator it = pthreadFunctions.begin();
         it != pthreadFunctions.end(); it++) {
        CI = *it;
        numThreads = getNumThreads(CI);
        for (int i = 0; i < numThreads; i++) {
            instanceName = getInstanceName(CI, i);
            index = getInstanceNum(CI, i);
            pthreadFuncName = CI->getCalledFunction()->getName();
            en = rtl->addOp(RTLOp::Or)->setOperands(
                rtl->find(pthreadFuncName + "_memory_controller_enable_a" +
                          instanceName),
                rtl->find(pthreadFuncName + "_memory_controller_enable_b" +
                          instanceName));
            req = en;
            // add the memory controller enable signals
            // from each pthread instance
            reqVector.push_back(req);

            gnt = rtl->find(pthreadFuncName + "_memory_controller_gnt_" +
                            utostr(index));
            // add the  memory controller grant signals
            // from each pthread instance
            gntVector.push_back(gnt);
        }
        arbiterSize += numThreads;
    }

    // add the main thread's memory controller enable signals
    en = rtl->addOp(RTLOp::Or)
             ->setOperands(rtl->find("memory_controller_enable_a"),
                           rtl->find("memory_controller_enable_b"));
    reqVector.push_back(en);
    // increment arbiterSize since for main thread's
    // memory controller signals
    arbiterSize++;

    // build the operation out of the vector of
    // memory_controller_enable signals
    RTLOp *reqOp = rtl->recursivelyAddOp(RTLOp::Concat, reqVector, arbiterSize);
    assert(reqOp);
    // connect to the request input
    t->addIn("req_in", RTLWidth(arbiterSize))->connect(reqOp);

    // add the gnt signal for main thread
    gnt = rtl->addWire(parentFctName + "_memory_controller_gnt_0");
    gntVector.push_back(gnt);
    // build the operation out of the vector of
    // memory_controller_gnt signals
    RTLOp *gntOp = rtl->recursivelyAddOp(RTLOp::Concat, gntVector, arbiterSize);
    assert(gntOp);

    // connect to grant output from arbiter
    t->addOut("grant_final", RTLWidth(arbiterSize))->connect(gntOp);

    // set the number of threads (number of inputs) for arbiter
    t->addParam("N", utostr(arbiterSize));
}
void GenerateRTL::connectMemoryControllerSignalsToModuleOutputWithArbiterGrant(
    const std::set<CallInst *> pthreadFunctions,
    const std::string parentFctName, const std::string postfix) {

    // get the memory controller output ports for this module
    RTLSignal *en = rtl->find("memory_controller_enable_arbiter" + postfix);
    RTLSignal *we =
        rtl->find("memory_controller_write_enable_arbiter" + postfix);
    RTLSignal *addr = rtl->find("memory_controller_address_arbiter" + postfix);
    RTLSignal *in = rtl->find("memory_controller_in_arbiter" + postfix);
    RTLSignal *size = rtl->find("memory_controller_size_arbiter" + postfix);

    // for parallel instances
    // connect memory controller signals of parallel instance to
    // parent memory controller signals if gnt signal is asserted for that
    // instance
    for (std::set<CallInst *>::const_iterator it = pthreadFunctions.begin();
         it != pthreadFunctions.end(); it++) {
        CallInst *CI = *it;
        int numThreads = getNumThreads(CI);
        for (int i = 0; i < numThreads; i++) {
            std::string instanceName = getInstanceName(CI, i);
            int index = getInstanceNum(CI, i);

            std::string pthreadFuncName = CI->getCalledFunction()->getName();

            RTLSignal *gnt_inst = rtl->find(
                pthreadFuncName + "_memory_controller_gnt_" + utostr(index));

            RTLSignal *en_inst =
                rtl->find(pthreadFuncName + "_memory_controller_enable" +
                          postfix + instanceName);
            RTLSignal *we_inst =
                rtl->find(pthreadFuncName + "_memory_controller_write_enable" +
                          postfix + instanceName);
            RTLSignal *addr_inst =
                rtl->find(pthreadFuncName + "_memory_controller_address" +
                          postfix + instanceName);
            RTLSignal *in_inst =
                rtl->find(pthreadFuncName + "_memory_controller_in" + postfix +
                          instanceName);
            RTLSignal *size_inst =
                rtl->find(pthreadFuncName + "_memory_controller_size" +
                          postfix + instanceName);

            en->addCondition(gnt_inst, en_inst);
            we->addCondition(gnt_inst, we_inst);
            addr->addCondition(gnt_inst, addr_inst);
            in->addCondition(gnt_inst, in_inst);
            size->addCondition(gnt_inst, size_inst);
        }
    }

    // grant signal for main thread
    RTLSignal *gnt_main = rtl->find(parentFctName + "_memory_controller_gnt_0");
    // memory controller signals for main thread
    RTLSignal *en_main = rtl->find("memory_controller_enable" + postfix);
    RTLSignal *we_main = rtl->find("memory_controller_write_enable" + postfix);
    RTLSignal *addr_main = rtl->find("memory_controller_address" + postfix);
    RTLSignal *in_main = rtl->find("memory_controller_in" + postfix);
    RTLSignal *size_main = rtl->find("memory_controller_size" + postfix);

    // connect main thread's memory controller signals
    // to module output
    en->addCondition(gnt_main, en_main);
    we->addCondition(gnt_main, we_main);
    addr->addCondition(gnt_main, addr_main);
    in->addCondition(gnt_main, in_main);
    size->addCondition(gnt_main, size_main);
}

// create arbiter instance for when parallel functions are used
void
GenerateRTL::generateRoundRobinArbiterDeclaration(const std::string fctName,
                                                  const int parallelInstances) {

    // set arbiter usage
	LEGUP_CONFIG->setArbiterUsage(true);

	std::string arbiterName = "round_robin_arbiter";

	RTLModule *t = rtl->addModule(arbiterName,
			arbiterName + "_" + fctName + "_inst");

	t->addIn("clk")->connect(rtl->find("clk"));
	//t->addIn("rst_an")->connect(rtl->find("reset"));
	t->addIn("rst_an")->connect(
			rtl->addOp(RTLOp::Not)->setOperands(rtl->find("reset")));
//    if (LEGUP_CONFIG->isHybridFlow())
	t->addIn("waitrequest")->connect(
			rtl->find("memory_controller_waitrequest"));
//    else
//        t->addIn("waitrequest")->connect(ZERO);

	//need to concatenate memory_controller_enable signals from each parallel function instance
	//and connect to the request signal
	//build a vector of signals
	RTLSignal *req, *en;
	std::vector<RTLSignal*> sigVector, bramAccessVector;
	std::string instanceNum, instanceNum2;
	for (int i = 0; i < parallelInstances; i++) {
		instanceNum = "_inst" + utostr(i);
		/*
		 sdram_sdram_stall = rtl->find("sdram_sdram_stall" + instanceNum);

		 //if other instances accessed BRAM in previous cycle and this instance wants to access SDRAM in current cycle
		 bram_sdram_stall = rtl->find("bram_sdram_stall" + instanceNum);

		 //if other instances accessed BRAM in previous cycle and this instance wants to access BRAM in current cycle
		 bram_bram_stall = rtl->find("bram_bram_stall" + instanceNum);

		 sdram_bram_stall = rtl->find("sdram_bram_stall" + instanceNum);
		 */
		en = rtl->addOp(RTLOp::Or)->setOperands(
				rtl->find(
						fctName + "_memory_controller_enable_a_inst"
								+ utostr(i)),
				rtl->find(
						fctName + "_memory_controller_enable_b_inst"
								+ utostr(i)));

		//if (LEGUP_CONFIG->numAccelerators() > 0) {
		if (LEGUP_CONFIG->isHybridFlow()) {
			req = en;
//            gnt_stall = rtl->find("gnt_stall" + instancenum);
//            req = rtl->addop(rtlop::and)->setoperands(en,
//                    rtl->addop(rtlop::not)->setoperands(gnt_stall)); 
		} else {
			req = en;
		}

		sigVector.push_back(req);
	}

	//build the operation out of the vector of signals
	RTLOp *reqOp = rtl->recursivelyAddOp(RTLOp::Concat, sigVector,
			parallelInstances);
	//connect to the request input
	t->addIn("req_in", RTLWidth(parallelInstances))->connect(reqOp);

	//connecting the grant output
    sigVector.clear();
    for (int i = 0; i < parallelInstances; i++) {
        // RTLSignal *sig = rtl->addWire("gnt_" + utostr(i));
        RTLSignal *sig =
            rtl->find(fctName + "_memory_controller_gnt_" + utostr(i));
        sigVector.push_back(sig);
    }
    // build the operation out of the vector of signals
    RTLOp *gntOp = rtl->recursivelyAddOp(RTLOp::Concat, sigVector,
			parallelInstances);

	//connect to grant output from arbiter
	t->addOut("grant_final", RTLWidth(parallelInstances))->connect(gntOp);

	t->addParam("N", utostr(parallelInstances));
}

RTLSignal *GenerateRTL::getFloatingPointConstantSignal(const ConstantFP *c) {
	SmallString<40> E;
	c->getValueAPF().bitcastToAPInt().toStringUnsigned(E, 16);
	std::string str = utostr(getBitWidth(c->getType())) + "'h";
	str = str.append(E.str());
	RTLSignal *ret = rtl->addConst(str, RTLWidth(c->getType()));
	return ret;
}

RTLSignal *GenerateRTL::getConstantSignal(const ConstantInt *c) {
	std::string str;
	// I can't use the abs() method because it doesn't work
	// when the APInt is the maximum negative value
	// ie. abs(-2^63) = -2^63 for a 64-bit number
	APInt val = c->getValue();
	std::string numStr = val.toString(10, true);
	//for some reason, when we have
	//i1 true, this returns -1 when you getValue()
	//so we add a case for when it is one and the bitwidth is 1
	//then remove the - sign from the front
	if (c->isOne() && c->getBitWidth() == 1) {
		// remove '-' sig
		assert(numStr[0] == '-');
		numStr.erase(0, 1);
	} else if (val.isNegative()) {
		// remove '-' sig
		assert(numStr[0] == '-');
		numStr.erase(0, 1);
		str = "-";
	}

	// needed for integers bigger than 32 bits (otherwise
	// Modelsim gives an error)
	str += utostr(getBitWidth(c->getType())) + "'d" + numStr;

	RTLSignal *ret = rtl->addConst(str, RTLWidth(c, MBW));
	return ret;
}

//NC changes... wrapper

RTLSignal* GenerateRTL::getOpConstant(State *state, Constant *op) {
	int value = 0;
	return getOpConstant(state, op, value);
}

RTLSignal* GenerateRTL::getOpConstant(State *state, Constant *op, int &value) {

	//std::cout << "getOpConstant - value: " << value << std::endl;

	std::string str;

	if (const ConstantInt *c = dyn_cast<ConstantInt>(op)) {
		value = c->getSExtValue();
		return getConstantSignal(c);
	} else if (const ConstantFP *c = dyn_cast<ConstantFP>(op)) {
		//value is not important here.... I only use value for index which has to be integer....
		return getFloatingPointConstantSignal(c);
	} else if (isa<ConstantPointerNull>(op)) {
		RTLSignal *ret = rtl->addConst("0",
				RTLWidth("`MEMORY_CONTROLLER_ADDR_SIZE-1"));
		value = 0;
		//std::cout << "getOpConstant - constantPointerNull - value set to: " << value << std::endl;
		return ret;

	} else if (ConstantExpr *ce = dyn_cast<ConstantExpr>(op)) {
		// ie. %st.04.i = getelementptr i64* bitcast (%struct.point* @p1 to i64*), i32 %indvar.i ;
		// where bitcast (%struct.point* @p1 to i64*) is the operand
		assert(ce->isCast());
		int opValue = 0;
		RTLSignal* r = getOp(state, ce->getOperand(0), opValue);
		value = opValue;
		//std::cout << "getOpConstant - ConstantExpr - value set to: " << value << std::endl;
		return r;

	// TODO LLVM 3.4 update: a case we _may_ need to deal with?
    } else if (ConstantVector *ca = dyn_cast<ConstantVector>(op)) {
		errs() << "ConstantVector: " << *ca << "\n";
        llvm_unreachable("ConstantVector support not implemented");
	// TODO LLVM 3.4 update: a new case we need to deal with (exhibited in chstone/adpcm)
    } else if (ConstantDataVector *ca = dyn_cast<ConstantDataVector>(op)) {
		errs() << "ConstantDataVector: " << *ca << "\n";
        llvm_unreachable("ConstantDataVector support not implemented");
	// TODO LLVM 3.4 update: a new case we need to deal with (exhibited in chstone/gsm, mandelbrot)
    } else if (ConstantAggregateZero *cz = dyn_cast<ConstantAggregateZero>(op)) {
		errs() << "ZeroInitializer: " << *cz << "\n";
        llvm_unreachable("ZeroInitializer support not implemented");

	} else if (isa<UndefValue>(op)) {
        std::cout << "Warning: Used undefined value. Setting to 0.\n";
		RTLSignal *ret = rtl->addConst("0", RTLWidth(op->getType()));
		value = 0;
		//std::cout << "getOpConstant - UndefValue - value set to: " << value << std::endl;
		return ret;

	} else if (isa<Function>(op)) {
		errs() << "Function pointer to: " << op->getName() << "\n";
		llvm_unreachable("Function pointers are unsupported");

	} else {
		errs() << *op << "\n";
		llvm_unreachable("Unknown constant operand");
	}
}

RTLSignal* GenerateRTL::getOpNonConstant(State *state, Value *op) {

	assert(!isa<Constant>(op));

	std::string wire = verilogName(op);
	std::string reg = wire + "_reg";
	if (state->isWaitingForPipeline() && isPipelined(op)) {

		BasicBlock *BB = state->getBasicBlock();
		assert(BB);
		std::string label = getPipelineLabel(BB);
		const Instruction *inductionVar = getInductionVar(BB);
		if (op == inductionVar) {
			wire = label + "_i_stage" + utostr(this->stage);

			//} else if (PHINode *phi = dyn_cast<PHINode>(op)) {
			/*
			 } else if (isa<PHINode>(op)) {
			 RTLSignal *phi = rtl->find(reg);
			 return phi;
			 */

		} else {
			RTLSignal *sig = getPipelineSignal(op, this->time);
			//errs() << "time: " << this->time << " op: " << *op << "\n";
			assert(sig);
			return sig;
		}
		reg = wire;
	}

	Instruction *I = dyn_cast<Instruction>(op);
	if (!I)
		return rtl->find(wire);

	//errs() << *I << "\n";
	//errs() << "type: " << verilogName(I) << " " <<
	//    rtl->find(verilogName(I))->getType() << "\n";

	// Temporary solution: For compare instructions, we don't need
	// an output register. This is supposed to be done by
	// remove_conditional_register but it doesn't remove all reg.
	// Also true for operands to function args.. not sure how else to
	// remove these registers
	if ((isa<ICmpInst>(*I) || multi_cycle_force_wire_operand(I))
			&& LEGUP_CONFIG->mc_remove_reg_from_icmp_instructions()) {
		return rtl->find(wire);
	}

	RTLSignal *signal = NULL;
	if (fromOtherState(op, state)) {
		signal = rtl->find(reg);
	} else {
		signal = rtl->find(wire);
	}
	return signal;
}

//NC changes... wrapper

RTLSignal *GenerateRTL::getOp(State *state, Value *op) {
	int value = 0;
	return getOp(state, op, value);
}

RTLSignal *GenerateRTL::getOp(State *state, Value *op, int &value) {
	RTLSignal *ret = NULL;

	//std::cout << "start-getOp - input value: " << value << std::endl;

	ConstantExpr *CE = dyn_cast<ConstantExpr>(op);
	if (CE && CE->getOpcode() == Instruction::GetElementPtr) {
		int gepValue = 0;
		ret = getGEP(state, CE, gepValue);
		value = gepValue;
		//std::cout << "getOp - GEP - value set to: " << value << std::endl;
	} else {
		if (isa<GlobalVariable>(op) || isa<AllocaInst>(op)) {
			RAM *ram = getRam(op);
			if (LEGUP_CONFIG->getParameterInt("LOCAL_RAMS")
					&& alloc->isRAMLocaltoFct(Fp, ram)) {
				// no TAGs - base address is always 0
				ret = ZERO;
				value = 0;
			} else {

                // if there are multiple instances of this RAM
                // due to parallel threads
                // add an offset to the tag
                RTLSignal *tag;
		        RTLSignal *originalTag = rtl->addConst("`" + ram->getTagAddrName(),
						RTLWidth("`MEMORY_CONTROLLER_ADDR_SIZE-1"));                
                if (ram->getNumInstances() > 1) {
                    tag = rtl->addOp(RTLOp::Add)->setOperands(
                            originalTag, 
                            rtl->addConst("tag_addr_offset",
                                RTLWidth("`MEMORY_CONTROLLER_ADDR_SIZE-1")));
                } else {
				    tag = originalTag;
                }
				ret = tag;
			}
		} else if (Constant *c = dyn_cast<Constant>(op)) {
			int opConstantValue = 0;
			ret = getOpConstant(state, c, opConstantValue);
			value = opConstantValue;
			//std::cout << "getOp - constant - value set to: " << value << std::endl;
		} else {
			ret = getOpNonConstant(state, op);

		}
	}
	return ret;

}

// taken from CBackend
// For every branch between basic blocks we call this function.
// 'CurBlock' is the last state (terminating state) of the basic block with the
// branch, while 'Successor' is the first state of the successor basic block.
// 'condition' is the RTL condition for transitioning from states
// CurBlock->Successor
// For every phi node in the successor basic block, we must assign the phi nodes
// phi_temp register in the 'CurBlock' state
// For instance, if the successor basic block has the phi:
//      %23 = phi i32 [ %37, %legup_memset_4.exit ],
//                    [ 0, %legup_memset_4.exit.preheader ]
// And the state 'CurBlock' is from basic block %legup_memset_4.exit
// Then this function will connect the phi_temp register
// verilogName(%23)_phi_temp to %37 during state 'CurBlock', if 'condition'
// is true (so we are actually transitioning from from CurBlock->Successor)
void GenerateRTL::generatePHICopiesForSuccessor(RTLSignal* condition,
		State *CurBlock, State *Successor) {
	assert(CurBlock);
	assert(Successor);
	if (!CurBlock->isTerminating())
		return;
	if (CurBlock->isWaitingForPipeline() && Successor->isWaitingForPipeline())
		return;

	const BasicBlock *incomingBB = CurBlock->getBasicBlock();
	assert(incomingBB);

	if (Successor->isWaitingForPipeline()) {
		// start the pipeline
		// TODO: this probably should be moved out of this function as it's not
		// really related to phi instructions, just we have access to the
		// 'condition' signal here
		std::string label = getPipelineLabel(Successor->getBasicBlock());
		rtl->find(label + "_pipeline_start")->addCondition(condition, ONE);
	}

	// check for phi nodes in successor
	for (State::const_iterator instr = Successor->begin(), ie =
			Successor->end(); instr != ie; ++instr) {
		Instruction *I = *instr;
		if (const PHINode *phi = dyn_cast<PHINode>(I)) {
			Value *IV = phi->getIncomingValueForBlock(incomingBB);
			RTLWidth width(I, MBW);

			RTLSignal *signal = NULL;
			if (CurBlock->isWaitingForPipeline()) {
				Instruction *IVinst = dyn_cast<Instruction>(IV);
				assert(IVinst);
				this->time = getMetadataInt(IVinst, "legup.pipeline.avail_time");
			}
			signal = getOp(CurBlock, IV);
			RTLSignal *phiWire = rtl->addWire(verilogName(I), width);
			RTLSignal *phiReg = rtl->addReg(verilogName(I) + "_reg", width);
			phiWire->addCondition(condition, signal, I);
			phiReg->addCondition(condition, phiWire, I);
		}
	}
}

RTLSignal *GenerateRTL::getTransitionOp(State *s) {
	RTLSignal *op = s->getTransitionSignal();
	if (op) {
		// ie. finish signal for functions
		return op;
	} else {
		return getOp(s, s->getTransitionVariable());
	}
}

// There are three types of transitions:
// switch, branch, unconditional
void GenerateRTL::generateTransition(RTLSignal *condition, State* s) {
	assert(s->getDefaultTransition());

	RTLSignal *curState = rtl->find("cur_state");

	// uncond
	if (s->getNumTransitions() == 1) {
		generatePHICopiesForSuccessor(condition, s, s->getDefaultTransition());
		curState->addCondition(condition,
				getStateSignal(s->getDefaultTransition()));
		// cond branch
	} else if (s->getNumTransitions() == 2) {

		RTLOp *trueBranch = rtl->addOp(RTLOp::EQ);
		trueBranch->setOperand(0, getTransitionOp(s));
		trueBranch->setOperand(1, ONE);

		RTLOp *trueCond = rtl->addOp(RTLOp::And);
		trueCond->setOperand(0, condition);
		trueCond->setOperand(1, trueBranch);

		generatePHICopiesForSuccessor(trueCond, s, s->getTransitionState(0));
		curState->addCondition(trueCond,
				getStateSignal(s->getTransitionState(0)));

		RTLOp *falseBranch = rtl->addOp(RTLOp::EQ);
		falseBranch->setOperand(0, getTransitionOp(s));
		falseBranch->setOperand(1, ZERO);

		RTLOp *falseCond = rtl->addOp(RTLOp::And);
		falseCond->setOperand(0, condition);
		falseCond->setOperand(1, falseBranch);

		generatePHICopiesForSuccessor(falseCond, s, s->getDefaultTransition());
		curState->addCondition(falseCond,
				getStateSignal(s->getDefaultTransition()));

		// switch
	} else {
		assert(s->getNumTransitions() > 0);

		RTLOp *defaultCond = NULL;

		for (unsigned i = 0, e = s->getNumTransitions() - 1; i != e; ++i) {
			RTLOp *varEq = rtl->addOp(RTLOp::EQ);
			varEq->setOperand(0, getTransitionOp(s));
			varEq->setOperand(1, getOp(s, s->getTransitionValue(i)));

			RTLOp *eqCond = rtl->addOp(RTLOp::And);
			eqCond->setOperand(0, condition);
			eqCond->setOperand(1, varEq);

			generatePHICopiesForSuccessor(eqCond, s, s->getTransitionState(i));
			curState->addCondition(eqCond,
					getStateSignal(s->getTransitionState(i)));

			RTLOp *varNe = rtl->addOp(RTLOp::NE);
			varNe->setOperand(0, getTransitionOp(s));
			varNe->setOperand(1, getOp(s, s->getTransitionValue(i)));

			if (!defaultCond) {
				defaultCond = rtl->addOp(RTLOp::And);
				defaultCond->setOperand(0, condition);
				defaultCond->setOperand(1, varNe);
			} else {
				RTLOp *newCond = rtl->addOp(RTLOp::And);
				newCond->setOperand(0, defaultCond);
				newCond->setOperand(1, varNe);
				defaultCond = newCond;
			}
		}

		// default case
		generatePHICopiesForSuccessor(defaultCond, s,
				s->getDefaultTransition());
		curState->addCondition(defaultCond,
				getStateSignal(s->getDefaultTransition()));

	}
}

void GenerateRTL::generateDatapath() {
	std::string indent = std::string(1, '\t');

	FiniteStateMachine *fsm = sched->getFSM(Fp);
	assert(fsm->getNumStates() > 0);

	RTLSignal *curState = rtl->find("cur_state");

	PropagatingSignals *ps = alloc->getPropagatingSignals();
	bool shouldConnectMemorySignals = usesPthreads
			|| ps->functionUsesMemory(Fp->getName());

	for (FiniteStateMachine::iterator state = fsm->begin(), se = fsm->end();
			state != se; ++state) {

		//const BasicBlock *b = state->getBasicBlock();
		//Out << indent << "/* " << b->getParent()->getName() << ": " <<
		//    b->getName() << "*/\n";

		RTLOp *transition;

		RTLOp *inState = rtl->addOp(RTLOp::EQ);
		inState->setOperand(0, curState);
		inState->setOperand(1, getStateSignal(state));

		if (shouldConnectMemorySignals) {

			RTLOp *waitReqHigh = rtl->addOp(RTLOp::EQ);
			waitReqHigh->setOperand(0,
					rtl->find("memory_controller_waitrequest"));
			waitReqHigh->setOperand(1, ONE);

			RTLOp *waitReqLow = rtl->addOp(RTLOp::EQ);
			waitReqLow->setOperand(0,
					rtl->find("memory_controller_waitrequest"));
			waitReqLow->setOperand(1, ZERO);
			RTLOp *waitReq = rtl->addOp(RTLOp::And);            
			waitReq->setOperand(0, inState);
			waitReq->setOperand(1, waitReqHigh);

			transition = rtl->addOp(RTLOp::And);
			transition->setOperand(0, inState);
			transition->setOperand(1, waitReqLow);
			
            curState->addCondition(waitReq, getStateSignal(state));

		} else {
			transition = inState;
		}
		// print finishing multi-cycle instructions
		for (State::iterator instr = state->begin(), ie = state->end();
				instr != ie; ++instr) {

			Instruction *I = *instr;

			// find the verilog command for this instruction
			this->state = state;

			// call appropriate visitXXXX() function
			visit(*I);

			// declare usage of instruction to Timing/Area estimator
			setOperationUsageFunction(I);
		}

		// generate loop pipeline basic block instructions
		if (state->isWaitingForPipeline()) {
			BasicBlock *BB = state->getBasicBlock();
			assert(BB);
			pipeRTLFile() << "Generating datapath for loop pipeline state: "
					<< state->getName() << "\n";
			this->state = state;
			for (BasicBlock::iterator I = BB->begin(), ie = BB->end(); I != ie;
					++I) {
				this->stage = getMetadataInt(I, "legup.pipeline.stage");
				this->time = getMetadataInt(I, "legup.pipeline.start_time");
				visit(*I);
				setOperationUsageFunction(I);
			}

			generateTransition(transition, state);

			// these member variables shouldn't be used anymore
			this->time = -1;
			this->stage = -1;
		}

		generateTransition(transition, state);

	}
	RTLOp *reset = rtl->addOp(RTLOp::EQ);
	reset->setOperand(0, rtl->find("reset"));
	reset->setOperand(1, ONE);
	curState->addCondition(reset, rtl->addConst("0", curState->getWidth()));
}

void GenerateRTL::generateModuleDeclarationSignals(State *wait,
		std::string postfix) {

	// print memory controller instantiation
	RTLSignal *mem_enable, *addr, *we, *in, *size;
    RTLSignal *mem_enable_wire, *addr_wire, *we_wire, *in_wire, *size_wire;
    RTLWidth wa("`MEMORY_CONTROLLER_ADDR_SIZE-1");
    RTLWidth wd("`MEMORY_CONTROLLER_DATA_SIZE-1");

    RTLWidth ws(2);

    // if this module uses Pthreads, add postfix _arbiter to the ports
    // but add a wire without _arbiter which will be used in the main FSM (same
    // as in without pthreads)
    // postfix _arbiter is needed since the normal memory controller signals
    // (without _arbiter)
    // which are assigned in the FSM are used as request signals to the arbiter
    if (usesPthreads) {
        mem_enable = rtl->find("memory_controller_enable_arbiter" + postfix);
        // rtl->addOut("memory_controller_enable_arbiter" + postfix);
        mem_enable_wire = rtl->addWire("memory_controller_enable" + postfix);
        mem_enable_wire->setDefaultDriver(ZERO);
        connectSignalToDriverInState(mem_enable_wire, ZERO, wait);

        addr = rtl->find("memory_controller_enable_arbiter" + postfix);
        // rtl->addOut("memory_controller_address_arbiter" + postfix, wa);
        addr_wire = rtl->addWire("memory_controller_address" + postfix, wa);
        addr_wire->setDefaultDriver(rtl->addConst("0", wa));
        connectSignalToDriverInState(addr_wire, rtl->addConst("0", wa), wait);

        we = rtl->find("memory_controller_enable_arbiter" + postfix);
        // rtl->addOut("memory_controller_write_enable_arbiter" + postfix);
        we_wire = rtl->addWire("memory_controller_write_enable" + postfix);
        we_wire->setDefaultDriver(ZERO);
        connectSignalToDriverInState(we_wire, ZERO, wait);

        in = rtl->find("memory_controller_enable_arbiter" + postfix);
        // rtl->addOut("memory_controller_in_arbiter" + postfix, wd);
        in_wire = rtl->addWire("memory_controller_in" + postfix, wd);
        in_wire->setDefaultDriver(rtl->addConst("0", wd));
        connectSignalToDriverInState(in_wire, rtl->addConst("0", wd), wait);

        if (alloc->usesGenericRAMs()) {
            size = rtl->find("memory_controller_size_arbiter" + postfix);
            // rtl->addOut("memory_controller_size_arbiter" + postfix, ws);
            size_wire = rtl->addWire("memory_controller_size" + postfix, ws);
            size_wire->setDefaultDriver(rtl->addConst("0", ws));
            connectSignalToDriverInState(size_wire, rtl->addConst("0", ws),
                                         wait);
        }

        // rtl->addIn("memory_controller_out_arbiter" + postfix, wd);
        rtl->addWire("memory_controller_out" + postfix, wd);

        // set default drivers and connect them to each state
        mem_enable->setDefaultDriver(ZERO);
        connectSignalToDriverInState(mem_enable, ZERO, wait);
        addr->setDefaultDriver(ZERO);
        connectSignalToDriverInState(addr, rtl->addConst("0", wa), wait);
        we->setDefaultDriver(ZERO);
        connectSignalToDriverInState(we, ZERO, wait);
        in->setDefaultDriver(ZERO);
        connectSignalToDriverInState(in, rtl->addConst("0", wd), wait);

        if (alloc->usesGenericRAMs()) {
            size->setDefaultDriver(ZERO);
            connectSignalToDriverInState(size, rtl->addConst("0", ws), wait);
        }
    }
}

void GenerateRTL::generateModuleDeclaration() {
    ZERO = rtl->addConst("0");
    ONE = rtl->addConst("1");

    // initialize state signals
    FiniteStateMachine::iterator stateIter = fsm->begin();
    for (; stateIter != fsm->end(); stateIter++) {
        State *s = stateIter;
        // we will fix the name/value later - after generating function calls
		stateSignals[s] = rtl->addParam("state_placeholder", "placeholder");
	}

    // add parameters for tag offset
    // which is used if there are multiple instances of a RAM
    // for pthreads/openmp
    addTagOffsetParameterToModule();

    addDefaultPortsToModule(rtl);

    // width will be set later
	rtl->addReg("cur_state");

	addPropagatingPortsToModule(rtl);

    FiniteStateMachine *fsm = sched->getFSM(Fp);
    State *waitState = fsm->begin();

    const Type *ret = Fp->getReturnType();

    if (ret->getTypeID() != Type::VoidTyID) {
        rtl->addOutReg("return_val", RTLWidth(ret));

        // initialize the return_val to 0 in the wait state
        RTLSignal *ret = rtl->find("return_val");
        connectSignalToDriverInState(ret, rtl->addConst("0", ret->getWidth()),
                                     waitState);
    }

    // function arguments are inputs
    for (Function::arg_iterator i = Fp->arg_begin(), e = Fp->arg_end(); i != e;
         ++i) {
        rtl->addIn(verilogName(i), RTLWidth(i->getType()));
    }

    // TODO:MATHEW
    // should default memory signals to 0
    generateModuleDeclarationSignals(waitState, "_a");
    generateModuleDeclarationSignals(waitState, "_b");
    // if Pthreads are used
    if (usesPthreads) {
        // the waitrequest signal is OR'ed with logic from arbiter
        // memory_controller_waitrequest = memory_controller_waitrequest_arbiter
        // || request is made but not granted by arbiter
        // rtl->addIn("memory_controller_waitrequest_arbiter");
        rtl->addWire("memory_controller_waitrequest");
    }

    // wait state waits until start signal is asserted
    waitState->setTransitionSignal(rtl->find("start"));

    connectSignalToDriverInState(rtl->find("finish"), ZERO, waitState);
}

bool ignoreInstruction(const Instruction *I) {
    // ignore stores (don't need a wire/reg)
    if (I->getType()->getTypeID() == Type::VoidTyID)
        return true;
    // ignore allocations
    if (isa<AllocaInst>(I))
        return true;
    // ignore printf calls
    if (isaDummyCall(I))
        return true;

    return false;
}

// For every instruction create:
//      1) wire named verilogName(I)
//      2) register named verilogName(I) + "_reg"
void GenerateRTL::createRTLSignals() {

    // create signals for each instruction
    createRTLSignalsForInstructions();

    // create signals for local RAMs
   	if (LEGUP_CONFIG->getParameterInt("LOCAL_RAMS")) {
        createRTLSignalsForLocalRams();
    }
}

void GenerateRTL::createRTLSignalsForInstructions() {

    for (inst_iterator i = inst_begin(Fp), e = inst_end(Fp); i != e; ++i) {
        const Instruction *I = &*i;

        if (ignoreInstruction(I))
            continue;

        if (I->hasNUses(0))
            continue; // ignore instructions with no uses

        std::string wire = verilogName(*I);

        std::string reg = wire + "_reg";

        RTLWidth w(I, MBW);
		if (!rtl->exists(wire))
			rtl->addWire(wire, w);
		if (!rtl->exists(reg))
			rtl->addReg(reg, w);
	}
}

void GenerateRTL::createRTLSignalsForLocalRams() {

    for (Allocation::const_ram_iterator i = alloc->ram_begin(), e =
            alloc->ram_end(); i != e; ++i) {

        const char* portNames[2] = { "a", "b" };
        std::vector<std::string> ports(portNames, portNames + 2);
        for (std::vector<std::string>::iterator p = ports.begin(), pe =
                ports.end(); p != pe; ++p) {
            std::string port = *p;

            const RAM *R = *i;
            std::string name = R->getName();
            RTLSignal *s;
            s = rtl->addWire(name + "_address_" + port,
                    RTLWidth(R->getAddrWidth()));
            s->setDefaultDriver(ZERO);
            s = rtl->addWire(name + "_write_enable_" + port);
            s->setDefaultDriver(ZERO);
            s = rtl->addWire(name + "_in_" + port,
                    RTLWidth(R->getDataWidth()));
            s->setDefaultDriver(ZERO);
            rtl->addWire(name + "_out_" + port,
                    RTLWidth(R->getDataWidth()));
        }
    }
}

// this function is used to create memory_controller_storage_port signal
// inside a parallel function, which is used to store the data from memory 
// in the correct cycle (two state after memory read)
// For parallel functions, loads are taken from 
// memory_controller_storage_port signal instead of the regular
// memory_controller_out_port signal
void GenerateRTL::createMemoryReaddataStorageForParallelFunction() {

    // create shift register to indicate when the data is valid
    // the data is valid in the first cycle
    // of the finish state of the load
    // i.e two states after load when memory access latency = 2
    RTLSignal *firstStateAfterMemoryRead = rtl->addReg("first_state_after_memory_read");    
    RTLSignal *secondStateAfterMemoryRead = rtl->addReg("second_state_after_memory_read");
    RTLSignal *wait = rtl->find("memory_controller_waitrequest");

    // invert the waitrequest and register it
    // this gives the signal that is asserted high
    // in the very first cycle of a state
	RTLOp *notWait = rtl->addOp(RTLOp::Not)->setOperands(wait);    
    RTLSignal *notWait_reg = rtl->addReg("memory_controller_waitrequest_inverted_reg");
    notWait_reg->connect(notWait);

    // port A read (but not write)
    RTLSignal *memRead_portA = rtl->addOp(RTLOp::And)->setOperands(
        rtl->find("memory_controller_enable_a"), 
        rtl->addOp(RTLOp::Not)->setOperands(
            rtl->find("memory_controller_write_enable_a")));
    // port B read (but not write)
    RTLSignal *memRead_portB = rtl->addOp(RTLOp::And)->setOperands(
        rtl->find("memory_controller_enable_b"), 
        rtl->addOp(RTLOp::Not)->setOperands(
            rtl->find("memory_controller_write_enable_b")));   

    // when there is a read (port A read or port B read)
    RTLSignal *memRead = rtl->addOp(RTLOp::Or)->setOperands(
        memRead_portA, memRead_portB);

    // make 2 bit-shift register
    // this signal is asserted high
    // in the first state after memory access
    RTLSignal *reset = rtl->find("reset");
	firstStateAfterMemoryRead->addCondition(reset, ZERO);
	firstStateAfterMemoryRead->addCondition(notWait, memRead);        
    // this signal is asserted high
    // in the second state after memory access
	secondStateAfterMemoryRead->addCondition(reset, ZERO);
	secondStateAfterMemoryRead->addCondition(notWait, firstStateAfterMemoryRead);    

    // create a memory readdata valid signal
    // which is asserted in the first cycle of 
    // two states after a memory read
    RTLSignal *memReaddataValid = rtl->addWire("memory_readdata_valid");
    memReaddataValid = rtl->addOp(RTLOp::And)->setOperands(
            secondStateAfterMemoryRead, notWait_reg);

    createMemoryReaddataStorageForPort(memReaddataValid, secondStateAfterMemoryRead, "_a");
    createMemoryReaddataStorageForPort(memReaddataValid, secondStateAfterMemoryRead, "_b");
}


void GenerateRTL::createMemoryReaddataStorageForPort(RTLSignal *memReaddataValid, 
        RTLSignal *secondStateAfterMemoryRead, std::string postfix) {

    RTLSignal *reset = rtl->find("reset");
    // create registers to store memory readdata
    // on memory readdata valid
    RTLSignal *memReaddata_stored = rtl->
        addWire("memory_controller_out_stored_on_datavalid" + postfix,
                RTLWidth("`MEMORY_CONTROLLER_DATA_SIZE-1"));
    RTLSignal *memReaddata_stored_reg = rtl->
        addReg("memory_controller_out_stored_on_datavalid_reg" + postfix,
                RTLWidth("`MEMORY_CONTROLLER_DATA_SIZE-1"));
    RTLSignal *memReaddata = rtl->find("memory_controller_out" + postfix);

    // the logic is
    // memReaddata_stored = 0; (needs to be set to 0 esp. for loop pipelining)
    // if (memReaddataValid)
    //   memReaddata_stored = memReaddata; (actual valid data)
    // if (secondStateAfterMemoryRead)
    //   memReaddata_stored = memReaddata_stored_reg; (needs to retain data if waitrequest is asserted)
    memReaddata_stored->setDefaultDriver(rtl->addConst("0", RTLWidth("`MEMORY_CONTROLLER_DATA_SIZE-1")));
    memReaddata_stored->addCondition(secondStateAfterMemoryRead, memReaddata_stored_reg);
    memReaddata_stored->addCondition(memReaddataValid, memReaddata);

    // registered value created to retain valid data
    memReaddata_stored_reg->addCondition(reset, 
            rtl->addConst("0", RTLWidth("`MEMORY_CONTROLLER_DATA_SIZE-1")));
    memReaddata_stored_reg->addCondition(memReaddataValid, memReaddata);
}


// connect all registers to wires
// the FSM must be finalized before doing this
void GenerateRTL::connectRegistersToWires() {
	for (inst_iterator i = inst_begin(Fp), e = inst_end(Fp); i != e; ++i) {
        Instruction *I = &*i;
        if (ignoreInstruction(I) || isa<PHINode>(I))
            continue;
        if (I->hasNUses(0))
            continue; // ignore instructions with no uses
        std::string wire = verilogName(*I);
        std::string reg = wire + "_reg";

        // errs() << "Adding " << reg << " to state: " <<
        // sched->getFSM(Fp)->getEndState(I)->getName() << "\n";
        connectSignalToDriverInState(rtl->find(reg), rtl->find(wire),
                                     sched->getFSM(Fp)->getEndState(I), I,
                                     OUTPUT_READY);
    }
}

/*
 //this returns true if function F is a Pthread calling wrapper function
 //returns false otherwise
 //pthreadF is stored a pointer to the pthread function
 bool GenerateRTL::isaPthreadCallWrapper(Function *F, Function **pthreadF) {

 for (Function::const_iterator BB = F->begin(), EE = F->end(); BB != EE; ++BB) {
 for (BasicBlock::const_iterator I = BB->begin(), EE = BB->end(); I != EE; ++I) {
 if (const CallInst *CI = dyn_cast<CallInst>(I)) {
 if (getMetadataStr(CI, "TYPE") == "pthread_function") {
 *pthreadF = CI->getCalledFunction();
 return true;
 }
 }
 }
 }
 return false;
 }
 */
// this returns true if function F is a Pthread calling wrapper function
// which should have a return value (pthread function has a returnval)
// returns false otherwise
//
// each pthread calling wrapper with a returnVal has a call to __legup_preserve_value
// which has a metadata set as legup_wrapper_pthreadcall
bool GenerateRTL::isaPthreadCallWrapperWithReturnVal(Function *F) {

	std::string funcName;
	for (Function::const_iterator BB = F->begin(), EE = F->end(); BB != EE;
			++BB) {
		for (BasicBlock::const_iterator I = BB->begin(), EE = BB->end();
				I != EE; ++I) {
			if (const CallInst *CI = dyn_cast<CallInst>(I)) {

				Function *calledFunction = CI->getCalledFunction();
				// ignore indirect function calls
				if (!calledFunction)
					continue;

				funcName = calledFunction->getName();
				if (funcName == "__legup_preserve_value"
						&& getMetadataStr(CI, "TYPE")
								== "dummyCallforPthreadReturnVal") {
					return true;
				}
			}
			/*		    if (const ReturnInst *retInst = dyn_cast<ReturnInst>(I)) {
			 if (getMetadataStr(retInst, "TYPE") == "legup_wrapper_pthreadcall") {
			 return true;
			 }
			 }*/
		}
	}
	return false;
}

//this returns true if function F has a return value
//returns false otherwise
bool GenerateRTL::hasReturnVal(Function *F) {

	if (!(F->getReturnType()->isVoidTy())) {
		return true;
	} else {
		return false;
	}
}

// the FSM used by binding needs to be modified to handle pipelining
// in the default FSM, all the instructions in a pipeline are added
// to one state, the pipeline_wait state. Instead, we would like to
// create a new FSM that includes a states for 0 to II-1 of the pipeline
void GenerateRTL::createBindingFSM() {
	assert(fsm);

	if (!LEGUP_CONFIG->getParameterInt("PIPELINE_RESOURCE_SHARING")) {
		this->bindingFSM = this->fsm;
		return;
	}

	// first clone FSM
	this->bindingFSM = new FiniteStateMachine();
	this->fsm->cloneFSM(this->bindingFSM);

	for (FiniteStateMachine::iterator state = this->bindingFSM->begin();
			state != this->bindingFSM->end(); state++) {
		if (!state->isWaitingForPipeline())
			continue;
		modifyPipelineState(state);
	}

	std::string fileName = "fsm.pipeline." + getLabel(Fp) + ".dot";
	printFSMDotFile(this->bindingFSM, fileName);
}

void GenerateRTL::modifyPipelineState(State *state) {
	assert(state->isWaitingForPipeline());

	// Note: the pipeline wait state has no instructions in it, except for
	// phi nodes.

	// get rid of loop back
	State *nextStateAfterBB = getStateAfterLoop(state);

	BasicBlock *BB = state->getBasicBlock();
	assert(BB);
	state->setName("pipeline_time_0");
	int II = getPipelineII(BB);
	assert(II >= 1);
	std::map<int, State*> newStates;
	newStates[0] = state;
	State *prevState = state;
	for (int time = 1; time < II; time++) {
		std::string name = "pipeline_time_" + utostr(time);
		State *newState = this->bindingFSM->newState(prevState, name);
		newState->setName(name);
		newState->setBasicBlock(BB);
		if (prevState) {
			prevState->setDefaultTransition(newState);
		}
		newStates[time] = newState;
		prevState = newState;
	}
	assert((int )newStates.size() == II);
	int lastTime = II - 1;
	if (lastTime != 0) {

		newStates[lastTime]->setTerminating(true);
		newStates[lastTime]->setDefaultTransition(nextStateAfterBB);

		// clear original wait state
		state->setTerminating(false);
		State::Transition blank;
		state->setTransition(blank);
		state->setDefaultTransition(newStates[1]);
		assert(state->getNumTransitions() == 1);

	}

	for (BasicBlock::iterator I = BB->begin(), ie = BB->end(); I != ie; ++I) {

		int startTime = getMetadataInt(I, "legup.pipeline.start_time");
		int timeAvail = getMetadataInt(I, "legup.pipeline.avail_time");

		startTime = startTime % II;
		timeAvail = startTime % II;

		// how do i handle arrival times / LVA for pipelining?
		newStates[startTime]->push_back(I);
		this->bindingFSM->setEndState(I, newStates[timeAvail]);
	}

}

void delete_multicycle_files() {
	static bool first_visit = true;
	if (!first_visit) {
		return;
	}

	std::vector<std::string> file_list;
	file_list.push_back("llvm_prof_multicycle_constraints.sdc");
	file_list.push_back("llvm_prof_multicycle_constraints.qsf");
	file_list.push_back("src_dst_pairs_with_through_constraints.txt");
	file_list.push_back("pairs_whose_through_constraints_must_be_removed.txt");
	for (std::vector<std::string>::const_iterator it = file_list.begin();
			it != file_list.end(); ++it) {
		std::ofstream file;
		file.open(it->c_str());
		file << std::endl;
	}

	first_visit = false;
}

RTLModule* GenerateRTL::generateRTL(MinimizeBitwidth *_MBW) {

	EXPLICIT_LPM_MULTS = LEGUP_CONFIG->getParameterInt("EXPLICIT_LPM_MULTS");
	MULTIPUMPING = LEGUP_CONFIG->getParameterInt("MULTIPUMPING");
	USE_MB = LEGUP_CONFIG->getParameterInt("MB_MINIMIZE_HW");

	MBW = _MBW;

	assert(!rtl);
	rtl = new RTLModule(Fp->getName());

	// check if this function uses Pthreads
	usesPthreads = checkforPthreads(Fp);
	// add to phreadfunctions
	if (usesPthreads)
		LEGUP_CONFIG->addPthreadFunction(Fp->getName());

	generateModuleDeclaration();

	createRTLSignals();

	// function calls are a special case because they can modify the
	// finite state machine. Do these first:
	generateAllCallInsts();

	// loop pipelines (which also modifies fsm)
	generateAllLoopPipelines();

	updateStatesAfterCallInsts();

	printFSMDot();

	connectRegistersToWires();

	binding = new BipartiteWeightedMatchingBinding(alloc, bindingFSM, Fp,
			this->MBW);
	// Patterns is used for binding graphs
	PatternMap * Patterns = new PatternMap(fsm);
	// InstructionsInGraphs is a set of all instructions in graphs, used in
	// visitInstruction
	this->InstructionsInGraphs.clear();
	this->GraphPairs.clear();
	this->binding->operatorAssignment();
	for (Binding::iterator i = this->binding->begin(), ie =
			this->binding->end(); i != ie; ++i) {
		Instruction *instr = i->first;
		std::string fuId = i->second;
		instructionsAssignedToFU[fuId].insert(instr);
	}

	PatternBinding *patterns = new PatternBinding(alloc, fsm, Fp, this->MBW);
	patterns->PatternAnalysis(*Patterns, this->AllBindingPairs,
			this->GraphPairs, this->InstructionsInGraphs);
	createBindingSignals();
	if (MULTIPUMPING) {
		createMultipumpSignals();
	}

    // for parallel functions
    // create a register to store the data from memory
    // in the correct cycle
    bool isParallelFunction = Fp->hasFnAttribute("totalNumThreads");
    if (isParallelFunction) {
        createMemoryReaddataStorageForParallelFunction();
    }

	generateDatapath();
	updateRTLWithPatterns();
	shareRegistersFromBinding();
	delete Patterns;
	Patterns = NULL;

	printSchedulingInfo();

	// Delete/clear multi-cycle files from previous builds
	delete_multicycle_files();
	printSDCMultiCycleConstraints();

	printScheduleGanttChart();

	// must be run after the above because the FSM can be modified by
    // modifyFSMForLoopPipeline()
    timingAnalysis(dag);

    std::string functionType;
    std::set<CallInst *> pthreadFunctions;
    // Module instances
    for (Function::iterator b = Fp->begin(), be = Fp->end(); b != be; ++b) {
        for (BasicBlock::iterator instr = b->begin(), ie = b->end();
             instr != ie; ++instr) {

            if (isaDummyCall(instr))
                continue;

            if (CallInst *CI = dyn_cast<CallInst>(instr)) {
                functionType = getMetadataStr(CI, "TYPE");

                // don't generate instances for pthread poll wrapper
                if (functionType != "legup_wrapper_pthreadpoll") {
                    // push pthread functions into vector
                    // to be used for creating arbiter
                    if (getMetadataStr(CI, "TYPE") ==
                        "legup_wrapper_pthreadcall")
                        pthreadFunctions.insert(CI);
                    // instantiate module
                    generateVariableDeclarations(CI, functionType);
                }
            }
        }
    }

    // create arbiter for pthreads
    if (!pthreadFunctions.empty()) {
        generatePthreadArbiter(pthreadFunctions);
        generatePthreadMasterThreadLogic();
    }

	// debugging: display cur_state each cycle
	if (LEGUP_CONFIG->getParameterInt("PRINT_STATES")) {
		std::string old_body = rtl->getBody();
		raw_string_ostream body(old_body);
		body << "always @(posedge clk)" << "\n";
		body << "\t$display(\"Cycle: %d Time: %d " << Fp->getName()
				<< " cur_state: %d\", ($time-50)/20, $time, cur_state);\n";
		rtl->setBody(body.str());
	}

	// add local rams
	for (std::map<RAM*, Function*>::iterator i =
			alloc->isLocalFunctionRam.begin(), e =
			alloc->isLocalFunctionRam.end(); i != e; ++i) {
		RAM *r = i->first;
		Function *f = i->second;
		if (Fp == f) {
			// RAM is local to this function
			assert(rtl->localRamList.find(r) == rtl->localRamList.end());
			rtl->localRamList.insert(r);
		}
	}

	return rtl;
}

// Get the number of succcessors that are in the same state
int GenerateRTL::getNumSuccInState(Instruction *I, FiniteStateMachine *fsm) {
	State *currS = fsm->getStartState(I);
	int numSuccInState = 0;
	for (Value::user_iterator i = I->user_begin(), e = I->user_end(); i != e;
			++i) {
		Instruction *successor = dyn_cast<Instruction>(*i);
		if (!successor)
			continue;
		State *succS = fsm->getStartState(successor);
		if (succS == currS)
			numSuccInState++;
	}
	return numSuccInState;
}

// Check if an instruction is the start of a path
bool GenerateRTL::isStartOfPath(SchedulerDAG *dag, Instruction *I,
		FiniteStateMachine *fsm) {
	State *beginS = fsm->getStartState(I);
	InstructionNode *IN = dag->getInstructionNode(I);
	int numPreInState = 0;
	int numAllPre = 0;
	for (InstructionNode::iterator i = IN->dep_begin(), e = IN->dep_end();
			i != e; ++i) {
		// dependency from dep -> IN
		Instruction *dep = (*i)->getInst();
		State *endS = fsm->getStartState(dep);
		numAllPre++;
		if (endS == beginS)
			numPreInState++;
	}
	int numPreOutOfState = numAllPre - numPreInState;

	// An instruction is the start of a path in two cases
	// either it doesn't has any predecessor in the same state or it has some predecessor out of the state
	if (numPreInState == 0 || numPreOutOfState != 0)
		return true;
	else
		return false;
}

// calculate the delay of all paths starting from the beginning of a state and ending with Instruction *Root
// Store the paths in func_path
// gets called for every root instruction
void GenerateRTL::calculateDelay(SchedulerDAG *dag, Instruction *Curr,
		float partialDelay, State *rootState, FiniteStateMachine *fsm,
		std::list<GenerateRTL::PATH*> *func_path,
		std::vector<Instruction *> instrs, std::vector<float> instrDelays) {
	int ifNotIgnoreGetelementptrAndStore = LEGUP_CONFIG->getParameterInt(
			"TIMING_NO_IGNORE_GETELEMENTPTR_AND_STORE");
	InstructionNode *CurrNode = dag->getInstructionNode(Curr);
	float dl;
	// Ignore getelementptr and store instructions
	if (ifNotIgnoreGetelementptrAndStore == 0)
		if (isa<GetElementPtrInst>(Curr) || isa<StoreInst>(*Curr))
			return;
	dl = partialDelay + CurrNode->getDelay();

	// Add the instruction into the Path
	instrs.push_back(Curr);
	instrDelays.push_back(CurrNode->getDelay());

	// Walk through the dependencies
	for (InstructionNode::iterator i = CurrNode->dep_begin(), e =
			CurrNode->dep_end(); i != e; ++i) {
		// dependency from dep -> CurrNode
		Instruction *dep = (*i)->getInst();
		State *currState = fsm->getStartState(dep);
		// recursive call to discover other instructions if dep is in the same state
		if (currState == rootState)
			calculateDelay(dag, dep, dl, rootState, fsm, func_path, instrs,
					instrDelays);
	}

	bool ifAddToPath = isStartOfPath(dag, Curr, fsm);
	// Add the path into the list if current node is the start of the path
	if (ifAddToPath) {
		PATH *temp;
		temp = new PATH;
		temp->pathDelay = dl;
		temp->state = rootState;
		temp->instructions = instrs;
		temp->instrDelay = instrDelays;
		temp->func = Fp;
		func_path->push_back(temp);
	}
}

// Print out the n longest paths
void GenerateRTL::printPath(raw_ostream &report, list<PATH*> *path) {
	int num_paths = LEGUP_CONFIG->getParameterInt("TIMING_NUM_PATHS");
	int pathNum = 0;
	for (std::list<GenerateRTL::PATH*>::iterator i = path->begin(), e =
			path->end(); i != e; ++i) {
		pathNum++;
		if (pathNum > num_paths)
			break;
		PATH *curr = *i;
		report << "-----------------Function: " << curr->func->getName()
				<< "---------------\n";
		report << "-------------------------" << pathNum
				<< "---------------------------\n";
		report << "-----------------Delay of path:" << ftostr(curr->pathDelay)
				<< " ns---------------\n";
		report << "-----------------State:" << curr->state->getName()
				<< "-----------------\n";
		float partialDelay = 0;
		int instrNum = curr->instrDelay.size();
		for (std::vector<Instruction *>::reverse_iterator i =
				curr->instructions.rbegin(), e = curr->instructions.rend();
				i != e; ++i) {
			instrNum--;
			Instruction *currInstr = *i;
			float currDelay = curr->instrDelay[instrNum];
			partialDelay += currDelay;
			report << "(" << ftostr(currDelay) << " ns) --- ("
					<< ftostr(partialDelay) << " ns) --- " << *currInstr
					<< "\n";
		}
		report << "\n";
	}
	report << "\n";
}

void GenerateRTL::addToOverallPathList() {
	int num_paths = LEGUP_CONFIG->getParameterInt("TIMING_NUM_PATHS");
	list<GenerateRTL::PATH*> *pathList = alloc->getOverallLongestPaths();
	int pathNum = 0;
	for (std::list<GenerateRTL::PATH*>::iterator i = func_path.begin(), e =
			func_path.end(); i != e; ++i) {
		pathNum++;
		// In worst case, the overall n longest paths are all from the same function
		if (pathNum > num_paths)
			break;
		pathList->push_front(*i);
	}
	pathList->sort(pathComp);
}

// Calculates the n longest paths and stores in func_path
// Gets called once for each function
void GenerateRTL::timingAnalysis(SchedulerDAG *dag) {
	vector<Instruction *> instrs;
	vector<float> instrDelay;
	for (FiniteStateMachine::iterator state = fsm->begin(), se = fsm->end();
			state != se; ++state) {
		for (State::iterator instr = state->begin(), ie = state->end();
				instr != ie; ++instr) {
			Instruction *I = *instr;
			State *rootState = fsm->getStartState(I);
			int numSuccInState = getNumSuccInState(I, fsm);
			if (!numSuccInState)
				calculateDelay(dag, I, 0, rootState, fsm, &func_path, instrs,
						instrDelay);
		}
	}
	formatted_raw_ostream report(alloc->getTimingReportFile());
	func_path.sort(pathComp);
	printPath(report, &func_path);
	addToOverallPathList();
}

// print out the data flow graph for each basic block
void GenerateRTL::printSchedulingDFGDot(SchedulerDAG &dag) {
	for (Function::iterator bb = Fp->begin(), be = Fp->end(); bb != be; ++bb) {
		std::string FileError;
		std::string fileName = "dfg." + getLabel(Fp) + "_" + getLabel(bb)
				+ ".dot";
          raw_fd_ostream dfgFile(fileName.c_str(), FileError, llvm::sys::fs::F_None);
		assert(FileError.empty() && "Error opening dot files");
		formatted_raw_ostream out(dfgFile);
		dag.printDFGDot(out, bb);
	}
}

void GenerateRTL::printSchedulingInfo() {
	formatted_raw_ostream out(alloc->getSchedulingFile());

	out << "Target Family: " << LEGUP_CONFIG->getDeviceFamily() << "\n";
	out << "Clock period constraint: " << sched->getClockPeriodConstraint()
			<< "ns\n";

	std::map<BasicBlock*, unsigned> bbCount;
	out << "Start Function: " << Fp->getName() << "\n";
	//std::ofstream out("scheduling.legup.rpt", std::ios::app);
	for (FiniteStateMachine::iterator state = fsm->begin(), se = fsm->end();
			state != se; ++state) {
		out << "state: " << state->getName() << "\n";
		BasicBlock *bb = state->getBasicBlock();
		bbCount[bb]++;
		for (State::iterator instr = state->begin(), ie = state->end();
				instr != ie; ++instr) {
			Instruction *I = *instr;
			if (bb && I == bb->getTerminator())
				continue;
			assert(fsm->getStartState(I) == state);
			out << " " << getValueStr(I) << " (endState: "
					<< fsm->getEndState(I)->getName() << ")\n";
		}
		// print out branch:
		if (bb && state->isTerminating()) {
			out << " " << getValueStr(bb->getTerminator()) << "\n";
		}
		out << "   ";
		state->printTransition(out);
		out << "\n";
	}
	out << "\n";
	for (std::map<BasicBlock*, unsigned>::iterator i = bbCount.begin(), e =
			bbCount.end(); i != e; ++i) {
		BasicBlock *bb = i->first;
		if (!bb)
			continue;
		unsigned count = i->second;
		out << "Basic Block: " << getLabel(bb) << " Num States: " << count
				<< "\n";
	}
	out << "End Function: " << Fp->getName() << "\n";
	out
			<< "--------------------------------------------------------------------------------\n\n";
}

void GenerateRTL::printScheduleGanttChart() {
    std::string Filename = "gantt." + Fp->getName().str() + ".tex";
	//errs() << "Writing '" << Filename << "'...";

	std::string ErrorInfo;
    raw_fd_ostream file(Filename.c_str(), ErrorInfo, llvm::sys::fs::F_None);
	if (!ErrorInfo.empty()) {
		errs() << "Error opening file: " << Filename << " for writing!\n";
		assert(0);
	}

	file << "\\documentclass[landscape]{article}\n";
	//file << "\\usepackage{fullpage}\n";
	file << "\\usepackage{gantt}\n";
	file << "\\pagestyle{empty}\n";
	file << "\\begin{document}\n";
	//file << "\\setlength{\\pdfpagewidth}{100in}\n";
	//file << "\\setlength{\\pdfpageheight}{200in}\n";
	//file << "Function: " << verilogName(Fp) << "\n";

	std::vector<GanttBar> gantt;
	std::map<Instruction *, GanttBar> instructions;

	FiniteStateMachine *fsm = sched->getFSM(Fp);

	int instNum = 1;
	int stateNum = 1;
	for (FiniteStateMachine::iterator state = ++fsm->begin(), se = fsm->end();
			state != se; ++state) {
		for (State::iterator instr = state->begin(), ie = state->end();
				instr != ie; ++instr) {
			GanttBar bar;
			bar.inst = *instr;
			bar.x = stateNum;
			bar.y = instNum;
			bar.duration = Scheduler::getNumInstructionCycles(bar.inst);
			if (bar.duration == 0) {
				bar.duration = 1;
			}
			gantt.push_back(bar);
			instructions[*instr] = bar;
			//errs() << *bar.inst << "\n";
			instNum++;
		}
		stateNum++;
		if (state->isTerminating() && !gantt.empty()) {
			printGantt(file, gantt, instructions, stateNum);
			instNum = 1;
			stateNum = 1;
			gantt.clear();
			instructions.clear();
		}
	}

	file << "\\end{document}\n";
}

void GenerateRTL::printGantt(raw_fd_ostream &file, std::vector<GanttBar> &gantt,
		std::map<Instruction *, GanttBar> &instructions, int stateNum) {

	unsigned rows = gantt.size() + 1;
	unsigned cols = stateNum;
	unsigned start = 0;
	unsigned increment = 1;
	unsigned span = 1;
	unsigned end = cols - 1;

	file << "\\begin{figure}\n";
	file << "\\begin{gantt}[fontsize=\\scriptsize]{" << rows << "}{" << cols
			<< "}\n";
	file << "\\begin{ganttitle}\n";
	file << "\\numtitle{" << start << "}{" << increment << "}{" << end << "}{"
			<< span << "}\n";
	file << "\\end{ganttitle}\n";

	//errs() << "gantt: " << gantt.size() << "\n";
	for (std::vector<GanttBar>::iterator bar = gantt.begin(), bare =
			gantt.end(); bar != bare; ++bar) {
		std::string stripped;
		raw_string_ostream stream(stripped);
		Instruction *I = bar->inst;
		stream << *I;
		replaceAll(stripped, "%", "\\%");
		replaceAll(stripped, "_", "\\_");
		// limit the size of the instruction string
		unsigned limit = 80;
		if (stripped.length() > limit) {
			stripped.erase(limit);
			stripped = stripped + "...";
		}

		file << "\\ganttbar{" << stripped << "}{" << bar->x << "}{"
				<< bar->duration << "}\n";

		for (Value::user_iterator i = I->user_begin(), e = I->user_end(); i != e;
				++i) {
			Instruction *use = dyn_cast<Instruction>(*i);
			if (!use)
				continue;
			//assert(instructions.find(use) != instructions.end());
			if (instructions.find(use) == instructions.end())
				continue;
			GanttBar useGantt = instructions[use];
			file << "\\ganttcon{" << bar->x + bar->duration << "}{" << bar->y
					<< "}{" << useGantt.x << "}{" << useGantt.y << "}\n";
		}
	}

	/*
	 \ganttbar{\%i.04 = phi i32 [ 0, \%bb.nph ], [ \%3, \%bb ]}{1}{0}
	 \ganttbarcon{\%scevgep5 = getelementptr \%b, \%i.04}{1}{1}
	 \ganttbarcon{\%0 = load \%scevgep5}{2}{2}
	 \ganttbar{\%scevgep6 = getelementptr \%c, \%i.04}{1}{1}
	 \ganttbarcon{\%1 = load \%scevgep6}{3}{2}
	 \ganttbarcon{\%2 = add nsw i32 \%1, \%0}{5}{1}
	 \ganttbar{\%scevgep = getelementptr \%a, \%i.04}{1}{1}
	 \ganttbarcon{store \%2, \%scevgep}{6}{1}
	 \ganttcon{1}{1}{1}{7}
	 \ganttcon{1}{1}{1}{4}
	 \ganttcon{4}{3}{5}{6}
	 % x, y x, y
	 \ganttcon{6}{6}{6}{8}
	 \ganttbar{\%3 = add \%i.04, 1}{1}{1}
	 \ganttcon{1}{1}{1}{9}
	 \ganttbarcon{\%exitcond = eq \%3, 100}{2}{1}
	 \ganttbarcon{br \%exitcond, \%bb2, \%bb}{7}{0}
	 */
	file << "\\end{gantt}\n";
	assert(!gantt.empty());
	//file << "\\caption{" << "Function: " << verilogName(Fp) << " "
	//<< *gantt[0].inst->getParent() << "}\n";

	file << "\\end{figure}\n";

}

void GenerateRTL::scheduleOperations() {
    dag = new SchedulerDAG;
    dag->runOnFunction(*Fp, alloc);

    if (!LEGUP_CONFIG->getParameterInt("NO_DFG_DOT_FILES")) {
        printSchedulingDFGDot(*dag);
    }

    sched = new SDCScheduler(alloc);

    sched->schedule(Fp, dag);
    fsm = sched->getFSM(Fp);

    modifyFSMForAllLoopPipelines();

	// Warning: the FSM at this point is missing a few TransitionVariables.
	// these will be added later when we have access to the RTLModule
    createBindingFSM();
}

void GenerateRTL::addTagOffsetParameterToModule() {

    RTLSignal *tag_offset = rtl->addParam("tag_offset", "0");
    tag_offset->setWidth(RTLWidth(utostr(alloc->getTagSize() - 1)));
    std::string bottomBits =
        utostr((int)alloc->getDataLayout()->getPointerSizeInBits() -
               alloc->getTagSize()) +
        "'d0";
    std::string tag_addr_offset_value = "{tag_offset, " + bottomBits + "}";
    RTLSignal *tag_addr_offset =
        rtl->addParam("tag_addr_offset", tag_addr_offset_value);
    tag_addr_offset->setWidth(RTLWidth("`MEMORY_CONTROLLER_ADDR_SIZE-1"));
}

void GenerateRTL::addDebugRtl() {
    RTLSignal *sigCurState;
    RTLSignal *sigActiveInst;

    //    outs() << "Adding debug instrumentation to " << Fp->getName().str() <<
    //    "\n";

    fsm->buildStatePredecessors();

    // Add output for the instance Id
    sigActiveInst = rtl->addOut(DEBUG_SIGNAL_NAME_ACTIVE_INST,
                                alloc->getDbgInfo()->getInstanceIdBits());

    // Add output for the current state (in encoded, or one-hot)
    if (alloc->getDbgInfo()->getOptionPreserveOneHot()) {
        string sigCurStateName = DEBUG_SIGNAL_NAME_CURRENT_STATE;
        sigCurState = rtl->addWire(sigCurStateName, fsm->size());
    } else {
        string sigCurStateName = DEBUG_SIGNAL_NAME_CURRENT_STATE;
        sigCurState =
            rtl->addOut(sigCurStateName, alloc->getDbgInfo()->getStateBits());
    }

    // Add Parent Instance Parameter
    RTLSignal *parentInstanceParam =
        rtl->addParam(DEBUG_PARAM_NAME_PARENT_INST, "0");
    parentInstanceParam->setWidth(alloc->getDbgInfo()->getInstanceIdBits());

    // Add Instance Parameter
    string instanceParamVal = DEBUG_VERILOG_FUNC_NAME_INSTANCE_MAPPING;
    instanceParamVal += "(";
	instanceParamVal +=	DEBUG_PARAM_NAME_PARENT_INST;
    instanceParamVal += ")";

    RTLSignal *instanceParam =
        rtl->addParam(DEBUG_PARAM_NAME_INST, instanceParamVal);
    instanceParam->setWidth(alloc->getDbgInfo()->getInstanceIdBits());

    // Create logic to drive the current state output.
    // For one-hot encoding, each bit of the output will be driven by some logic
    // (state == XXX)
    // For fully encoded, the output will be driven by a series of statements
    // such as: if (state == S_XXX) then out = 1
    vector<RTLSignal *> statesOneHot;
    int stateCount = 0;
    for (FiniteStateMachine::iterator state = fsm->begin(),
                                      state_end = fsm->end();
         state != state_end; ++state) {

        Function *calledFunc = state->getCalledFunction();
        if (calledFunc) {
            //		    outs() << "Called function: " <<
            //calledFunc->getName().str() << "\n";

            // The debugger outputs the active instance/state to the top-level
            // The instance/state wires need to be driven by the child module
            // during
            // a function call.
            string calledFuncName = verilogName(calledFunc);

            string dbgActiveInstanceSigName =
                calledFuncName + "_" + DEBUG_SIGNAL_NAME_ACTIVE_INST;
            string dbgCurrentStateSigName =
                calledFuncName + "_" + DEBUG_SIGNAL_NAME_CURRENT_STATE;

            RTLSignal *sigActiveInstChild = rtl->addWire(
                dbgActiveInstanceSigName,
                RTLWidth(alloc->getDbgInfo()->getInstanceIdBits()));
            connectSignalToDriverInState(sigActiveInst, sigActiveInstChild,
                                         state);

            if (!alloc->getDbgInfo()->getOptionPreserveOneHot()) {
                RTLSignal *sigCurStateChild =
                    rtl->addWire(dbgCurrentStateSigName,
                                 RTLWidth(alloc->getDbgInfo()->getStateBits()));
                connectSignalToDriverInState(sigCurState, sigCurStateChild,
                                             state);
            }

        } else {
            // For every state (except function calls), the state number
            // needs to be connected to a wire, which goes out to the
            // debugger
            if (!alloc->getDbgInfo()->getOptionPreserveOneHot()) {
                RTLConst *constVal = new RTLConst(
                    getStateSignal(state)->getValue(), sigCurState->getWidth());
                connectSignalToDriverInState(sigCurState, constVal, state);
            }
        }

        if (alloc->getDbgInfo()->getOptionPreserveOneHot()) {
            string tempStateName = "stateOneHot";
            tempStateName += std::to_string(stateCount);
            RTLSignal *tempState = rtl->addWire(tempStateName, RTLWidth(1));
            statesOneHot.push_back(tempState);

            if (LEGUP_CONFIG->getParameterInt("CASEX")) {

                RTLOp *op = rtl->addOp(RTLOp::Trunc);
                string stateStr = std::to_string(stateCount);
                op->setCastWidth(RTLWidth(stateStr, stateStr));
                op->setOperand(0, rtl->find("cur_state"));

                tempState->connect(op, NULL);
            } else {

                tempState->setDefaultDriver(ZERO);
                connectSignalToDriverInState(tempState, ONE, state);
            }
        }

        stateCount += 1;
    }

    if (alloc->getDbgInfo()->getOptionPreserveOneHot()) {
        RTLSignal *concated = NULL;
        for (vector<RTLSignal *>::iterator s_it = statesOneHot.begin(),
                                           s_end = statesOneHot.end();
             s_it != s_end; ++s_it) {

            if (!concated) {
                concated = *s_it;
            } else {
                RTLOp *concat = rtl->addOp(RTLOp::Concat);
                concat->setOperand(0, *s_it);
                concat->setOperand(1, concated);
                concated = concat;
            }
        }
        sigCurState->connect(concated);

        string statePortName = Fp->getName().str() + DEBUG_HIERARCHY_PATH_SEP +
                               sigCurState->getName();
        RTLSignal *sigCurStatePort =
            rtl->addOut(statePortName, sigCurState->getWidth());
        sigCurStatePort->connect(sigCurState, NULL);
        dbgStatePorts.push_back(
            new RTLDebugPort(sigCurStatePort, this, sigCurState));
    }

    // Forward registers that need to be traced to top-level ports
    if (alloc->getDbgInfo()->getOptionTraceRegs())
        addDebugTraceOutputs();

    for (std::map<Function *, RTLModule *>::iterator
             child_it = calledModulesToRtlMap.begin(),
             child_end = calledModulesToRtlMap.end();
         child_it != child_end; ++child_it) {
        Function *childFp = child_it->first;
        GenerateRTL *childGenRtl = alloc->getGenerateRTL(childFp);
        RTLModule *childRtl = child_it->second;

        // Adds top-level outputs for the signals in the
        // instantiated child modules that need to be traced
        if (alloc->getDbgInfo()->getOptionTraceRegs()) {
            vector<RTLDebugPort *> *childPorts = &(childGenRtl->dbgTracePorts);

            // Connect up each signal
            for (vector<RTLDebugPort *>::iterator port_it = childPorts->begin(),
                                                  port_end = childPorts->end();
                 port_it != port_end; ++port_it) {
                RTLDebugPort *port = *port_it;
                RTLSignal *signal = port->getSignal();

                RTLSignal *newOut =
                    rtl->addOut(Fp->getName().str() + DEBUG_HIERARCHY_PATH_SEP +
                                    signal->getName(),
                                signal->getWidth());
                childRtl->addOut(signal->getName(), signal->getWidth())
                    ->connect(newOut);

                dbgTracePorts.push_back(new RTLDebugPort(port, newOut));
            }
        }

        if (alloc->getDbgInfo()->getOptionPreserveOneHot()) {
            // Adds top-level outputs for the state signals in the instantiated
            // child modules
            vector<RTLDebugPort *> *childPorts = &(childGenRtl->dbgStatePorts);

            // Connect up each signal
            for (vector<RTLDebugPort *>::iterator port_it = childPorts->begin(),
                                                  port_end = childPorts->end();
                 port_it != port_end; ++port_it) {
                RTLDebugPort *port = *port_it;
                RTLSignal *signal = port->getSignal();

                RTLSignal *newOut =
                    rtl->addOut(Fp->getName().str() + DEBUG_HIERARCHY_PATH_SEP +
                                    signal->getName(),
                                signal->getWidth());
                childRtl->addOut(signal->getName(), signal->getWidth())
                    ->connect(newOut);

                dbgStatePorts.push_back(new RTLDebugPort(port, newOut));
            }
        }

        childRtl->addParam(DEBUG_PARAM_NAME_PARENT_INST, DEBUG_PARAM_NAME_INST);

        string activeInstanceSigName =
            verilogName(childFp) + "_" + DEBUG_SIGNAL_NAME_ACTIVE_INST;
        RTLSignal *activeInstanceSig = rtl->find(activeInstanceSigName);
        childRtl->addOut(DEBUG_SIGNAL_NAME_ACTIVE_INST)
            ->connect(activeInstanceSig);

        if (!alloc->getDbgInfo()->getOptionPreserveOneHot()) {
            string currentStateSigName =
                verilogName(childFp) + "_" + DEBUG_SIGNAL_NAME_CURRENT_STATE;
            RTLSignal *currentStateSig = rtl->find(currentStateSigName);
            childRtl->addOut(DEBUG_SIGNAL_NAME_CURRENT_STATE)
                ->connect(currentStateSig);
        }
    }

    // By default, drive the active instance by the instance parameter
    sigActiveInst->setDefaultDriver(instanceParam);

    // If reset, active instance should be 0
    RTLOp *cond;
    cond = rtl->addOp(RTLOp::EQ);
    cond->setOperand(0, rtl->find("reset"));
    cond->setOperand(1, ONE);

    sigActiveInst->addCondition(
        cond, new RTLConst("0", sigActiveInst->getWidth()), NULL);
}

// Find all registers that need to be traced from within this module
// and output them to top-level ports
void GenerateRTL::addDebugTraceOutputs() {
    set<RTLSignal *> sigTraced;

    // Find all registers that need to be traced from this module
    for (vector<DebugVariableLocal *>::iterator var_iter = dbgVars.begin(),
                                                var_end = dbgVars.end();
         var_iter != var_end; ++var_iter) {
        DebugVariableLocal *var = *var_iter;

        for (vector<DebugValue *>::iterator
                 dv_it = var->getDbgValues()->begin(),
                 dv_end = var->getDbgValues()->end();
             dv_it != dv_end; ++dv_it) {
            DebugValue *val = *dv_it;

            RTLSignal *sigToTrace = NULL;

            if (val->requiresSignalTracing()) {
                sigToTrace = rtl->find(val->getSignalName());
                assert(sigToTrace);

                if (sigTraced.find(sigToTrace) == sigTraced.end())
                    sigTraced.insert(sigToTrace);
                else
                    continue;

                string traceName = Fp->getName().str() +
                                   DEBUG_HIERARCHY_PATH_SEP +
                                   sigToTrace->getName();
                RTLSignal *s = rtl->addOut(traceName, sigToTrace->getWidth());
                s->connect(sigToTrace, NULL);

                RTLDebugPort *newDbgPort =
                    new RTLDebugPort(s, this, sigToTrace);

                dbgTracePorts.push_back(newDbgPort);
            }
        }
    }
}

// This recursive function creates a unique ID for each *instance* of each
// module.
// The same GenerateRTL module can be instantiated from multiple parent
// modules, and each parent could be instantiated from different parents, and so
// forth,
// So, this function registers an instanceId with the debugging info for this
// GenerateRTL module, given its parent instance ID.
void GenerateRTL::generateInstances(int parentInstanceId) {
    RTLModuleInstance *myInst =
        alloc->getDbgInfo()->newInstance(this, parentInstanceId);

    instances.push_back(myInst);
    rtl->dbgAddInstanceMapping(parentInstanceId, myInst->getId());

    for (set<Function *>::iterator fp_it = calledModules.begin(),
                                   fp_end = calledModules.end();
         fp_it != fp_end; ++fp_it) {
        Function *childFp = *fp_it;
        GenerateRTL *childGenRtl = alloc->getGenerateRTL(childFp);
        childGenRtl->generateInstances(myInst->getId());
    }
}

// This function returns the Debugging info class for a variable,
// specified by the MDNode.
DebugVariableLocal *GenerateRTL::dbgGetVariable(MDNode *metaNode) {
    // Check if this variable has already been allocated
    for (auto var_it = dbgVars.begin(), e = dbgVars.end(); var_it != e;
         ++var_it) {
        if ((*var_it)->getMetaNode() == metaNode)
            return *var_it;
    }

    // If the variable is not already added, allocate a new one
    DebugVariableLocal *v = new DebugVariableLocal(metaNode, this);
    dbgVars.push_back(v);
    return v;
}

GenerateRTL::~GenerateRTL() {
    assert(sched);
	assert(sched->getFSM(Fp));
	delete sched->getFSM(Fp);
	delete sched;
	assert(rtl);
	delete rtl;
	assert(binding);
	delete binding;
	assert(dag);
	delete dag;
}

} // End legup namespace
