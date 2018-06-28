import tensorflow as tf
import numpy as np
import matplotlib.pyplot as plt
import sys, random
sys.path.insert(0, '/home/danielhn/leflow/src')
import additionalOptions as options

# Configs
image_width=10
image_height=10

#Prepare input array
shape=[1, image_width, image_height, 1] #[batch_size, image_width, image_height, channels]
reshaped_input_array = np.reshape([random.random() for x in range(image_width*image_height)], shape)

with tf.Session() as sess:
	# Create hardware for max pooling
	x = tf.placeholder(tf.float32,shape)
	with tf.device("device:XLA_CPU:0"):
		y=tf.layers.max_pooling2d(inputs=x, pool_size=[3, 3], strides=3)
	sess.run(y,{x: reshaped_input_array})


# Setting unroll threshold very high to unroll eveything 
options.setUnrollThreshold(100000000)

# Partition (memory: param0; dimension to partition: 2; type: Fully partition)
#options.setPartitionMemory("param0 2 *")

# Partition (memory: param0; dimension to partition: 2; type: Block; number of memories: 3)
#options.setPartitionMemory("param0 2 b 3")

# Partition (memory: param0; dimension to partition: 2; type: Cyclic; number of memories: 2)
options.setPartitionMemory("param0 2 c 2")