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


import sys


# For some reason, LegUp does not support fcmp uno
def processUnsupported():
    for idx,curr_instr in enumerate(ir):
        if " uno float" in curr_instr and "0.000000e+00" in curr_instr:
            ir[idx]=ir[idx].replace(" uno "," ueq ")


# Receive input and output files
input_file=sys.argv[1]
output_file=sys.argv[2]

# Open input and output files 
f_in = open(input_file,'r')
f_out = open(output_file,'w')

# We will cache all file in an list to make it simpler to move information around
ir=[]
while True:
    # Read line by line and exit when done
    line = f_in.readline()
    if not line:
        break
    ir.append(line)

processUnsupported()

# Write IR data back to file
for line in ir:
    # Process line
    f_out.write(line)

# Close both files
f_in.close()
f_out.close()
