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
import sys
sys.path.append('../../src')
import processMif as mif

# Configs
image_width=32
image_height=32

#Prepare input array
in_a = np.random.rand(1, image_width, image_height, 1)
mif.createMem([in_a])

with tf.Session() as sess:
	# Create hardware for max pooling
	x = tf.placeholder(tf.float32,[1, image_width, image_height, 1])
	with tf.device("device:XLA_CPU:0"):
		y=tf.layers.max_pooling2d(inputs=x, pool_size=[3, 3], strides=3)
	result = sess.run(y,{x: in_a})
	np.save("tf_result.npy" ,result)
	print(result)

