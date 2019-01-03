# LeFlow

LeFLow is an open-source tool-flow that maps numerical computation models written in Tensorflow
to synthesizable hardware. Our flow bridges Google's XLA compiler LegUp high-level synthesis tool to
automatically generate verilog from a Tensorflow specification.

See publication here: [https://arxiv.org/abs/1807.05317](https://arxiv.org/abs/1807.05317).
## Demo Videos

### Demo 1 - Overview

<a href="https://www.youtube.com/watch?v=y76_RIyq4TM">
    <img src="https://github.com/danielholanda/LeFlow/blob/master/img/LeFlow_thumbnail.png?raw=true" title="LeFlow Overview Demo" width="75%">
</a>

### Demo 2 - DNN for Classifying Google's Quick Draw Dataset

<a href="https://www.youtube.com/watch?v=eHeqenSj0VQ">
    <img src="https://github.com/danielholanda/LeFlow/blob/master/img/Demo2_thumbnail.png?raw=true" title="LeFlow Quick Draw Demo" width="75%">
</a>

## Installing dependencies

### LegUp

LeFlow was built to be compatible with LegUp 4.0. We recommend downloading the virtual machine available at [legup.eecg.utoronto.ca](http://legup.eecg.utoronto.ca/).

### Tensorflow

LeFlow makes some minor changes on Tensorflow to ensure that only Kernels supported by LegUp are used by Tensorflow's XLA. To install the modified version of Tensorflow in the Legup 4.0 virtual machine follow the instructions below.
```
sudo apt-get install python-pip
sudo python -m pip install --upgrade pip
sudo pip install tensorflow-1.6.0-cp27-cp27mu-linux_x86_64.whl --ignore-installed six
```
The whl file and instruction for compiling Tensorflow from scratch can be found on the src/tensorflow folder.  

### LeFlow settings

Before running LeFlow for the first time go to src\LeFlow and set up your python path and the examples directory of Legup. It is also important to make the LeFlow file an executable using the command
```
chmod +x LeFlow
```

### Testing your installation

LeFlow comes to 15 building blocks that are contained inside of the tests folder and used for testing. You should try those tests first before jumping to the more complex examples. The automated testing will generate circuit, test it with Modelsim and make sure that the results match the original Tensorflow results.

- To test your installation, go into the test directory and run
    ``` 
    python test_all.py --fast
    ``` 

All the tests should take less than a minute. For a more complete test, just run the same python script without the "--fast" option.

If one of the tests fail you have a problem with your installation. Please also make sure that the code works with Tesorflow before trying to generate a circuit using LeFlow.

## Getting Started

### Running a single example

To begin running examples with LeFlow tool, do the following:
- Enter the ./test directory and select an example directory (i.e. myAdd)
- To generate hardware from Tensorflow implementation run
    ``` 
    ../../src/LeFlow myAdd.py
    ```
- To test generated hardware using Modelsim run
     ```
     ../../src/LeFlow myAdd.py --modelsim_only  
     ``` 
- To do both above actions with a single command, run 
     ``` 
     ../../src/LeFlow myAdd.py --modelsim 
     ``` 

## Contents:
- src -- includes source code for LeFlow
- test -- simple examples that be run to test the tool
- examples -- complicated examples that can take a significant amount of time to run 

## Authors

* **Daniel Holanda Noronha** - *danielhn-at-ece.ubc.ca* 
* **Bahar Salehpour**
* **Steve Wilton**

## Citing LeFlow

Please cite LeFlow in your publications if it helps your research work:

```
@ARTICLE{leflow,
     author = {{Noronha}, D.~H. and {Salehpour}, B. and {Wilton}, S.~J.~E.},
     title = "{LeFlow: Enabling Flexible FPGA High-Level Synthesis of Tensorflow Deep Neural Networks}",
     journal = {ArXiv e-prints},
     archivePrefix = "arXiv",
     eprint = {1807.05317},
     keywords = {Computer Science - Machine Learning, Statistics - Machine Learning},
     year = 2018,
     month = jul,
     adsurl = {http://adsabs.harvard.edu/abs/2018arXiv180705317N}
} 
```

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
