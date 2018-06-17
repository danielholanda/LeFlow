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


import numpy as np
import matplotlib.pyplot as plt
import processMif as mif

# Read result from modelsim
result=[]
f= open("myMaxpool/memory_dump.txt","r+")
for line in f: 
    if "/" not in line:
        result.append(mif.toFloat(line[:-1]))

# Reshape and plot result
first_array=np.reshape(result,[9,9])
plt.imshow(first_array, cmap='gray', interpolation = 'none')
plt.show()

