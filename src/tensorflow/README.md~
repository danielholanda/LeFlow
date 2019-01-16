# LeFlow - Installing our version of Tensorflow

LeFlow makes some minor changes on Tensorflow to ensure that only Kernels supported by LegUp are used by Tensorflow's XLA. 

## Precompiled Tensorflow for Legup VM

To install the modified version of Tensorflow in the Legup 4.0 virtual machine follow the instructions below.
```
sudo apt-get install python-pip
sudo python -m pip install --upgrade pip
sudo pip install tensorflow-1.6.0-cp27-cp27mu-linux_x86_64.whl --ignore-installed six
```

## Compiling from scratch

We modified the following files:
- tensorflow/compiler/xla/service/cpu/dot_op_emitter.cc
- tensorflow/compiler/xla/service/cpu/ir_emitter.cc
- tensorflow/compiler/xla/service/llvm_ir/llvm_loop.cc

The modified files are in the LeFlow/src/tensorflow/tensorflow_src directory. The dot_op_emitter file was modified to avoid vectorized operations (which are not supported by LegUp). The ir_emitter file was modified to avoid the eigen convolution that tiles the computation and creates problems in LeFlow. The llvm_loop file was modified to avoid vectorized loop operations. To see the differences, simply "git diff" after cloning the repository.

To compile, first clone the Tensorflow repo and checkout the same branch that LeFlow was based in:
```
git clone https://github.com/tensorflow/tensorflow.git
cd tensorflow
git checkout 336ca16154dc062f2cbab56502395f14f4d01e49
```

Then, copy the files we modified to the cloned repository and compile Tensorflow normally using the instructions shown [here](https://www.tensorflow.org/install/install_sources). Bazel version 0.16.1 is the correct bazel version to use with this tensorflow version (1.6).
