//===-- LegupConfig.h - Legup Configuration ---------------------*- C++ -*-===//
//
// This file is distributed under the LegUp license. See LICENSE for details.
//
//===----------------------------------------------------------------------===//
//
// This file declares the Legup configuration object
//
//===----------------------------------------------------------------------===//

#ifndef LEGUP_CONFIG_H
#define LEGUP_CONFIG_H

#include "llvm/IR/Function.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/Instructions.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/ADT/StringExtras.h"

#include <string>
#include <set>
#include <map>
using namespace llvm;

namespace legup {

class LegupConfig;
class Allocation;

typedef struct CustomVerilogIO {
  int bitFrom;
  int bitTo;
  bool isInput;
  std::string name;
} CustomVerilogIO;

class CustomVerilogFunction {
public:
  CustomVerilogFunction(){};
  CustomVerilogFunction(std::string _name) {
    name = _name;
    _usesMemory = false;
  };
  CustomVerilogFunction(std::string _name, bool usesMemory) {
    name = _name;
    _usesMemory = usesMemory;
  };

  bool addIO(std::string _name, std::string _iowidth, std::string _kind);
  bool operator==(std::string _name) { return (name == _name); };

  bool operator<(const CustomVerilogFunction &rhs) const {
    return name < rhs.name;
  };

  std::vector<CustomVerilogIO> getIO() { return io; };

  bool usesMemory() const { return _usesMemory; }

private:
  std::string name;
  bool _usesMemory;
  std::vector<CustomVerilogIO> io;
};

// global variable to hold the LegupConfig object
// I'd rather use the LLVM getAnalysisIfAvailable mechanism but its broken when
// sharing an immutable pass (LegupConfig) between ModulePass/FunctionPass
// passes
extern LegupConfig *LEGUP_CONFIG;

class Operation {
public:
  Operation() {}

  Operation(float FMax, float CritDelay, float StaticPower, float DynamicPower,
            int LUTs, int Registers, int LogicElements, int DSPElements,
            int Latency)
      : FMax(FMax), CritDelay(CritDelay), StaticPower(StaticPower),
        DynamicPower(DynamicPower), LUTs(LUTs), Registers(Registers),
        LogicElements(LogicElements), DSPElements(DSPElements),
        Latency(Latency) {}

  float getFmax() { return FMax; }
  float getCritDelay() { return CritDelay; }
  float getStaticPower() { return StaticPower; }
  float getDynamicPower() { return DynamicPower; }
  int getLUTs() { return LUTs; }
  int getRegisters() { return Registers; }
  int getLogicElements() { return LogicElements; }
  int getDSPElements() { return DSPElements; }
  int getLatency() { return Latency; }

private:
  float FMax;
  float CritDelay;
  float StaticPower;
  float DynamicPower;
  int LUTs;
  int Registers;
  int LogicElements;
  int DSPElements;
  int Latency;
};

class LegupConfig {
public:
  LegupConfig() {}
  ~LegupConfig() {
    for (std::map<std::pair<std::string, int>, Operation *>::iterator
             i = Operations.begin(),
             e = Operations.end();
         i != e; ++i) {
      assert(i->second);
      delete i->second;
    }
  }

  // Calculate the constraint on the number of function units of a specific
  // type. This lookup uses the tcl parameter set_resource_constraint
  // Returns false if there is no constraint
  bool getNumberOfFUsAllocated(std::string FuName, int *number);

  // works the same as getNumberOfFUsAllocated()
  // This lookup uses the tcl parameter set_operation_latency
  // returns false if no constraint is found
  bool getOperationLatency(std::string FuName, int *latency);

  // works the same as getNumberOfFUsAllocated()
  // This lookup uses the tcl parameter set_operation_sharing
  // By default sharing is ON
  // returns false if no constraint is found
  bool getOperationSharingEnabled(std::string FuName, bool *sharing);

  std::map<std::string, int> &getFuncUnitConstraints() {
    return FuncUnitConstraints;
  }

  static LegupConfig *getLegupConfig();

  int getCustomVerilogCount() { return customVerilogFunctions.size(); }

  /// addCustomVerilog - mark function name as a custom verilog module
  bool addCustomVerilog(const char **args, int numArgs) {

    if (strcmp(args[1], "noMemory") && strcmp(args[1], "memory")) {
      return false;
    }

    legup::CustomVerilogFunction function(*args, strcmp(args[1], "noMemory"));
    for (int i = 2; i < numArgs; i += 3) {

      if (!function.addIO(args[i + 2], args[i + 1], args[i])) {

        return false;
      }
    }
    customVerilogFunctions.insert(function);
    return true;
  }

  /// addCustomVerilogFile - add a file name to the set of custom verilog
  /// files
  void addCustomVerilogFile(std::string file) {
    if (customVerilogFiles.find(file) == customVerilogFiles.end())
      customVerilogFiles.insert(file);
  }

  void setCustomTestBenchModule(std::string name) {
    testBench = name;
    _usesCustomTestBench = true;
  }

  void setCustomTopLevelModule(std::string name) { topLevelModule = name; }

  std::vector<CustomVerilogIO>
  getCustomVerilogIOForFunction(Function *function) {
    return getCustomVerilogIOForFunctionNamed(function->getName().str());
  }

  std::vector<CustomVerilogIO>
  getCustomVerilogIOForFunctionNamed(const std::string &function);

  std::string getCustomTestBench() { return testBench; }

  /// addAccelerator - mark function name for acceleration
  void addAccelerator(std::string function, int numOfInstances = 0 /* 0 means uninitialized */) {
      functions.insert( std::pair<std::string, int>(function, numOfInstances) );
  }

  int getNumOfInstances(std::string function) {
      assert(functions.find(function) != functions.end());
      return functions[function];
  }

  /// return a string containing all the accelerated functions
  std::string getAccelerators(void) {
    std::string fns = "";
    if (numAccelerators() == 0)
      return fns;
    for (std::map<std::string, int>::const_iterator it = functions.begin();
         it != functions.end(); it++)
      fns += it->first + ",";
    return fns.substr(0, fns.size() - 1);
  }

  /// addParallelAccelerator - mark function name for parallel acceleration
  void addParallelAccelerator(std::string function, int numOfInstances = 1) {
    parallelfunctions.insert(function);
    functions.insert( std::pair<std::string, int>(function, numOfInstances));
  }

  void setCacheParameters(std::string type, int value) {
    cacheParameters[type] = value;
  }

  int getCacheParameters(std::string type) {
    int value;
    if (cacheParameters.find(type) == cacheParameters.end()) {
      value = 0; // if this cache parameter was not defined, return 0;
    } else {
      value = cacheParameters[type]; // if defined, return value
    }

    return value;
  }

  void setDCacheType(std::string type) { dcacheType = type; }

  const std::string getDCacheType() {
    if (dcacheType == "") {
      return "MP"; // if cachetype is not specified, it defaults to MP cache.
    } else {
      return dcacheType;
    }
  }

  void addPthreadFunction(std::string funcName) {
    pthreadfunctions.insert(funcName);
  }

  bool usesPthreadFunction(std::string funcName) {
    if (pthreadfunctions.find(funcName) != pthreadfunctions.end()) {
      return true;
    }
    return false;
  }

  bool setLegupOutputPath(std::string path);

  std::string getLegupOutputPath() { return legupOutputPath; }

  /*
    bool isMultiPorted() {
    if (getCacheParameters("dcacheports") > 2) { //if number of ports is bigger
    than 2
    return true;
    } else {
    return false;
    }
    }*/

  /// addParameter - add a parameter ie. ALIAS_ANALYSIS
  void addParameter(std::string name, std::string value) {
    checkValidParameter(name);
    parameters[name] = value;
  }

  void checkValidParameter(const std::string name);

  std::string getParameter(const std::string name) {
    checkValidParameter(name);
    // check environment variable first
    std::string env_name = "LEGUP_" + name;
    char *env_value = getenv(env_name.c_str());
    if (env_value) {
      return env_value;
    } else {
      return parameters[name];
    }
  }

  void setLegupConfigBoard(const std::string _Board) { Board = _Board; }

  const std::string getFPGABoard() {
    /*
    std::string FPGABoard;
    std::string FPGADevice = getDeviceFamily();
    if (FPGADevice == "CycloneII") {
        FPGABoard = "DE2";
    } else if (FPGADevice == "StratixIV") {
        FPGABoard = "DE4";
    } else if (FPGADevice == "CycloneIV") {
        FPGABoard = "DE2-115";
    } else if (FPGADevice == "CycloneV") {
        FPGABoard = "DE1-SoC";
    } else if (FPGADevice == "StratixV") {
        FPGABoard = "DE5-Net";
    } else {
        llvm_unreachable("Unrecognized device family!");
    }
    return FPGABoard;
*/
      return Board;
  }

  bool isXilinxBoard() {
      if (Board == "ML605")
          return true;
      return false;
  }

  int getParameterInt(std::string name) {
      return atoi(getParameter(name.c_str()).c_str());
  }

  bool does_flow_support_multicycle_paths() {
    bool allow_MC_paths = true;

    // Check if registers should be removed from data paths
    if (!getParameterInt("MULTI_CYCLE_REMOVE_REG")) {
      allow_MC_paths = false;
    } else if (getParameterInt("MULTIPUMPING") || isHybridFlow() ||
               numLoopPipelines()) {
      allow_MC_paths = false;
    }

    return allow_MC_paths;
  }

  bool mc_remove_reg_from_icmp_instructions() {
    if (!does_flow_support_multicycle_paths()) {
      return false;
    }
    if (!getParameterInt("MULTI_CYCLE_REMOVE_CMP_REG")) {
      return false;
    }
    return true;
  }

  bool duplicate_load_reg() {
    if (LEGUP_CONFIG->isHybridFlow()) {
      return false;
    }
    if (LEGUP_CONFIG->getParameterInt("MULTI_CYCLE_DUPLICATE_LOAD_REG")) {
      return true;
    }
    return false;
  }

  struct INTERFACE_PORT {
    std::string label;
    bool isInternal;
  };

  void addInterfacePort(std::string label, bool isInternal) {
    INTERFACE_PORT interfaceport;
    interfaceport.label = label;
    interfaceport.isInternal = isInternal;
    interface_ports[label] = interfaceport;
  }

  bool isInterfacePort(std::string label) {
    return (interface_ports.find(label) != interface_ports.end());
  }

  bool isInternalInterface(std::string label) {

	  if ((interface_ports.find(label) != interface_ports.end())){
		  	return interface_ports[label].isInternal;
	  }
	  return false;
  }

  std::map<std::string, INTERFACE_PORT> &getAllInterfacePorts() {
    return interface_ports;
  }

  unsigned numInterfacePorts() { return interface_ports.size(); }

  struct LOOP_PIPELINE {
    bool user_II;
    bool ignoreMemDeps;
    unsigned II;
    std::string label;
  };

  void addLoopPipeline(std::string label, bool user_II, unsigned II,
                       bool ignoreMemDeps) {
    LOOP_PIPELINE pipeline;
    pipeline.user_II = user_II;
    pipeline.II = II;
    pipeline.ignoreMemDeps = ignoreMemDeps;
    pipeline.label = label;
    loop_pipelines[label] = pipeline;
  }

  bool isLoopPipelined(std::string label) {
    return (loop_pipelines.find(label) != loop_pipelines.end());
  }

  LOOP_PIPELINE getLoopPipeline(std::string label) {
    assert(isLoopPipelined(label));
    return loop_pipelines[label];
  }

  std::map<std::string, LOOP_PIPELINE> &getAllLoopPipelines() {
    return loop_pipelines;
  }

  unsigned numLoopPipelines() { return loop_pipelines.size(); }

  bool isLocalMem(std::string function, std::string array) {

    if (localMems.find(function) == localMems.end()) {
      return false;
    }

    return localMems[function].find(array) != localMems[function].end();
  }

  void addLocalMem(std::string function, std::string array) {
    localMems[function].insert(array);
  }

  void setParameter(std::string name, std::string value) {
    checkValidParameter(name);
    parameters[name] = value;
  }

  void setMemoryGlobal(std::string mem_name) {
    userSpecifiedGlobalRAMs[mem_name] = true;
  }

  bool isMemoryUserSpecifiedGlobal(std::string mem_name) {
    return (userSpecifiedGlobalRAMs.find(mem_name) !=
            userSpecifiedGlobalRAMs.end());
  }

  void setResourceConstraint(std::string FuName, std::string numFUs);

  void setOperationLatency(std::string FuName, std::string numCycles);

  void setOperationSharing(std::string state, std::string FuName);

  void setCombineBB(std::string _CombineBB) { CombineBB = _CombineBB; }

  const std::string getCombineBB() { return CombineBB; }

  std::set<std::string> customVerilogFileNames() const {
    return customVerilogFiles;
  }

  /// isCustomVerilog - returns true if the function name is marked as
  /// custom verilog
  bool isCustomVerilog(const Function &F) const {
    std::string name = F.getName().str();
    return isCustomVerilog(name);
  }

  bool isCustomVerilog(const std::string &function) const {
    bool isCustomVerilog =
        customVerilogFunctions.find(function) != customVerilogFunctions.end();
    return isCustomVerilog;
  }

  bool customVerilogUsesMemory(const Function &F) const {
    std::string name = F.getName().str();
    return customVerilogUsesMemory(name);
  }

  bool customVerilogUsesMemory(const std::string &F) const {
    std::set<CustomVerilogFunction>::iterator function =
        customVerilogFunctions.find(F);
    assert(function != customVerilogFunctions.end());
    return function->usesMemory();
  }

  bool usesCustomTestBench() const { return _usesCustomTestBench; }

  std::string getTopLevelModule() const { return topLevelModule; }

  /// isAccelerated - returns true if the function name is marked for
  /// acceleration
  bool isAccelerated(const Function &F) const {
    std::string name = F.getName();
    return isAccelerated(name);
  }

  bool isAccelerated(const std::string &function) const {
    return functions.find(function) != functions.end();
  }

  std::string getProcessor() const {
    std::string PROC_PARAM = "processor";
    return (parameters.find(PROC_PARAM) != parameters.end())
               ? parameters.find(PROC_PARAM)->second
               : "";
  }

  bool isPCIeFlow() const {
    std::string PROC_PARAM = "processor";
    return ((parameters.find(PROC_PARAM) != parameters.end()) &&
            (parameters.find(PROC_PARAM)->second == "host"));
  }

  bool isHybridFlow() const {
    if (std::getenv("LEGUP_HYBRID_FLOW"))
      return true;
    else
      return false;
  }

  bool isParallelAccel(const Function &F) const {
    std::string name = F.getName();
    // pcie hack to generate polling functions
    return isPCIeFlow() || isParallelAccel(name);
  }

  bool isParallelAccel(const std::string &function) const {
    return parallelfunctions.find(function) != parallelfunctions.end();
  }

  unsigned numAccelerators() const { return functions.size(); }

  void setArbiterUsage(bool used) { isArbiterUsed = used; }

  bool getArbiterUsage() { return isArbiterUsed; }

  void setDebuggerUsage(int used) { debuggerUsed = used; }

  bool isDebuggerUsed() { return debuggerUsed; }

  void setDebuggerCaptureMode(int mode) { debuggerCaptureMode = mode; }

  int isDebuggerCaptureMode() { return debuggerCaptureMode; }

  void addOperation(const std::string op_name, const float FMax,
                    const float CritDelay, const float StaticPower,
                    const float DynamicPower, const int LUTs,
                    const int Registers, const int LogicElements,
                    const int DSPElements, const int Latency) {
    Operations[std::make_pair(op_name, Latency)] =
        new Operation(FMax, CritDelay, StaticPower, DynamicPower, LUTs,
                      Registers, LogicElements, DSPElements, Latency);
    if (Latency > maxLatency)
      maxLatency = Latency;
  }

  void setDeviceSpecs(const std::string _DeviceFamily,
                      const std::string _Device, const int _maxLEs,
                      const int _maxM4Ks, const int _maxRAMBits,
                      const int _maxDSPs) {
    DeviceFamily = _DeviceFamily;
    Device = _Device;
    maxLEs = _maxLEs;
    maxM4Ks = _maxM4Ks;
    maxRAMBits = _maxRAMBits;
    maxDSPs = _maxDSPs;
    Operations.clear();
    maxLatency = 0;
  }

  std::string getOpNameFromInst(Instruction *instr, Allocation *alloc);
  bool isAnyOfTwoOperandsZero(Instruction *instr);
  bool populateStringsForOneOperandInstr(Instruction *instr,
                                         std::string params[10]);
  bool populateStringsForTwoOperandInstr(Instruction *instr,
                                         std::string params[10]);
  bool populateStringsForThreeOperandInstr(Instruction *instr,
                                           std::string params[10]);
  bool populateStringsForBinaryOperator(Instruction *instr,
                                        std::string params[10]);
  void populateStringsForICmpInst(const ICmpInst *cmp, std::string params[10]);
  void populateStringsForFCmpInst(const FCmpInst *cmp, std::string params[10]);
  bool isBinaryOperatorNoOp(Instruction *instr);
  bool isSecondOperandZero(Instruction *instr);
  bool isSecondOperandPowerOfTwo(Instruction *instr);
  bool isSecondOperandConstant(Instruction *instr);
  int maxBitWidth(int width0, int width1, int width2);
  bool isSupportedBitwidth(int width);
  std::string assembleOpNameFromStringList(std::string params[10]);

  Operation *getOpFromInst(Instruction *instr, Allocation *alloc) {
    return getOperationRef(getOpNameFromInst(instr, alloc));
  }

  std::string getDeviceFamily() { return DeviceFamily; }

  void check_op_exists(const std::string op_name, int &latency) {
    if (Operations.find(std::make_pair(op_name, latency)) != Operations.end()) {
      return;
    }

    int i;
    for (i = 0; i <= maxLatency; i++) {
      if (Operations.find(std::make_pair(op_name, i)) != Operations.end()) {
        FuncUnitLatencyWarning[op_name] = std::make_pair(latency, i);
        latency = i;
        return;
      }
    }
    errs() << "Error: Couldn't find operation '" << op_name
           << "' in device tcl file!\n";
    assert(0);
  }

  Operation *getOperationRef(const std::string op_name) {
    int latency;
    getOperationLatency(op_name, &latency);
    check_op_exists(op_name, latency);
    const std::pair<std::string, int> op = std::make_pair(op_name, latency);
    return Operations[op];
  }

  Operation &getOperation(const std::string op_name) {
    int latency;
    getOperationLatency(op_name, &latency);
    check_op_exists(op_name, latency);
    const std::pair<std::string, int> op = std::make_pair(op_name, latency);
    return *Operations[op];
  }

  int getMaxM4Ks() { return maxM4Ks; }
  int getMaxLEs() { return maxLEs; }
  int getMaxRAM() { return maxRAMBits; }
  int getMaxDSPs() { return maxDSPs; }

  void printLatencyWarnings() {
    std::map<std::string, std::pair<int, int>>::iterator warning;
    for (warning = FuncUnitLatencyWarning.begin();
         warning != FuncUnitLatencyWarning.end(); warning++) {
      outs() << "warning: Couldn't find operation '" << warning->first
             << "' with latency " << warning->second.first
             << " in device tcl file. Using latency " << warning->second.second
             << " instead.\n";
    }

    /* Clear map */
    FuncUnitLatencyWarning.clear();
    return;
  }

private:
  std::string legupOutputPath{"output"};

  // function name to number of instance mapping
  std::map<std::string, int> functions;
  std::set<std::string> parallelfunctions;
  std::set<std::string> pthreadfunctions;
  std::set<CustomVerilogFunction> customVerilogFunctions;
  std::set<std::string> customVerilogFiles;

  std::string topLevelModule;
  std::string testBench;
  bool _usesCustomTestBench;

  std::map<std::string, LOOP_PIPELINE> loop_pipelines;
  std::map<std::string, INTERFACE_PORT> interface_ports;
  std::map<std::string, std::set<std::string>> localMems;
  std::map<std::string, std::string> parameters;
  std::map<std::string, std::string> userSpecifiedGlobalRAMs;
  std::map<std::pair<std::string, int>, Operation *> Operations;
  std::map<std::string, int> cacheParameters;
  std::string dcacheType;
  std::string DeviceFamily;
  std::string Device;
  std::string Board;
  int maxLEs;
  int maxM4Ks;
  int maxRAMBits;
  int maxDSPs;
  int maxLatency;
  bool isArbiterUsed;
  std::map<std::string, int> FuncUnitConstraints;
  std::map<std::string, int> FuncUnitLatency;
  std::map<std::string, int> FuncUnitSharing;
  /* A way to bypass the issue of printing latency warnings to terminal without
   * tripping the runtest command to think this is an error
   * Cannot print warnings to stdout in function check_op_exists as that goes to
   * assembly bytecode
   * because -modulo-scheduling pass calls getOpNameFromInst
   * Cannot print warnings to stderr as that trips runtest to detect error
   * So, keep mapping of warnings and print to stdout at end of
   * LegupPass::runOnModule
   */
  std::map<std::string, std::pair<int, int>> FuncUnitLatencyWarning;

  bool debuggerUsed;
  bool debuggerCaptureMode;

  std::string CombineBB;
};

} // End legup namespace

#endif
