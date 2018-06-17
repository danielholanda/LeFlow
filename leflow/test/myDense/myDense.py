import tensorflow as tf
import numpy as np

tf.logging.set_verbosity(tf.logging.INFO)


# Network Parameters
n_input = 15
n_output=10


# Store layers weight & bias
weights = {
    'h1': tf.Variable(tf.random_normal([n_input, n_output])),
}
biases = {
    'b1': tf.Variable(tf.random_normal([n_output])),
}


# tf Graph input
X = tf.placeholder(tf.float32, [None, n_input])


# matmul must be an array of arrays but add can only be one array 
with tf.Session() as sess:
    with tf.device("device:XLA_CPU:0"):
    	aux = tf.matmul(X, weights['h1'])
    	y = tf.add(biases['b1'], aux[0])

    sess.run(tf.global_variables_initializer())
    result = sess.run(y,{X: [[3.]*n_input]})
    print(result)



    


















