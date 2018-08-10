//===-- Tcl.cpp - Tcl Parser ------------------------------------*- C++ -*-===//
//
// This file is distributed under the LegUp license. See LICENSE for details.
//
//===----------------------------------------------------------------------===//
//
// This file implements the configuration file tcl parser
//
//===----------------------------------------------------------------------===//

#include "llvm/Support/raw_ostream.h"
#include "LegupTcl.h"
#include "LegupConfig.h"

using namespace llvm;

namespace legup {

int set_legup_output_path(ClientData clientData, Tcl_Interp *interp, int argc,
                          const char *argv[]) {
    if (argc != 2) {
        static char error[] = "wrong # args: should be "
                              "\"set_legup_output_path <path>\"";
        interp->result = error;
        assert(0);
        return (TCL_ERROR);
    }

    LegupConfig *config = (LegupConfig *)clientData;
    config->setLegupOutputPath(argv[1]);
    return (TCL_OK);
}

int get_legup_output_path(ClientData clientData, Tcl_Interp *interp, int argc,
                          const char *argv[]) {
    if (argc != 1) {
        static char error[] = "wrong # args: should be "
                              "\"get_legup_output_path\"";
        interp->result = error;
        assert(0);
        return (TCL_ERROR);
    }

    LegupConfig *config = (LegupConfig *)clientData;
    std::string pathStr = config->getLegupOutputPath();
    static char path[100];
    strncpy(path, pathStr.c_str(), 100);
    interp->result = path;
    return (TCL_OK);
}

// checks if the argument is correct. Returns false if incorrect
bool checkArg(const char *argv[], int argNum, const char *option, char *error) {
    assert(argNum > 0);
  if (strcmp(argv[argNum - 1], option) != 0) {
    sprintf(error, "Argument %d is not \"%s\"\n", argNum, option);
    return false;
  }
  return true;
}

bool checkArg2(const char *argv[], int argNum, const char *option,
               const char *option2, char *error) {
  assert(argNum > 0);
  if (strcmp(argv[argNum - 1], option) != 0 &&
      strcmp(argv[argNum - 1], option2) != 0) {
    sprintf(error, "Argument %d is not \"%s\" or \"%s\"\n", argNum, option,
            option2);
    return false;
  }
  return true;
}

int set_custom_top_level_module(ClientData clientData, Tcl_Interp *interp,
                                int argc, const char *argv[]) {

  if (argc != 2) {
    static char error[] = "wrong # args: should be "
                          "\"set_custom_verilog_file fileName\"";
    interp->result = error;
    return (TCL_ERROR);
  }

  LegupConfig *config = (LegupConfig *)clientData;
  config->setCustomTopLevelModule(argv[1]);

  return (TCL_OK);
}

int set_custom_test_bench_module(ClientData clientData, Tcl_Interp *interp,
                                 int argc, const char *argv[]) {

  if (argc != 2) {
    static char error[] = "wrong # args: should be "
                          "\"set_custom_test_bench_module moduleName\"";
    interp->result = error;
    return (TCL_ERROR);
  }

  LegupConfig *config = (LegupConfig *)clientData;
  config->setCustomTestBenchModule(argv[1]);

  return (TCL_OK);
}

int set_custom_verilog_file(ClientData clientData, Tcl_Interp *interp, int argc,
                            const char *argv[]) {

  if (argc != 2) {
    static char error[] = "wrong # args: should be "
                          "\"set_custom_verilog_file fileName\"";
    interp->result = error;
    return (TCL_ERROR);
  }

  LegupConfig *config = (LegupConfig *)clientData;
  config->addCustomVerilogFile(argv[1]);
  return (TCL_OK);
}

int set_custom_verilog_function(ClientData clientData, Tcl_Interp *interp,
                                int argc, const char *argv[]) {

  LegupConfig *config = (LegupConfig *)clientData;

  // Must have the tcl command, the function name, whether it requires memory
  // access, and 3 arguments for each I/O.
  // Hence, it must have >= 2 arguments and the number of arguments minus the
  // tcl command and the function name must be divisible by 3.
  if (argc < 3 || ((argc - 3) % 3)) {

    goto return_error;
  }

  if (!config->addCustomVerilog(&(argv[1]), argc - 1)) {

    goto return_error;
  }
  return (TCL_OK);

return_error:
  static char error[] = "wrong # args: should be "
                        "\"set_custom_verilog_function functionName"
                        " [memory or noMemory] <optional [input or output] "
                        "high_bit:low_bit signalName>\"";
  interp->result = error;
  return (TCL_ERROR);
}

/// set_accelerator_function - tcl command to add an accelerator function
int set_accelerator_function(ClientData clientData, Tcl_Interp *interp,
                             int argc, const char *argv[]) {
  int numOfInstances = 0;  // uninitialized value
  if ((argc != 2 && argc != 3) ||
          (argc == 3 && sscanf(argv[2], "%d", &numOfInstances) != 1)) {
    static char error[] = "wrong # args: should be "
                          "\"set_accelerator_function functionName [numOfInstances]\"";
    interp->result = error;
    return (TCL_ERROR);
  }

  LegupConfig *config = (LegupConfig *)clientData;
  config->addAccelerator(argv[1], numOfInstances);
  return (TCL_OK);
}

/// get_accelerator_function - tcl command to add an accelerator function
int get_accelerator_function(ClientData clientData, Tcl_Interp *interp,
                             int argc, const char *argv[]) {
  if (argc != 1) {
    static char error[] = "wrong # args: should be "
                          "\"get_accelerator_function\"";
    interp->result = error;
    return (TCL_ERROR);
  }
  LegupConfig *config = (LegupConfig *)clientData;
  std::string functions = config->getAccelerators();
  static char fns[128];
  strncpy(fns, functions.c_str(), 128);
  interp->result = fns;
  return (TCL_OK);
}

/// set_parallel_accelerator_function - tcl command to add a parallel
/// accelerator function (used for OpenMP for Pthreads)
int set_parallel_accelerator_function(ClientData clientData, Tcl_Interp *interp,
                                      int argc, const char *argv[]) {
  if (argc != 2) {
    static char error[] =
        "wrong # args: should be "
        "\"set_parallel_accelerator_function parallelfunctionName\"";
    interp->result = error;
    return (TCL_ERROR);
  }
  LegupConfig *config = (LegupConfig *)clientData;
  config->addParallelAccelerator(argv[1]);
  return (TCL_OK);
}

/// These are just placeholders to recognize the tcl commands.
/// The actual work is done in a script (genRAM.pl).
int set_dcache_size(ClientData clientData, Tcl_Interp *interp, int argc,
                    const char *argv[]) {
  if (argc != 2) {
    static char error[] = "wrong # args: should be "
                          "\"set_dcache_size size(in KB)\"";
    interp->result = error;
    return (TCL_ERROR);
  }
  LegupConfig *config = (LegupConfig *)clientData;
  config->setCacheParameters("dcachesize", atoi(argv[1]));
  return (TCL_OK);
}

int set_dcache_linesize(ClientData clientData, Tcl_Interp *interp, int argc,
                        const char *argv[]) {
  if (argc != 2) {
    static char error[] = "wrong # args: should be "
                          "\"set_dcache_linesize size(in bytes)\"";
    interp->result = error;
    return (TCL_ERROR);
  }
  LegupConfig *config = (LegupConfig *)clientData;
  config->setCacheParameters("dcachelinesize", atoi(argv[1]));
  return (TCL_OK);
}

int set_dcache_way(ClientData clientData, Tcl_Interp *interp, int argc,
                   const char *argv[]) {
  if (argc != 2) {
    static char error[] = "wrong # args: should be "
                          "\"set_dcache_way associativity\"";
    interp->result = error;
    return (TCL_ERROR);
  }
  LegupConfig *config = (LegupConfig *)clientData;
  config->setCacheParameters("dcacheway", atoi(argv[1]));
  return (TCL_OK);
}

int set_icache_size(ClientData clientData, Tcl_Interp *interp, int argc,
                    const char *argv[]) {
  if (argc != 2) {
    static char error[] = "wrong # args: should be "
                          "\"set_icache_size size(in KB)\"";
    interp->result = error;
    return (TCL_ERROR);
  }
  LegupConfig *config = (LegupConfig *)clientData;
  config->setCacheParameters("icachesize", atoi(argv[1]));
  return (TCL_OK);
}

int set_icache_linesize(ClientData clientData, Tcl_Interp *interp, int argc,
                        const char *argv[]) {
  if (argc != 2) {
    static char error[] = "wrong # args: should be "
                          "\"set_icache_linesize size(in bytes)\"";
    interp->result = error;
    return (TCL_ERROR);
  }
  LegupConfig *config = (LegupConfig *)clientData;
  config->setCacheParameters("icachelinesize", atoi(argv[1]));
  return (TCL_OK);
}

int set_icache_way(ClientData clientData, Tcl_Interp *interp, int argc,
                   const char *argv[]) {
  if (argc != 2) {
    static char error[] = "wrong # args: should be "
                          "\"set_icache_way associativity\"";
    interp->result = error;
    return (TCL_ERROR);
  }
  LegupConfig *config = (LegupConfig *)clientData;
  config->setCacheParameters("icacheway", atoi(argv[1]));
  return (TCL_OK);
}

int set_dcache_ports(ClientData clientData, Tcl_Interp *interp, int argc,
                     const char *argv[]) {
  if (argc != 2) {
    static char error[] = "wrong # args: should be "
                          "\"set_dcache_ports number\"";
    interp->result = error;
    return (TCL_ERROR);
  }
  LegupConfig *config = (LegupConfig *)clientData;
  config->setCacheParameters("dcacheports", atoi(argv[1]));
  return (TCL_OK);
}

int set_dcache_type(ClientData clientData, Tcl_Interp *interp, int argc,
                    const char *argv[]) {
  if (argc != 2) {
    static char error[] = "wrong # args: should be "
                          "\"set_dcache_type LVT/MP\"";
    interp->result = error;
    return (TCL_ERROR);
  }
  LegupConfig *config = (LegupConfig *)clientData;
  config->setDCacheType(argv[1]);
  return (TCL_OK);
}

/// use_debugger - tcl command to turn debugger on/off
int use_debugger(ClientData clientData, Tcl_Interp *interp, int argc,
                 const char *argv[]) {
  if (argc != 2) {
    static char error[] = "wrong # args: should be "
                          "\"use_debugger 0/1\"";
    interp->result = error;
    return (TCL_ERROR);
  }
  LegupConfig *config = (LegupConfig *)clientData;
  config->setDebuggerUsage(atoi(argv[1]));
  return (TCL_OK);
}

/// debugger_capture_mode - tcl command to set debugger to capture mode
int debugger_capture_mode(ClientData clientData, Tcl_Interp *interp, int argc,
                          const char *argv[]) {
  if (argc != 2) {
    static char error[] = "wrong # args: should be "
                          "\"debugger_capture_mode 0/1\"";
    interp->result = error;
    return (TCL_ERROR);
  }
  LegupConfig *config = (LegupConfig *)clientData;
  config->setDebuggerCaptureMode(atoi(argv[1]));
  return (TCL_OK);
}

/// set_operation_attributes - tcl command to add hardware operation data
int set_operation_attributes(ClientData clientData, Tcl_Interp *interp,
                             int argc, const char *argv[]) {
  static char error[100];
  if (argc != 21) {
    sprintf(error, "%s", "Expecting 21 arguments.");
    interp->result = error;
    return (TCL_ERROR);
  }
  LegupConfig *config = (LegupConfig *)clientData;

  // check arguments are correct
  if (!checkArg(argv, 2, "-Name", error) ||
      !checkArg(argv, 4, "-Fmax", error) ||
      !checkArg(argv, 6, "-CritDelay", error) ||
      !checkArg(argv, 8, "-StaticPower", error) ||
      !checkArg(argv, 10, "-DynamicPower", error) ||
      !checkArg2(argv, 12, "-LUTs", "-ALUTs", error) ||
      !checkArg(argv, 14, "-Registers", error) ||
      !checkArg2(argv, 16, "-LEs", "-ALMs", error) ||
      !checkArg(argv, 18, "-DSP", error) ||
      !checkArg(argv, 20, "-Latency", error)) {
    interp->result = error;
    return (TCL_ERROR);
  }

  float FMax = atof(argv[4]);
  float CritDelay = atof(argv[6]);
  float StaticPower = atof(argv[8]);
  float DynamicPower = atof(argv[10]);
  int LUTs = atoi(argv[12]);
  int Registers = atoi(argv[14]);
  int LogicElements = atoi(argv[16]);
  int DSPElements = atoi(argv[18]);
  int Latency = atoi(argv[20]);

  config->addOperation(argv[2], FMax, CritDelay, StaticPower, DynamicPower,
                       LUTs, Registers, LogicElements, DSPElements, Latency);
  return (TCL_OK);
}

/// set_device_specs - tcl command to add device information
int set_device_specs(ClientData clientData, Tcl_Interp *interp, int argc,
                     const char *argv[]) {
  static char error[100];
  if (argc != 13) {
    sprintf(error, "%s", "Expecting 13 arguments.");
    interp->result = error;
    return (TCL_ERROR);
  }
  LegupConfig *config = (LegupConfig *)clientData;

  if (!checkArg(argv, 2, "-Family", error) ||
      !checkArg(argv, 4, "-Device", error) ||
      !checkArg2(argv, 6, "-MaxLEs", "-MaxALMs", error) ||
      !checkArg2(argv, 8, "-MaxM4Ks", "-MaxM9KMemBlocks", error) ||
      !checkArg(argv, 10, "-MaxRAMBits", error) ||
      !checkArg(argv, 12, "-MaxDSPs", error)) {
    interp->result = error;
    return (TCL_ERROR);
  }

  int MaxLEs = atoi(argv[6]);
  int MaxM4Ks = atoi(argv[8]);
  int MaxRAMBits = atoi(argv[10]);
  int MaxDSPs = atoi(argv[12]);

  config->setDeviceSpecs(argv[2], argv[4], MaxLEs, MaxM4Ks, MaxRAMBits,
                         MaxDSPs);
  return (TCL_OK);
}

/// loop_pipeline - tcl command to pipeline a loop:
///       loop_pipeline "loop_label" [ -ii <num> ] [-ignore-mem-deps]
/// optional arguments:
///   -ii <num>
///       force a specific pipeline initiation interval
///   -ignore-mem-deps
///       ignore loop carried dependencies for all memory accesses in the loop
///      loop_pipeline "loop" -ii 1
/// Examples:
///     loop_pipeline "loop1"
///     loop_pipeline "loop2" -ii 1
///     loop_pipeline "loop3" -ii 4 -ignore-mem-deps
///     loop_pipeline "loop4" -ignore-mem-deps
int loop_pipeline(ClientData clientData, Tcl_Interp *interp, int argc,
                  const char *argv[]) {
  if (argc < 2) {
    static char error[] =
        "wrong # args: should be "
        "\"loop_pipeline \"loop\" [ -ii 1 ] [-ignore-mem-deps]\"";
    interp->result = error;
    errs() << "Error: " << error << "\n";
    assert(0);
    return (TCL_ERROR);
  }

  // look for optional arguments
  bool user_II = false;
  int II = 0;
  bool ignoreMemDeps = false;
  for (int i = 3; i <= argc; i++) {

    if (strcmp(argv[i - 1], "-ii") == 0) {
      i++;
      assert(i <= argc && "Wrong # args for loop_pipeline -ii option");
      user_II = true;
      II = atoi(argv[i - 1]);
      assert(II >= 0 && "Initiation interval must be non-negative");

    } else if (strcmp(argv[i - 1], "-ignore-mem-deps") == 0) {
      ignoreMemDeps = true;

    } else {
      errs() << "arg value: " << argv[i - 1] << "\n";
      assert(0 && "Unrecognized optional argument to loop_pipeline");
    }
  }

  const char *label = argv[1];

  LegupConfig *config = (LegupConfig *)clientData;
  config->addLoopPipeline(label, user_II, II, ignoreMemDeps);
  return (TCL_OK);
}

/// return the device family set previously using the set_device_specs command
int get_device_family(ClientData clientData, Tcl_Interp *interp, int argc,
                      const char *argv[]) {
  if (argc != 1) {
    static char error[] = "wrong # args: should be "
                          "\"get_device_family\"";
    interp->result = error;
    assert(0);
    return (TCL_ERROR);
  }

  LegupConfig *config = (LegupConfig *)clientData;
  std::string familyStr = config->getDeviceFamily();
  static char family[100];
  strncpy(family, familyStr.c_str(), 100);
  interp->result = family;
  return (TCL_OK);
}

int set_legup_config_board(ClientData clientData, Tcl_Interp *interp, int argc,
                           const char *argv[]) {
  if (argc != 2) {
    static char error[] = "wrong # args: should be "
                          "\"set_legup_config_board <board>\"";
    interp->result = error;
    assert(0);
    return (TCL_ERROR);
  }
  LegupConfig *config = (LegupConfig *)clientData;
  config->setLegupConfigBoard(argv[1]);
  return (TCL_OK);
}

int get_board(ClientData clientData, Tcl_Interp *interp, int argc,
              const char *argv[]) {
  if (argc != 1) {
    static char error[] = "wrong # args: should be "
                          "\"get_board\"";
    interp->result = error;
    assert(0);
    return (TCL_ERROR);
  }

  LegupConfig *config = (LegupConfig *)clientData;
  std::string boardStr = config->getFPGABoard();
  static char board[100];
  strncpy(board, boardStr.c_str(), 100);
  interp->result = board;
  return (TCL_OK);
}

int get_top_level_module(ClientData clientData, Tcl_Interp *interp, int argc,
                         const char *argv[]) {
  if (argc != 1) {
    static char error[] = "wrong # args: should be "
                          "\"get_top_level_module\"";
    interp->result = error;
    assert(0);
    return (TCL_ERROR);
  }

  LegupConfig *config = (LegupConfig *)clientData;
  std::string topLevelModuleStr = config->getTopLevelModule();

  if (topLevelModuleStr.empty()) {

    // Set the top level module to de2 or de4
    std::string board = config->getFPGABoard();
    if (board == "DE2" || board == "DE2-115") {
        topLevelModuleStr = "de2";
    } else if (board == "DE4") {
        topLevelModuleStr = "de4";
    } else if (board == "ML605") {
        topLevelModuleStr = "ML605";
    } else {
        topLevelModuleStr = "top";
    }
  }

  static char topLevelModule[100];
  strncpy(topLevelModule, topLevelModuleStr.c_str(), 100);
  interp->result = topLevelModule;
  return (TCL_OK);
}

int get_test_bench_name(ClientData clientData, Tcl_Interp *interp, int argc,
                        const char *argv[]) {
  if (argc != 1) {
    static char error[] = "wrong # args: should be "
                          "\"get_test_bench_name\"";
    interp->result = error;
    assert(0);
    return (TCL_ERROR);
  }

  LegupConfig *config = (LegupConfig *)clientData;
  std::string testbench =
      config->usesCustomTestBench() ? config->getCustomTestBench() : "main_tb";

  static char tb[100];
  strncpy(tb, testbench.c_str(), 100);
  interp->result = tb;
  return (TCL_OK);
}

int get_processor(ClientData clientData, Tcl_Interp *interp, int argc,
                  const char *argv[]) {
  if (argc != 1) {
    static char error[] = "wrong # args: should be "
                          "\"get_processor\"";
    interp->result = error;
    assert(0);
    return (TCL_ERROR);
  }

  LegupConfig *config = (LegupConfig *)clientData;
  std::string processor = config->getProcessor();

  static char processorStr[100];
  strncpy(processorStr, processor.c_str(), 100);
  interp->result = processorStr;

  return (TCL_OK);
}

int atleast_one_custom_verilog(ClientData clientData, Tcl_Interp *interp,
                               int argc, const char *argv[]) {
  if (argc != 1) {
    static char error[] = "wrong # args: should be "
                          "\"get_custom_verilog_count\"";
    interp->result = error;
    assert(0);
    return (TCL_ERROR);
  }

  LegupConfig *config = (LegupConfig *)clientData;
  int customVerilogCount = config->getCustomVerilogCount();

  static char customVerilogCountStr[2];
  if (customVerilogCount > 0) {
    customVerilogCountStr[0] = 'y';
  } else {
    customVerilogCountStr[0] = 'n';
  }
  customVerilogCountStr[1] = 0;
  interp->result = customVerilogCountStr;

  return (TCL_OK);
}

/// set_memory_local - tcl command to put an array in a local altsyncram instead of
/// the shared memory controller
int set_memory_local(ClientData clientData, Tcl_Interp *interp, int argc,
              const char *argv[]) {
  if (argc != 3) {
    static char error[] = "wrong # args: should be "
                          "\"set_memory_local function_name array_name\"";
    interp->result = error;
    return (TCL_ERROR);
  }
  LegupConfig *config = (LegupConfig *)clientData;

  config->addLocalMem(argv[1], argv[2]);
  return (TCL_OK);
}

/// set_parameter - tcl command to add device information
int set_parameter(ClientData clientData, Tcl_Interp *interp, int argc,
                  const char *argv[]) {
  if (argc != 3) {
    static char error[] = "wrong # args: should be "
                          "\"set_parameter name value\"";
    interp->result = error;
    return (TCL_ERROR);
  }
  LegupConfig *config = (LegupConfig *)clientData;

  config->setParameter(argv[1], argv[2]);
  return (TCL_OK);
}

int get_parameter(ClientData clientData, Tcl_Interp *interp, int argc,
                  const char *argv[]) {
    if (argc != 2) {
        static char error[] = "wrong # args: should be "
                              "\"get_parameter name\"";
        interp->result = error;
        assert(0);
        return (TCL_ERROR);
    }

    LegupConfig *config = (LegupConfig *)clientData;
    // Check of the parameter is valid
    config->checkValidParameter(argv[1]);
    // Get the parameter's value
    std::string parameterValue = config->getParameter(argv[1]);

    static char parameterStr[100];
    strncpy(parameterStr, parameterValue.c_str(), 100);
    interp->result = parameterStr;

    return (TCL_OK);
}

/// set_memory_global - tcl command to specify a memory goes to global memory
/// instead of local memory
int set_memory_global(ClientData clientData, Tcl_Interp *interp, int argc,
                      const char *argv[]) {
  if (argc != 2) {
    static char error[] = "wrong # args: should be "
                          "\"set_mem_global ram_name\"";
    interp->result = error;
    return (TCL_ERROR);
  }
  LegupConfig *config = (LegupConfig *)clientData;

  config->setMemoryGlobal(argv[1]);
  return (TCL_OK);
}

/// set_resource_constraint <FuName> <NumberFUs> - tcl command to add resource
/// constraints. The FuName should match the tcl database file
int set_resource_constraint(ClientData clientData, Tcl_Interp *interp, int argc,
                            const char *argv[]) {
  if (argc != 3) {
    static char error[] = "wrong # args: should be "
                          "\"set_resource_constraint FuName NumberFUs\"";
    interp->result = error;
    return (TCL_ERROR);
  }
  LegupConfig *config = (LegupConfig *)clientData;

  config->setResourceConstraint(argv[1], argv[2]);
  return (TCL_OK);
}

/// set_operation_latency <FuName> <NumberCycles> - tcl command to add operation
/// latency constraints. The FuName should match the tcl database file
int set_operation_latency(ClientData clientData, Tcl_Interp *interp, int argc,
                          const char *argv[]) {
  if (argc != 3) {
    static char error[] = "wrong # args: should be "
                          "\"set_operation_latency FuName NumberCycles\"";
    interp->result = error;
    return (TCL_ERROR);
  }
  LegupConfig *config = (LegupConfig *)clientData;

  config->setOperationLatency(argv[1], argv[2]);
  return (TCL_OK);
}

/// set_operation_sharing <-off/-on> <FuName> - tcl command to turn off
/// operation
/// sharing for a resource type. The FuName should match the tcl database file
int set_operation_sharing(ClientData clientData, Tcl_Interp *interp, int argc,
                          const char *argv[]) {
  if (argc != 3) {
    static char error[] = "wrong # args: should be "
                          "\"set_operation_sharing <-off/-on> FuName\"";
    interp->result = error;
    return (TCL_ERROR);
  }
  LegupConfig *config = (LegupConfig *)clientData;

  config->setOperationSharing(argv[1], argv[2]);
  return (TCL_OK);
}

int set_combine_basicblock(ClientData clientData, Tcl_Interp *interp, int argc,
                           const char *argv[]) {
  if (argc != 2) {
    static char error[] = "wrong # args: should be "
                          "\"set_combine_basicblock combineBBValue\"";
    interp->result = error;
    assert(0);
    return (TCL_ERROR);
  }

  LegupConfig *config = (LegupConfig *)clientData;
  config->setCombineBB(argv[1]);
  return (TCL_OK);
}

int get_combine_basicblock(ClientData clientData, Tcl_Interp *interp, int argc,
                           const char *argv[]) {
  if (argc != 1) {
    static char error[] = "wrong # args: should be "
                          "\"get_combine_basicblock\"";
    interp->result = error;
    assert(0);
    return (TCL_ERROR);
  }

  LegupConfig *config = (LegupConfig *)clientData;
  std::string combineStr = config->getCombineBB();
  static char combine[10];
  strncpy(combine, combineStr.c_str(), 10);
  interp->result = combine;
  return (TCL_OK);
}

int set_interface_port(ClientData clientData, Tcl_Interp *interp, int argc,
                           const char *argv[]) {
  if ((argc < 2) || (3 < argc) ) {
    static char error[] = "wrong # args: should be \"set_interface_port \"[volatile_global_variable]\" <optional [port_type]>";
    interp->result = error;
    errs() << "Error: " << error << "\n";
    assert(0);
    return (TCL_ERROR);
  }

	bool isInternal = true;

	const char *label = argv[1];



	if (argc == 3){
		std::string type_param(argv[2]);
		if (type_param == "internal"){
			isInternal = true;
			printf("Adding Internal: %s\n",label);
		}
		//Port Interface Options
	}



	printf("Adding port: %s\n",label);

  LegupConfig *config = (LegupConfig *)clientData;
  config->addInterfacePort(label,isInternal);
  return (TCL_OK);
}

int set_interface_ports(ClientData clientData, Tcl_Interp *interp, int argc,
                           const char *argv[]) {
  if (argc < 2) {
    static char error[] = "wrong # args: should be \"set_interface_ports \"[volatile_global_variable1]\" \"[volatile_global_variable2]\"";
    interp->result = error;
    errs() << "Error: " << error << "\n";
    assert(0);
    return (TCL_ERROR);
  }

	bool isInternal = true;

	LegupConfig *config = (LegupConfig *)clientData;

	for (int i=1; i<argc; i++){
		const char *label = argv[i];

		printf("Adding port: %s\n",label);


		config->addInterfacePort(label,isInternal);

	}
	return (TCL_OK);
}


Tcl_Interp *setupTcl(LegupConfig *legupConfig) {
    Tcl_Interp *interp = Tcl_CreateInterp();
    assert(interp);
    Tcl_CreateCommand(interp, "set_legup_output_path", set_legup_output_path,
                      legupConfig, 0);
    Tcl_CreateCommand(interp, "get_legup_output_path", get_legup_output_path,
                      legupConfig, 0);
    Tcl_CreateCommand(interp, "set_custom_top_level_module",
                      set_custom_top_level_module, legupConfig, 0);
    Tcl_CreateCommand(interp, "set_custom_test_bench_module",
                      set_custom_test_bench_module, legupConfig, 0);
  Tcl_CreateCommand(interp, "set_custom_verilog_file", set_custom_verilog_file,
                    legupConfig, 0);
  Tcl_CreateCommand(interp, "set_custom_verilog_function",
                    set_custom_verilog_function, legupConfig, 0);
  Tcl_CreateCommand(interp, "set_accelerator_function",
                    set_accelerator_function, legupConfig, 0);
  Tcl_CreateCommand(interp, "set_parallel_accelerator_function",
                    set_parallel_accelerator_function, legupConfig, 0);
  Tcl_CreateCommand(interp, "set_dcache_size", set_dcache_size, legupConfig, 0);
  Tcl_CreateCommand(interp, "set_dcache_linesize", set_dcache_linesize,
                    legupConfig, 0);
  Tcl_CreateCommand(interp, "set_dcache_way", set_dcache_way, legupConfig, 0);
  Tcl_CreateCommand(interp, "set_icache_size", set_icache_size, legupConfig, 0);
  Tcl_CreateCommand(interp, "set_icache_linesize", set_icache_linesize,
                    legupConfig, 0);
  Tcl_CreateCommand(interp, "set_icache_way", set_icache_way, legupConfig, 0);
  Tcl_CreateCommand(interp, "set_dcache_ports", set_dcache_ports, legupConfig,
                    0);
  Tcl_CreateCommand(interp, "set_dcache_type", set_dcache_type, legupConfig, 0);
  Tcl_CreateCommand(interp, "use_debugger", use_debugger, legupConfig, 0);
  Tcl_CreateCommand(interp, "debugger_capture_mode", debugger_capture_mode,
                    legupConfig, 0);
  Tcl_CreateCommand(interp, "set_operation_attributes",
                    set_operation_attributes, legupConfig, 0);
  Tcl_CreateCommand(interp, "set_device_specs", set_device_specs, legupConfig,
                    0);
  Tcl_CreateCommand(interp, "set_parameter", set_parameter, legupConfig, 0);
  Tcl_CreateCommand(interp, "get_parameter", get_parameter, legupConfig, 0);
  Tcl_CreateCommand(interp, "set_resource_constraint", set_resource_constraint,
                    legupConfig, 0);
  Tcl_CreateCommand(interp, "set_operation_latency", set_operation_latency,
                    legupConfig, 0);
  Tcl_CreateCommand(interp, "set_operation_sharing", set_operation_sharing,
                    legupConfig, 0);
  Tcl_CreateCommand(interp, "loop_pipeline", loop_pipeline, legupConfig, 0);
  Tcl_CreateCommand(interp, "set_memory_local", set_memory_local, legupConfig,
          0);
  Tcl_CreateCommand(interp, "get_device_family", get_device_family, legupConfig,
                    0);
  Tcl_CreateCommand(interp, "set_legup_config_board", set_legup_config_board,
                    legupConfig, 0);
  Tcl_CreateCommand(interp, "get_board", get_board, legupConfig, 0);
  Tcl_CreateCommand(interp, "get_test_bench_name", get_test_bench_name,
                    legupConfig, 0);
  Tcl_CreateCommand(interp, "get_top_level_module", get_top_level_module,
                    legupConfig, 0);
  Tcl_CreateCommand(interp, "get_accelerator_function",
                    get_accelerator_function, legupConfig, 0);
  Tcl_CreateCommand(interp, "atleast_one_custom_verilog",
                    atleast_one_custom_verilog, legupConfig, 0);
  Tcl_CreateCommand(interp, "get_processor", get_processor, legupConfig, 0);
  Tcl_CreateCommand(interp, "set_memory_global", set_memory_global, legupConfig,
                    0);
  Tcl_CreateCommand(interp, "set_combine_basicblock", set_combine_basicblock,
                    legupConfig, 0);
  Tcl_CreateCommand(interp, "get_combine_basicblock", get_combine_basicblock,
                    legupConfig, 0);
  Tcl_CreateCommand(interp, "set_interface_port", set_interface_port,
                      legupConfig, 0);
  Tcl_CreateCommand(interp, "set_interface_ports", set_interface_ports,
                        legupConfig, 0);

  return interp;
}

bool teardownTcl(Tcl_Interp *interp, int result, std::string &ConfigFile) {
  if (result != TCL_OK) {
    errs() << ConfigFile << ":" << interp->errorLine
           << ": error: " << Tcl_GetStringResult(interp) << "\n";
  }
  Tcl_DeleteInterp(interp);
  // can't call Tcl_Finalize() here - if we have multiple files then we'll
  // get a segfault. But note that without this call Tcl leaks some memory
  // Tcl_Finalize();
  return (result == TCL_OK);
}

/// parseTclString - evaluates tcl commands and initializes the legupConfig
/// object. Returns false on error.
bool parseTclString(std::string &commands, LegupConfig *legupConfig) {
  Tcl_Interp *interp = setupTcl(legupConfig);

  int result = Tcl_Eval(interp, commands.c_str());

  return teardownTcl(interp, result, commands);
}

/// parseTclFile - reads a tcl configuration file and initialize the legupConfig
/// object. Returns false on error.
bool parseTclFile(std::string &ConfigFile, LegupConfig *legupConfig) {
  Tcl_Interp *interp = setupTcl(legupConfig);

  int result = Tcl_EvalFile(interp, ConfigFile.c_str());

  return teardownTcl(interp, result, ConfigFile);
}

} // End legup namespace
