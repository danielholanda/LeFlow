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

import sys, json, misc 

def promoteToGlobal(var_name):
    """ Transforms inputs and temporary variables to global variables """

    # The sequence is gep (optional), load to temps, gep (optional), bitcast to real type
    # We use the following operations to get "temps" in the bitcast to real var
    misc.safelyDelete(ir,var_name,"getelementptr")
    misc.safelyDelete(ir,var_name,"bitcast")
    misc.safelyDelete(ir,var_name,"load")
    misc.safelyDelete(ir,var_name,"getelementptr")

    if var_name=="temps":
    	var_name_initializer="@temp"
    elif var_name=="params":
    	var_name_initializer="@param"

    
    # Transform bitcast to temps into global variables
    keep_looking=True
    var_counter=0
    while keep_looking:
        keep_looking=False
        for instr in ir[:]:
            # Try to find a load to temps
            if ("%"+var_name in instr) and ("bitcast" in instr) and ("metadata" not in instr):
                arg=instr.split()[0]
                arg_type=instr[instr.find(" to ")+4:-2]
                keep_looking=True

                # If found, we then insert them as a global variable and remove it from its previous location
                ir.insert(4,var_name_initializer+str(var_counter)+" = global "+arg_type+" zeroinitializer, align 8\n")
                ir.remove(instr)
                break
        
        # Make sure to update all references to this temporary variable
        if keep_looking:
            for idx,x in enumerate(ir):
                if misc.safeCheckArg(arg,x):
                    misc.safeReplace(ir,arg,var_name_initializer+str(var_counter),idx)

            var_counter=var_counter+1
        
            # Finally, reorder the instructions
            if arg[1:].isdigit():
                misc.instrReorder(ir,instr)

    return var_counter

def processRetval(retval):
    """ Even though we are able to simulate the circuit with modelsim perfectly, the
    memories that we use are not mapped as outputs of the circuit, so Quartus will
    optimize everything away. To avoid this, we return one element of the output 
    array at the end of the computation. [A more elegant solution might exist]
    """

    # First, remove Tensorflow's Retval
    # The sequence is either store OR bitcast, store
    misc.safelyDelete(ir,"retval","bitcast")
    for idx,instr in enumerate(ir):
        if "retval" in instr:
            ir.pop(idx)
            break

    returning_single_native=False
    # Then, get the text of the return value
    for idx,instr in enumerate(ir):
        if "@"+retval in instr:
            if "[" not in instr:
                # We are only returning a single variable
                returning_single_native=True
                retval_text=instr[:]
                break
            else:
                retval_text = instr[instr.find("["):instr.rfind("]")+1]
            break

    # Get the dataype and dimension
    retval_dataType=misc.getDataType(instr)
    retval_dim=retval_text.count("[")
    if returning_single_native:
        retval_text=retval_dataType

    for idx,instr in enumerate(ir):
        # Make sure that main instruction is returning the right datatype
        if "define void" in ir[idx]:
            ir[idx]=ir[idx].replace("define void","define "+retval_dataType)
        
        # Return the first element of the output array.
        # This is not important for modelsim, but it is important to don't get computations optimized away in Quartus
        if "ret void" in ir[idx]:
            ir[idx]=ir[idx].replace("ret void","ret "+retval_dataType+" %leflow_retval")
            ir.insert(idx, "  %leflow_retval = load volatile "+retval_dataType+"* %leflow_gep, align 4"+"\n")
            ir.insert(idx, "  %leflow_gep = getelementptr inbounds "+retval_text+"* @"+retval+", i64 0"*(retval_dim+1)+"\n")
            break

def removeArgs(l,r):
    """ Used to remove specific parameters from the main function """
    args=l[l.find("(")+1:l.rfind(")")]
    args=[x.strip() for x in args.split(',')]
    new_l=l[:l.find("(")+1]
    removeLastComma=False
    for idx,arg in enumerate(args):
        if r not in arg:
            new_l=new_l+args[idx]+", "
            removeLastComma=True
    if removeLastComma:
        new_l=new_l[:-2]+l[l.rfind(")"):]
    else:
        new_l=new_l+l[l.rfind(")"):]
    return new_l


def restructureMainFunction(l):
    """ Changes the function signature by removing unnecessary parameters """

    # Force first function to be the main function
    l=l[0:l.find("@")+1]+"main"+l[l.find("("):]

    # Removing params from the main function (it will be transformed to a global variable)
    l=removeArgs(l,'params')

    # We also remove temps, since it will also be transformed to a global variable
    l=removeArgs(l,'temps')

    # We also remove retval, since it will also be transformed to a global variable
    l=removeArgs(l,'retval')

    # Remove unsupported/unused parameters
    l=removeArgs(l,'prof_counters')
    l=removeArgs(l,'run_options')

    return l

def processReturnStores(return_value):
    """ This will transform stores to the return value to volatiles
    This guarantees that the output memory is not optimized away"""
    prev_instr=""
    for idx,curr_instr in enumerate(ir):
        if ((misc.safeCheckArg(return_value,prev_instr) and ("getelementptr" in prev_instr)) or (misc.safeCheckArg(return_value,curr_instr))) and "store" in curr_instr:
        #if return_value in prev_instr and "getelementptr" in prev_instr and "store" in curr_instr:
            ir[idx]=ir[idx].replace("store","store volatile")
        prev_instr=curr_instr[:]

    # Save return value to json file to be used later
    file = open(output_folder+'argsAndTemps.json', 'w+')
    data = { "return_value": return_value }
    json.dump(data, file)

def processArgLoads():
    """ Make all loads to arguments volatile, so inputs are not optimized away """
    prev_instr=""
    for idx,curr_instr in enumerate(ir):
        # getelementptr with arguments are always followed by loads
        if (("param" in prev_instr and "getelementptr" in prev_instr) or ("param" in curr_instr))  and "load" in curr_instr:
            ir[idx]=ir[idx].replace("load","load volatile")
        prev_instr=curr_instr[:]

if __name__ == '__main__':
    # Receive input and output files
    input_file=sys.argv[1]
    output_file=sys.argv[2]
    output_folder=misc.getFolder(output_file)

    # We will cache all file in an list to make it simpler to move information around
    ir=misc.readIR(input_file)

    # Make sure that first function is main function and restructure it properly
    idx = [i for i, s in enumerate(ir) if 'define' in s]
    ir[idx[0]] = restructureMainFunction(ir[idx[0]])

    # Insert blank line between globals and main
    ir.insert(4,"\n")

    # Promote all arguments associated with %params to a global variable
    promoteToGlobal("params")

    # Promote array to temporary buffers to a global variable
    num_temps = promoteToGlobal("temps")

    # Makes sure that we are returning volatile stores, so they are not optimized away
    processReturnStores("temp"+str(num_temps-1))

    # Make all loads to arguments volatile, so inputs are not optimized away
    processArgLoads()

    # Remove Tensorflow's retval and return correct output
    processRetval("temp"+str(num_temps-1))

    # Writting back the IR into the verilog file
    misc.writeIR(ir,output_file)
