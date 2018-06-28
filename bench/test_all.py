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


import subprocess, os, time, sys
sys.path.append('../src')
import processMif as mif
import numpy as np

# Used for supressing silly messages
FNULL = open(os.devnull, 'w')

start_time = time.time()

test_folders = ['01_vecmul_a']

test_dir = os.getcwd() 

for folder in test_folders:
    print("\nRunning test for {}".format(folder))

    os.chdir("./{}/".format(folder))

    #Generate Circuit
    print("\tGenerating the circuit...")
    command = "../../src/LeFlow {}.py".format(folder, folder)
    leflow_process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=None, shell=True)
    leflow_output = leflow_process.communicate()

    leflow_output = leflow_output[0].splitlines()
    for line in leflow_output:
        if "DONE" in line:
            print("\t\tFinished generating circuit") 

    # Generate mems and test with tensorflow
    print("\tGenerating new inputs and running Tensorflow with them...")
    command = "/usr/bin/python {}.py".format(folder, folder)
    leflow_output = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=FNULL, shell=True).communicate()

    leflow_output = leflow_output[0].splitlines()
    for line in leflow_output:
        if "DONE" in line:
            print("\t\tFinished generating circuit") 

    # Move inputs to right folder
    command = "cp "+folder+"_files/tfArgs/param*.mif "+folder+"_files/".format(folder, folder)
    leflow_process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=None, shell=True)

    #start modelsim
    print("\tTesting circuit using Modelsim with new inputs...")
    command = "make v -C {}_files".format(folder)
    modelsim_process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=None, shell=True)
    modelsim_output = modelsim_process.communicate()

    modelsim_output = modelsim_output[0].splitlines()
    for line in modelsim_output:
        if "Cycles" in line:
            cycles = line.split()[-1]
            print("\t\tClock cycles required: {}".format(cycles))


    modelsim_result = np.array(mif.getModelsimMem(folder+"_files/memory_dump.txt"))
    tensorflow_result = np.load("tf_result.npy")
    print("\tResults match: "+str(np.array_equal(modelsim_result, tensorflow_result)))
    
    os.chdir(test_dir)


end_time = time.time()
total_time = end_time - start_time
print("Testing was done in {} seconds".format(round(total_time, 2)))
            
