import tensorflow as tf
import numpy as np
import matplotlib.pyplot as plt
import sys 
sys.path.append('../../src')
import processMif as mif
from tensorflow.examples.tutorials.mnist import input_data

# Import MNIST data
mnist_data = input_data.read_data_sets("MNIST_data/", one_hot=True)

# Configs
image_width=28
image_height=28
image_to_test=987

#Prepare input array
shape=[1, image_width, image_height, 1] #[batch_size, image_width, image_height, channels]
reshaped_input_array = np.reshape(mnist_data.test.images[image_to_test], shape)

with tf.Session() as sess:
	# Create hardware for max pooling
	x = tf.placeholder(tf.float32,shape)
	with tf.device("device:XLA_CPU:0"):
		y=tf.layers.max_pooling2d(inputs=x, pool_size=[3, 3], strides=3)
	sess.run(y,{x: reshaped_input_array})

    # Generate test memory
	mif.createMem([reshaped_input_array])

    # Plot original image
	first_array=np.reshape(mnist_data.test.images[image_to_test],[image_width,image_height])
	plt.imshow(first_array, cmap='gray', interpolation = 'none')
	plt.show()
