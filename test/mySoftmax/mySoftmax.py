import tensorflow as tf
import numpy as np

tf.logging.set_verbosity(tf.logging.INFO)

with tf.Session() as sess:
	x = tf.placeholder(tf.float32,[4])
	with tf.device("device:XLA_CPU:0"):
		y=tf.nn.softmax(x)
	result = sess.run(y, {x: [1.,3.,5.,2.]})
	print(result)
