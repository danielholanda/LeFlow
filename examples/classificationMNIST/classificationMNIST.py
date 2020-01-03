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

import tensorflow
import numpy as np
from tensorflow.examples.tutorials.mnist import input_data
import sys
sys.path.append('../../src')
import processMif as mif

tensorflow.logging.set_verbosity(tensorflow.logging.ERROR)

# Load the MNIST data set
mnist_data = input_data.read_data_sets("./MNIST_data/", one_hot=True)

# The basic MLP graph
x = tensorflow.placeholder(tensorflow.float32, shape=[None, 784])
W = tensorflow.Variable(tensorflow.zeros([784, 10]))
b = tensorflow.Variable(tensorflow.zeros([10]))
y = tensorflow.nn.softmax(tensorflow.add(tensorflow.matmul(x, W),b))

# The placeholder for the correct result
real_y = tensorflow.placeholder(tensorflow.float32, [None, 10])

# Loss function
cross_entropy = tensorflow.reduce_mean(-tensorflow.reduce_sum(
    real_y * tensorflow.log(y), axis=[1])
)

# Optimization
optimizer = tensorflow.train.GradientDescentOptimizer(0.5)
train_step = optimizer.minimize(cross_entropy)

# Initialization
init = tensorflow.global_variables_initializer()

# Starting Tensorflow XLA session
with tensorflow.Session() as session:

    # Training using MNIST dataset
    epochs = 1000
    session.run(init)
    for _ in range(epochs):
        batch_x, batch_y = mnist_data.train.next_batch(100)
        session.run(train_step, feed_dict={x: batch_x, real_y: batch_y})
    correct_prediction = tensorflow.equal(tensorflow.argmax(y, 1), tensorflow.argmax(real_y, 1))
    accuracy = tensorflow.reduce_mean(tensorflow.cast(correct_prediction, tensorflow.float32))
    network_accuracy = session.run(accuracy, feed_dict={x: mnist_data.test.images, real_y: mnist_data.test.labels})
    print('The accuracy over the MNIST data is {:.2f}%'.format(network_accuracy * 100))
 
    # Generating hardware  
    with tensorflow.device("device:XLA_CPU:0"):
        y = tensorflow.nn.softmax(tensorflow.add(tensorflow.matmul(x, W)[0], b))
    session.run(y,{x: [mnist_data.test.images[123]]})

    # Creating memories for testing
    test_image=123
    mif.createMem([b.eval(),W.eval(),mnist_data.test.images[test_image]])

    # Print expected result
    print("Expected Result: "+str(np.argmax(mnist_data.test.labels[test_image])))
