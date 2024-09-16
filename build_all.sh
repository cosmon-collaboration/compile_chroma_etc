#!/usr/bin/bash

#Builds a CPU stack
./build_qmp.sh CPU
./build_hdf5.sh CPU
./build_qdpxx.sh CPU
./build_chroma.sh CPU
./build_lalibe.sh CPU

# BUILD a GPU stack
./build_qmp.sh
./build_hdf5.sh
./build_qdpxx.sh
if [[ `hostname -f` == *"summit"* ]]; then
    echo "you have to submit run_build_quda_summit.sh to build QUDA on compute node"
    exit
fi
./build_quda.sh
./build_chroma.sh
./build_lalibe.sh
