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


import sys, json, glob, os, shutil


# Adding return value to testbench
def instrumentTestbench():
    file = open(project_folder+'argsAndTemps.json', 'r')
    data = json.load(file)
    for idx,curr_instr in enumerate(ir):
        if "if (finish == 1) begin" in curr_instr:
            ir.insert(idx+1,"        $writememh(\"memory_dump.txt\",top_inst.memory_controller_inst."+data["return_value"]+".ram);\n")
            break

def getFolder(file):
    if "/" in file:
        return file[:file.rfind("/")+1]
    else:
        return ""

def copyParams():
    if os.path.exists(project_folder+"tfArgs/"):
        mifFiles = glob.glob(project_folder+"tfArgs/*.mif")
        for m in mifFiles:
            shutil.copy(m,project_folder)

# Receive input and output files
verilog_file=sys.argv[1]
project_folder = getFolder(verilog_file)

# Open files 
f = open(verilog_file,'r')

# We will cache all file in an list to make it simpler to move information around
ir=[]
while True:
    # Read line by line and exit when done
    line = f.readline()
    if not line:
        break
    ir.append(line)
f.close()

instrumentTestbench()

copyParams()

# Write IR data back to file
f = open(verilog_file,'w')
for line in ir:
    # Process line
    f.write(line)
f.close()
