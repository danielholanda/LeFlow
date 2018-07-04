#-----------------------------------------------------------------------------
# Copyright (c) 2018 Daniel Holanda Noronha, Bahar Salehpour, Steve Wilton
# danielhn<at>ece.ubc.ca
#
# Permission to use, copy, and modify this software and its documentation is
# hereby granted only under the following terms and conditions. Both the
# above copyright notice and this permission notice must appear in all copies
# of the software, derivative works or modified versions, and any portions
# thereof, and both notices must appear in supporting documentation.
# This software may be distributed (but not offered for sale or transferred
# for compensation) to third parties, provided such third parties agree to
# abide by the terms and conditions of this notice.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHORS, AS WELL AS THE UNIVERSITY
# OF BRITISH COLUMBIA DISCLAIM ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
# INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO 
# EVENT SHALL THE AUTHORS OR THE UNIVERSITY OF BRITISH COLUMBIA BE LIABLE
# FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR
# IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#---------------------------------------------------------------------------

import tensorflow as tf
import numpy as np
import matplotlib.pyplot as plt
import sys, random
sys.path.append('../../src')
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
