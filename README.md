
# LeFlow

LeFLow is an open-source tool-flow that maps numerical computation models written in Tensorflow
to synthesizable hardware. Our flow bridges Google's XLA compiler LegUp high-level synthesis tool to
automatically generate verilog from a Tensorflow specification.

## Demo video

[![LeFLow demo video](https://github.com/danielholanda/LeFlow/blob/master/img/LeFlow_thumbnail.png?raw=true)](https://www.youtube.com/watch?v=y76_RIyq4TM "LeFlow demo video")

## Installing dependencies

### LegUp

LeFlow was built to be compatible with LegUp 4.0. We recommend downloading the virtual machine available at [legup.eecg.utoronto.ca](http://legup.eecg.utoronto.ca/).

### Tensorflow

LeFlow makes some minor changes on Tensorflow to ensure that only Kernels supported by LegUp are used by Tensorflow's XLA. To install the modified version of Tensorflow in the Legup 4.0 virtual machine simply "pip install" the .whl file located in our src folder. Instructions for compiling Tensorflow from scratch with our changes are comming soon.  

## Getting Started

### Running a single example

To begin running examples with LeFlow tool, do the following:
- Enter the ./test directory and select an example directory (i.e. myAdd)
- To generate hardware from Tensorflow implementation run
	> ../../src/LeFlow myAdd.py -> Generate hardware from Tensorflow implementation
- To test generated hardware using Modelsim run
	> ../../src/LeFlow myAdd.py --modelsim_only  
- To do both above actions with a single command, run 
	> ../../src/LeFlow myAdd.py --modelsim 

### Running all tests

- To run all the tests at once, go into the ./test directory and run
	> python test_leflow.py

## Contents:
- src -- includes source code for LeFlow
- test -- simple examples that be run to test the tool
- examples -- complicated examples that can take a significant amount of time to run 

## Authors

* **Daniel Holanda Noronha** - *danielhn@ece.ubc.ca* 
* **Bahar Salehpour** - *bahars@ece.ubc.ca* 
* **Steve Wilton** - *stevew@ece.ubc.ca* 

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
