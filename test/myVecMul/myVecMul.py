import tensorflow as tf
import numpy as np

tf.logging.set_verbosity(tf.logging.INFO)
size=256
with tf.Session() as sess:
	x = tf.placeholder(tf.float32,[size])
	z = tf.placeholder(tf.float32,[size])
	with tf.device("device:XLA_CPU:0"):
		y=x*z

	result = sess.run(y, {x: [1.]*size, z: [6.]*size})
	print(result)
