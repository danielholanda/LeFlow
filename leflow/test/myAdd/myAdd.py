import tensorflow as tf
import numpy as np

tf.logging.set_verbosity(tf.logging.INFO)

with tf.Session() as sess:
	x = tf.placeholder(tf.int32)
	with tf.device("device:XLA_CPU:0"):
		y = tf.add(x, x)
	result = sess.run(y, {x: 6})
	print(result)
