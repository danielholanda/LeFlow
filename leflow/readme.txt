###############################################################################
# LeFlow - 2018
# Daniel Holanda Noronha, Bahar Salehpour
###############################################################################

To begin running examples with LeFlow tool, do the following:
- Enter the ./test directory and select an example directory (i.e. myAdd)
- Enter the myAdd directory and run
	> ../../src/LeFlow myAdd.py -> Generate hardware from Tensorflow implementation
	> ../../src/LeFlow myAdd.py --modelsim_only -> Test generated hardware using Modelsim 
- To do both above actions with a single command, run 
	> ../../src/LeFlow myAdd.py --modelsim 
- To run all the tests at once, go into the ./test directory and run
	> python test_leflow.py

Contents:
- src -- includes source code for LeFlow
- test -- simple examples that be run to test the tool
- examples -- complicated examples that can take a significant amount of time to run 
