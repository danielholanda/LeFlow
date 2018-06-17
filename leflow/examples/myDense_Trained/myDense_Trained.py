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
n_hidden_1 = 5 
n_input = 2 
n_classes = 2 


'''
# Store layers weight & bias
weights = {
    'h1': tf.Variable(tf.random_normal([n_input, n_hidden_1])),
    'out': tf.Variable(tf.random_normal([n_hidden_1, n_classes]))
}
biases = {
    'b1': tf.Variable(tf.random_normal([n_hidden_1])),
    'out': tf.Variable(tf.random_normal([n_classes]))
}
'''

# Store layers weight & bias
weights = {
    'h1': tf.Variable([[-1.7708158,   1.6874832,  -1.1724135,   0.93031096, -2.2534292 ], [ 1.0524354,   1.6816291,   2.0460334,  -1.907349,    1.6214348 ]]),
    'out': tf.Variable([[-1.9175612,  0.7792746], [-4.740492 ,  2.5802624], [ 1.3988725, -2.6182756], [-1.5541346,  2.0807438], [-2.4264903,  2.5256603]])
}
biases = {
    'b1': tf.Variable([-0.98059285,  2.3971937,   1.0682157,  -0.842587 ,  -1.5339919 ]),
}

print(weights)

print(biases)

# tf Graph input
X = tf.placeholder("float", [None, n_input])
Y = tf.placeholder("float", [None, n_classes])

reshaped_input_array = [[[-1,-1]],[[-1,1]],[[1,-1]],[[1,1]]]

with tf.Session() as sess:
    sess.run(tf.global_variables_initializer())
    
    with tf.device("device:XLA_CPU:0"):
    	layer_1=tf.nn.tanh(tf.add(tf.matmul(X, weights['h1']), biases['b1']))
    	layer2 = tf.matmul(layer_1, weights['out'])
        y = tf.nn.softmax(layer2)

    for i in xrange(4):
        sess.run(tf.global_variables_initializer())
        result = sess.run(y,{X: reshaped_input_array[i]})
        print(result)





























