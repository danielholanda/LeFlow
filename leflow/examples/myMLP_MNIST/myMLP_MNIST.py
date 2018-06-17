#-----------------------------------------------------------------------------
#Copyright (c) 2018 Daniel Holanda Noronha, Bahar Salehpour, Steve Wilton
#{danielhn,bahars,stevew}@ece.ubc.ca
#Permission to use, copy, and modify this software and its documentation is
#hereby granted only under the following terms and conditions. Both the
#above copyright notice and this permission notice must appear in all copies
#of the software, derivative works or modified versions, and any portions
#thereof, and both notices must appear in supporting documentation.
#This software may be distributed (but not offered for sale or transferred
#for compensation) to third parties, provided such third parties agree to
#abide by the terms and conditions of this notice.
#THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHORS, AS
#WELL AS THE UNIVERSITY OF BRITISH COLUMBIA DISCLAIM ALL
#WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING ALL IMPLIED
#WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
#AUTHORS OR THE UNIVERSITY OF BRITISH COLUMBIA OR THE
#UNIVERSITY OF SYDNEY BE LIABLE FOR ANY SPECIAL, DIRECT,
#INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
#WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR
#PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE
#OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION
#WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#---------------------------------------------------------------------------


import tensorflow as tf
import numpy as np

tf.logging.set_verbosity(tf.logging.INFO)

# Network Parameters
n_input = 784 # MNIST data input (img shape: 28*28 = 784)
n_hidden_1 = 90 # 1st layer number of neurons 
n_hidden_2 = 50 # 2nd layer number of neurons 
n_classes = 10 # MNIST total classes (0-9 digits)


# Store layers weight & bias
weights = {
    'h1': tf.Variable(tf.random_normal([n_input, n_hidden_1])),
    'h2': tf.Variable(tf.random_normal([n_hidden_1, n_hidden_2])),
    'out': tf.Variable(tf.random_normal([n_hidden_2, n_classes]))
}
biases = {
    'b1': tf.Variable(tf.random_normal([n_hidden_1])),
    'b2': tf.Variable(tf.random_normal([n_hidden_2])),
    'out': tf.Variable(tf.random_normal([n_classes]))
}

print(weights)

print(biases)

# tf Graph input
X = tf.placeholder("float", [1, n_input])
Y = tf.placeholder("float", [None, n_classes])


image_width=n_input
shape=[1, image_width] #[batch_size, inputs]
input_array = np.random.random_sample((image_width,))
print(input_array)
reshaped_input_array = np.reshape(input_array, shape)

# For some reason we are not able to add batches with XLA (ex: [[2,4],[2,7]]+[[4,7],[5,3]])
with tf.Session() as sess:
    with tf.device("device:XLA_CPU:0"):
    	layer_1=tf.reshape(tf.add(tf.matmul(X, weights['h1'])[0], biases['b1']),[1,n_hidden_1])
        layer_2 = tf.reshape(tf.add(tf.matmul(layer_1, weights['h2'])[0], biases['b2']),[1,n_hidden_2])
    	y = tf.matmul(layer_2, weights['out'])[0] + biases['out']

    sess.run(tf.global_variables_initializer())
    result = sess.run(y,{X: reshaped_input_array})
    print(result)





























