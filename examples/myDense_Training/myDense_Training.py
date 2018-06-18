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
n_input = 2
n_hidden = 5
n_output = 2


# Store layers weight & bias
weights = {
    'h1': tf.Variable(tf.random_normal([n_input, n_hidden])),
    'h2': tf.Variable(tf.random_normal([n_hidden, n_output])),
}
biases = {
    'b1': tf.Variable(tf.random_normal([n_hidden])),
    'b2': tf.Variable(tf.random_normal([n_output])),
}

print(weights)

print(biases)

# tf Graph input
X = tf.placeholder("float", [None, n_input])
Y = tf.placeholder("float", [None, n_output])

sess = tf.InteractiveSession()

# Desired input output mapping of XOR function:
x_ = [[-1, -1], [-1, 1], [1, -1], [1, 1]] # input
#labels=[0,      1,      1,      0]   # output =>
expect=[[1,0],  [0,1],  [0,1], [1,0]] # ONE HOT REPRESENTATION! 'class' [1,0]==0 [0,1]==1

# x = tf.Variable(x_)
x = tf.placeholder("float", [None,2]) #  can we feed directly?
y_ = tf.placeholder("float", [None, 2]) # two output classes


hidden  = tf.nn.tanh(tf.matmul(x,weights['h1']) + biases['b1']) # first layer.
hidden2 = tf.matmul(hidden, weights['h2'])#+b2
y = tf.nn.softmax(hidden2)

# Define loss and optimizer
cross_entropy = -tf.reduce_sum(y_*tf.log(y))
train_step = tf.train.GradientDescentOptimizer(0.2).minimize(cross_entropy)

# Train
tf.initialize_all_variables().run()
for step in range(2000):
    feed_dict={x: x_, y_:expect } # feed the net with our inputs and desired outputs.
    e,a=sess.run([cross_entropy,train_step],feed_dict)
    print(a)
    #if e<1:break # early stopping yay
    print "step %d : entropy %s" % (step,e) # error/loss should decrease over time

print(weights['h1'].eval())
print(weights['h2'].eval())
print(biases['b1'].eval())

# Test trained model
correct_prediction = tf.equal(tf.argmax(y,1), tf.argmax(y_,1)) # argmax along dim0
accuracy = tf.reduce_mean(tf.cast(correct_prediction, "float")) # [True, False, True, True] -> [1,0,1,1] -> 0.75.

print "accuracy %s"%(accuracy.eval({x: x_, y_: expect}))

learned_output=tf.argmax(y,1)
print learned_output.eval({x: x_})
