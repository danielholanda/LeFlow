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


import sys, re, os, inspect, shutil, misc

def getArrayInfo(partition_name):
    """ Returns the array dimensions and the datatype """
    for instr in ir:
        if "@"+partition_name+" =" in instr:
            dim =  re.findall('\[(.*?\d+)', instr)
            dataType=misc.getDataType(instr)
            return [ int(x) for x in dim ], dataType

def getConfig(ir, memconfig_file_path):
    """ Gets the arrays to be partitioned from the memconfig file """
    if not os.path.isfile(memconfig_file_path):
        print("\tUser did not specify any arrays to partition")
        return []

    configFile = open(memconfig_file_path,'r')
    partitions=[]
    while True:
        # Read line by line and exit when done
        line = configFile.readline()
        if not line:
            break
        partition = line.split()[0]
        dimention_to_partition= line.split()[1]
        settings = line.split()[2:]
        partitions.append([partition,dimention_to_partition,settings])
    return partitions

def generateDimText(dim,dataType):
    """ This is used to generate a string with the new dimensions of the array """
    text=""
    for d in dim:
        text=text+" ["+str(d)+" x"
    text=text+" "+dataType+("]"*len(dim))
    return text


def createPartitions(partition_name,partition_values,partition_dim,dataType):
    """ This is used to create a global partition at the top of the IR file"""
    for idx,instr in enumerate(ir):
        if "@"+partition_name+" =" in instr:
            del ir[idx]
            for i in range(len(partition_values)):
                print("\tCreating partition "+partition_name+"_sub"+str(i))
                dim_text=generateDimText(partition_dim[i],dataType)
                ir.insert(idx,"@"+partition_name+"_sub"+str(i)+" = global"+dim_text+" zeroinitializer, align 8\n")
            break    

def updateGEP(partition_name,partition_values,partition_dim,dataType,partitioned_dim):
    """ All getelementptr operations associated with the original array need to be updated when a new partition is created """
    for idx,instr in enumerate(ir):
        if "@"+partition_name+"," in instr and "getelementptr"in instr:

            # Get the current which indexes of this array are being used in this instruction
            current_indexes=re.findall('\i64 (.*?)[,\s]', instr)[1:]
            
            # Now lets try to find out the subarray that this index belongs to
            for part_idx,_ in enumerate(partition_values):
                if current_indexes[partitioned_dim].isdigit():
                    if int(current_indexes[partitioned_dim]) in partition_values[part_idx]:
                        subarray_idx=part_idx
                        break
                else:
                    print("\tUnable to partition "+partition_name+" - Please unroll it first")
                    shutil.copyfile(sys.argv[1],sys.argv[2])
                    exit()

            # replace the array name
            ir[idx]=ir[idx].replace("@"+partition_name+",","@"+partition_name+"_sub"+str(subarray_idx)+",")

            # replace array dimension
            dim_text=generateDimText(partition_dim[subarray_idx],dataType)
            ir[idx]=ir[idx][:ir[idx].find("[")-1]+dim_text+ir[idx][ir[idx].find("*"):]

            # replace array index
            new_indexes=" i64 0"
            for i in range(len(partition_dim[0])):
                if i == partitioned_dim:
                    for p in partition_values:
                        if int(current_indexes[i]) in p:
                            current_partition=p[:]
                            break
                    new_indexes=new_indexes+", i64 "+str(current_partition.index(int(current_indexes[i]))) 
                else:
                    new_indexes=new_indexes+", i64 "+current_indexes[i].replace(',','')
            ir[idx]=re.findall('(.*@\S*,)',ir[idx])[0] + new_indexes +"\n"

def partitionMemories(ir):
    """ Loop though all partitions (we might want to partition multiple memories of the same program) """
    for mems in partitions:
        partition_name=mems[0]
        dimention_to_partition=int(mems[1])
        settings=mems[2:][0]
        dim, dataType = getArrayInfo(partition_name)

        # Settings for fully partitioning
        if settings[0]=='*':
            print("\tFully partitioning array "+partition_name)
            partition_values=[[x] for x in xrange(dim[dimention_to_partition])]

        # Settings for block and cyclic partitions
        elif settings[0]=="b" or settings[0]=="c":
            blocks=int(settings[1])
            if blocks<1:
                blocks=1
            elif blocks>dim[dimention_to_partition]:
                blocks=dim[dimention_to_partition]

            # Splitting the array in blocks
            if settings[0]=="b":
                print("\tPartitioning array "+partition_name+" in "+str(blocks)+" blocks of memory")
                k, m = divmod(dim[dimention_to_partition], blocks)
                partition_values = [range(i*k+min(i, m),(i+1)*k+min(i+1,m)) for i in xrange(blocks)]

            # Splitting the array cyclically
            elif settings[0]=="c":
                print("\tPartitioning array "+partition_name+" in "+str(blocks)+" memories cyclically")
                partition_values = [range(dim[dimention_to_partition])[i::blocks] for i in xrange(blocks)]

        partition_dim=[dim[:dimention_to_partition]+[len(x)]+dim[dimention_to_partition+1:] for x in partition_values]
        createPartitions(partition_name,partition_values,partition_dim,dataType)
        updateGEP(partition_name,partition_values,partition_dim,dataType,dimention_to_partition)


if __name__ == '__main__':
    # Receive input and output files
    input_file=sys.argv[1]
    output_file=sys.argv[2]
    memconfig_file_path=sys.argv[3]

    # We will cache all file in an list to make it simpler to move information around
    ir=misc.readIR(input_file)

    # Get partition config
    partitions = getConfig(ir, memconfig_file_path)

    # Partition the IR
    partitionMemories(ir)

    # Write output file
    misc.writeIR(ir, output_file)
