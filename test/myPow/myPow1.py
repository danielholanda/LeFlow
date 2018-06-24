import tensorflow as tf
import numpy as np
import sys
sys.path.insert(0, '/home/legup/leflow/src')
import processMif as mif
import argparse

tf.logging.set_verbosity(tf.logging.INFO)

with tf.Session() as sess:
    x = tf.placeholder(tf.float32,[3])
    with tf.device("device:XLA_CPU:0"):
        y=x*x


    result = sess.run(y, {x: [3.,5.,6.]}) #number set 1
    for res in result:
        print(res)
    #print(result)



    # Generate test memory
    mif.createMem([np.array([3.,5.,6.])]) #number set 1
