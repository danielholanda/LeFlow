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

def processUnsupported():
    """ Handles some operations that are not supported by LegUp """

    # For some reason, LegUp does not support fcmp uno
    for idx,curr_instr in enumerate(ir):
        if " uno float" in curr_instr and "0.000000e+00" in curr_instr:
            ir[idx]=ir[idx].replace(" uno "," ueq ")

def readIR(input_file):
    """ Reads the IR file and saves it into a variable """
    with open(input_file,'r') as f_in:
        ir=[]
        while True:
            # Read line by line and exit when done
            line = f_in.readline()
            if not line:
                break
            ir.append(line)
        return ir

def writeIR(ir, output_file):
    """ Used to write the IR back to a file after everything has been processed """
    with open(output_file,'w') as f_out:
        for line in ir:
            f_out.write(line)

if __name__ == '__main__':
    # Receive input and output files
    input_file=sys.argv[1]
    output_file=sys.argv[2]

    # We will cache all file in an list to make it simpler to move information aroun
    ir=readIR(input_file)

    processUnsupported()

    # Writting back the IR into the verilog file
    writeIR(ir,output_file)