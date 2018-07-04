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


#!/usr/bin/env python
import numpy as np
import struct, inspect, os, sys

def setUnrollThreshold(threshold):
    """ This allows the user to set the unroll threshold at the python level """

    # Gets name of circuit that is being generated
    project_folder = inspect.getmodule(inspect.stack()[1][0]).__file__.replace(".py","")+"_files/"
    if not os.path.exists(project_folder+"leflowOptions/"):
        os.makedirs(project_folder+"leflowOptions/")

    # Create file
    f= open(project_folder+"leflowOptions/unrollThreshold.txt","w+")
    f.write(str(threshold))
    f.close()

def getUnrollThreshold(project_folder):
    """ This is used internally to get the unroll threshold set by the user """

    if not os.path.isfile(project_folder+"leflowOptions/unrollThreshold.txt"):
        return "0"
    else:
        f= open(project_folder+"leflowOptions/unrollThreshold.txt","r+")
        threshold=f.readline()
        f.close()
        print"Using used-defined unroll threshold = "+threshold
        return threshold

def setInlineThreshold(threshold):
    """ This allows the user to set the inline threshold at the python level """

    # Gets name of circuit that is being generated
    project_folder = inspect.getmodule(inspect.stack()[1][0]).__file__.replace(".py","")+"_files/"
    if not os.path.exists(project_folder+"leflowOptions/"):
        os.makedirs(project_folder+"leflowOptions/")

    # Create file
    f= open(project_folder+"leflowOptions/inlineThreshold.txt","w+")
    f.write(str(threshold))
    f.close()

def getInlineThreshold(project_folder):
    """ This is used internally to get the inline threshold set by the user """

    if not os.path.isfile(project_folder+"leflowOptions/inlineThreshold.txt"):
        return "0"
    else:
        f= open(project_folder+"leflowOptions/inlineThreshold.txt","r+")
        threshold=f.readline()
        f.close()
        print"Using used-defined inline threshold = "+threshold
        return threshold

def setPartitionMemory(partition_settings):
    """ Used to set an array to be partitioned 
    First argument:     Array to be partitioned in terms of the IR
    Second argument:    Dimension to be partitioned
    Third argument:     Partitioning scheme (b: clock, c: cyclic, f: full)
    Fourth argument:    Number of blocks to partition the memory
    """
    # Gets name of circuit that is being generated
    project_folder = inspect.getmodule(inspect.stack()[1][0]).__file__.replace(".py","")+"_files/"
    if not os.path.exists(project_folder+"leflowOptions/"):
        os.makedirs(project_folder+"leflowOptions/")

    # Create file with partition information
    f= open(project_folder+"leflowOptions/membank.config","a")
    f.write(partition_settings)
    f.close()

    # Adds LOCAL_RAMS parameter to the config.tcl file
    f= open(project_folder+"config.tcl","a")
    f.write("\nset_parameter LOCAL_RAMS 1")
    f.close()
