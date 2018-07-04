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
import matplotlib.image as mpimg
import string
import sys
sys.path.append('../../src')
import processMif as mif

# List of different filters
blur=[[[[ 0.11111111111 ]],[[0.11111111111 ]],[[ 0.11111111111 ]]],[[[ 0.11111111111 ]],[[0.11111111111 ]],[[0.11111111111 ]]],[[[ 0.11111111111 ]],[[ 0.11111111111]],[[ 0.11111111111]]]]
edge=[[[[ -1. ]],[[-1. ]],[[ -1. ]]],[[[ -1. ]],[[8.1 ]],[[-1. ]]],[[[ -1. ]],[[ -1.]],[[ -1.]]]]
sharpen=[[[[ 0. ]],[[-1. ]],[[ 0. ]]],[[[ -1. ]],[[5. ]],[[-1. ]]],[[[ 0. ]],[[ -1.]],[[ 0.]]]]
emboss=[[[[ -2. ]],[[-1. ]],[[ 0. ]]],[[[ -1. ]],[[1. ]],[[1. ]]],[[[ 0. ]],[[ 1.]],[[ 2.]]]]
top_sobel=[[[[ 1. ]],[[2. ]],[[ 1. ]]],[[[ 0. ]],[[0. ]],[[0. ]]],[[[ -1. ]],[[ -2.]],[[ -1.]]]]
left_sobel=[[[[ 1. ]],[[0. ]],[[ -1. ]]],[[[ 2. ]],[[0. ]],[[-2. ]]],[[[ 1. ]],[[ 0.]],[[ -1.]]]]

selected_filters=np.reshape(np.array([sharpen,emboss,edge,top_sobel,left_sobel]).transpose(),[3,3,1,5])

# Here you can select one of the filters to play with
weights=selected_filters
num_outputs=len(np.array(weights).flatten())/9
weights_tensor=tf.Variable(tf.convert_to_tensor(weights, dtype=tf.float32))

# Placeholder for graph input
X = tf.placeholder(tf.float32, [1, 512,512,1])
img=mpimg.imread('lenna.png')
original_image=np.reshape(img,[1,512,512,1])


with tf.Session() as sess:

	# Generating circuit
    with tf.device("device:XLA_CPU:0"):
        y = tf.nn.conv2d(X, weights_tensor, strides=[1, 1, 1, 1], padding='SAME')
    sess.run(tf.global_variables_initializer())
    result = sess.run(y,{X: original_image})
    print(result)

    # Plotting result
    result = np.reshape(result,[512,512,num_outputs])
    fig, axs = plt.subplots(2, 3, sharex=True,sharey=True)
    axs[0,0].imshow(img,cmap='gray')
    axs[0,0].axis('off')
    fig.subplots_adjust(hspace=0,wspace=0,right=1,top=1,left=0,bottom=0)
    axs[0,0].text(.9, 0.9, string.ascii_uppercase[0], transform=axs[0,0].transAxes, 
            size=20, weight='bold',color='white')
    for i in range(1, num_outputs+1):
         axs[i/3,i%3].imshow(np.clip(result[:,:,i-1], 0, 1),cmap='gray')
         axs[i/3,i%3].axis('off')
         fig.subplots_adjust(hspace=0,wspace=0,right=1,top=1,left=0,bottom=0)
         axs[i/3,i%3].text(.9, 0.9, string.ascii_uppercase[i], transform=axs[i/3,i%3].transAxes, 
            size=20, weight='bold',color='white')
    plt.show()

    # Generate test memory
    mif.createMem([original_image,weights])



    


















