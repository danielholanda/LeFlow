
# LeFlow Examples

The examples below show some slightly more complex circuits generated using LeFlow. Please remember to first test the example using Tenslorflow before generating a hardware using LeFlow. Some of the examples require the installation of additional libraries, such as matplotlib.

## classificationMNIST

In this example the MNIST digit recognition database is trained offline using Tensorflow and a hardware for inference is generated using LeFlow. 

- To generate hardware for this example run
    ``` 
    ../../src/LeFlow classificationMNIST.py
    ```

- You can then test it on Modelsim using the command
    ``` 
    make v -C classificationMNIST_files/
    ```

After running Modelsim, you can check the generated output at classificationMNIST_files/memory_dump.txt.

A demo for a slighly more complex nexwork can be seen in the video below.

[![LeFlow demo video](https://github.com/danielholanda/LeFlow/blob/master/img/Demo1_thumbnail.png?raw=true)](https://www.youtube.com/watch?v=P5Dml4IDm7k "LeFlow demo video")


## convolutionLenna

This example shows a 2D convolution using the "Lenna" image. Five inputs are generated and plotted at the end.

- To generate hardware for this example run
    ``` 
    ../../src/LeFlow convolutionLenna.py
    ```

## maxpoolMNIST

In this example a maxpool is performed over one of the MNIST digits and display the generated image on the screen. 

- First, generate the circuit using Leflow
    ``` 
    ../../src/LeFlow maxpoolMNIST.py
    ```

- Then, generate the output file by running Modelsim
    ``` 
    make v -C maxpoolMNIST_files/
    ```

- Finally, display the results on the screen
    ``` 
    python displayResults.py
    ```

## memoryBanking

This example is used to show how to partition arrays using LeFlow. 

The simple array partitioning pass implemented requires that the index of the dimension of the array to be partitioned is directly indexed. This generally means that it is require to fully/partially unroll the computations.

- To fully unroll the circuit the following code is used
    ``` 
    options.setUnrollThreshold(100000000)
    ```

Arrays can be either fully partitioned or partitioned in a block or cyclic scheme. When setting up a new array to be partitioned the first argument is the name of the array (as it is written in the IR), the second is the dimension to partition, the third the partitioning scheme (c: cyclic, b: block, f:full) and the fourth is the number of blocks.  

- Example: In order partition array "param0" in its second dimension in a cyclic way using 2 memories: 
    ``` 
    options.setPartitionMemory("param0 2 c 2")
    ```

The memoryBanking example comes with a set of examples on how to partition an array.
