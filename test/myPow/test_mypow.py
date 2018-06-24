#Running tests on myAdd  myDense  myMaxpool  myMaxpoolPartition  myPow  mySoftmax  myVecMul
import subprocess
import os
import sys
import struct

def toFloat(num):
    return struct.unpack('!f', num.decode('hex'))[0]

###############################################################################
# Test 1
###############################################################################

print("\nINFO: Running first test for myPow")

command = "cp myPow1.py myPow.py"
leflow_process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=None, shell=True)


#start leflow
print("INFO: Generate Hardware...")
command = "../../src/LeFlow myPow.py"
leflow_process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=None, shell=True)
leflow_output = leflow_process.communicate()

print("INFO: Generate mif file...")
command = "python myPow.py"
tensorflow_process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=None, shell=True)
tensorflow_output = tensorflow_process.communicate()
tensorflow_output = tensorflow_output[0].splitlines()
expected_output_1 = []
for line in tensorflow_output:
    expected_output_1.append(float(line))
print(expected_output_1)

command = "cp myPow_files/tfArgs/param0.mif myPow_files/"
copy_process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=None, shell=True)

print("INFO: Generate memory_dump.txt...")
command = "make v -C myPow_files"
modelsim_process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=None, shell=True)
modelsim_output = modelsim_process.communicate()

print("INFO: Read output of memory_dump.txt...")
with open('myPow_files/memory_dump.txt',"r") as f:
    actual_output_1 = []
    for line in f.readlines():
        if "/" not in line:
            actual_output_1.append((toFloat(line[:-1])))
print(actual_output_1)

if expected_output_1 == actual_output_1:
    print("INFO: Test 1 passed.")
else:
	print("ERROR: Test 1 failed.")

###############################################################################
# Test 2
###############################################################################
print('***************************')
print("\nINFO: Running second test for myPow")

command = "cp myPow2.py myPow.py"
leflow_process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=None, shell=True)

print("INFO: Generate mif file...")
command = "python myPow.py"
tensorflow_process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=None, shell=True)
tensorflow_output = tensorflow_process.communicate()
tensorflow_output = tensorflow_output[0].splitlines()
expected_output_2 = []
for line in tensorflow_output:
    expected_output_2.append(float(line))
print(expected_output_2)

command = "cp myPow_files/tfArgs/param0.mif myPow_files/"
copy_process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=None, shell=True)

print("INFO: Generate memory_dump.txt...")
command = "make v -C myPow_files"
modelsim_process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=None, shell=True)
modelsim_output = modelsim_process.communicate()

print("INFO: Read output of memory_dump.txt...")
with open('myPow_files/memory_dump.txt',"r") as f:
    actual_output_2 = []
    for line in f.readlines():
        if "/" not in line:
            actual_output_2.append((toFloat(line[:-1])))
print(actual_output_2)

if expected_output_2 == actual_output_2:
    print("INFO: Test 2 passed.")
else:
    print("ERROR: Test 2 failed.")


print("DONE")	
