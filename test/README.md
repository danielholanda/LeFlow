# LeFlow Tests

LeFlow comes to 15 building blocks that are contained inside of the tests folder and used for testing. You should try those tests first before jumping to the more complex examples. The automated testing will generate circuit, test it with Modelsim and make sure that the results match the original Tensorflow results.

- To test your installation, run
    ``` 
    python test_all.py --fast
    ``` 

The tests should take less than a minute. For a more complete test, just run the same python script without the "--fast" option.

If one of the tests fail you have a problem with your installation. Please also make sure that the code works with Tesorflow before trying to generate a circuit using LeFlow.

In order to reproduce the results of the paper add "set_parameter INFERRED_RAMS 0" to the LeFlow_config.tcl file. This allows a more fair comparison of the circuits.


## Tests description

- vecmul_a 
    Element-by-element multiplication of two arrays of size 8

- vecmul_b 
    Element-by-element multiplication of two arrays of size 64

- vecmul_b_u 
    Element-by-element multiplication of two arrays of size 64 fully unrolled

- dense_a 
    Dense layer including bias and relu activation with 1 input and 8 outputs

- dense_b 
    Dense layer including bias and relu activation with 1 input and 64 outputs

- softmax_a
    Softmax with 8 elements

- softmax_b
    Softmax with 64 elements

- softmax_b_u
    Softmax with 64 elements with computations fully unrolled

- conv2d_a
    2D convolution using a 3x3 filter, stride of 1, 1 8x8 input and 2 8x8 outputs

- conv2d_a_u
    2D convolution using a 3x3 filter, stride of 1, 1 8x8 input and 2 64x64 outputs fully unrolled

- conv2d_b 
    2D convolution using a 3x3 filter, stride of 1, 1 64x64 input and 2 64x64 outputs

- maxp_a 
    Maxpool with 2x2 filter and 1 8x8 input

- maxp_b 
    Maxpool with 2x2 filter and 1 32x32 input

- maxp_b_u 
    Maxpool with 2x2 filter and 1 32x32 input fully unrolled

- thxprlsg 
    Mix of tanh, exponential, relu and sigmoid applied to an array with 8 elements
