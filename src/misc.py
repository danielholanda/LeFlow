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

import sys, json

def instrReorder(ir,instr):
    """ Reorder other instructions based on a instruction that was removed """

    # Find current and max instruction
    curr_instr=instr.split()[0][1:instr.find("=")-1]
    for i in reversed(ir):
        if i.split():
            if i.split()[0][0]=="%":
                if i.split()[0][1:i.find("=")-1].isdigit():
                    max_instr=i.split()[0][1:i.find("=")-1]
                    break

    # Reorder instructions
    for i in range(int(curr_instr)+1,int(max_instr)+1):
        for idx,j in enumerate(ir):
            if "%"+str(i) in ir[idx]:
                safeReplace(ir,"%"+str(i),"%"+str(i-1),idx)

def safeReplace(ir,old, new, idx):
    """ Safely replace a string in a line of IR """
    ir[idx]=ir[idx].replace(old+" ",new+" ")
    ir[idx]=ir[idx].replace(old+",",new+",")
    ir[idx]=ir[idx].replace(old+"\n",new+"\n")
    ir[idx]=ir[idx].replace(old+")",new+")")

def safeCheckArg(arg, instr):
    """ Checks if arg is in intruction """
    if (arg+" " in instr) or (arg+"," in instr) or (arg+"\n" in instr) or (arg+")" in instr):
        return True
    else:
        return False

def safelyDelete(ir,parameter,key_operation,is_global=False):
    """ Deletes instruction and passes references to the rest of the IR """ 
    keep_looking=True
    while keep_looking:
        keep_looking=False

        # Check if there is a case where the parameter is used that matches the key operation
        for instr in ir:
            if (parameter in instr) and (key_operation in instr) and ("metadata" not in instr):
                instruction_to_process=instr
                keep_looking=True
                break

        # If there is,  
        if keep_looking:
            # Remove that instruction
            ir.remove(instruction_to_process)

            # reconstruct calls 
            for idx,instr in enumerate(ir):
                if instruction_to_process.split()[0] in instr:
                    if is_global:
                        safeReplace(ir,instruction_to_process.split()[0],"@"+parameter,idx)
                    else:
                        safeReplace(ir,instruction_to_process.split()[0],"%"+parameter,idx)
                    

            # and reorder getelementptr
            if instruction_to_process.split()[0][1:].isdigit():
                instrReorder(ir,instruction_to_process)

def getFolder(file):
    """ Gets folder of a specific file """
    if "/" in file:
        return file[:file.rfind("/")+1]
    else:
        return ""

def getDataType(instr):
    """ Returns datatype of variable """
    if "i64" in instr:
        dataType="i64"
    elif "i32" in instr:
        dataType="i32"
    elif "float" in instr:
        dataType="float"
    else:
        print("Could not find data type")
        exit()
    return dataType

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