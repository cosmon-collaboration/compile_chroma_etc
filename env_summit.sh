#!/usr/bin/bash
if [[ ! -z $1 ]]; then
    if [ "$1" = "CPU" ]; then
        EXT=$1
    else
        echo "unrecognized EXT = $EXT [CPU] - exiting"
        exit
    fi
else
    EXT="GPU"
fi
echo "EXT = $EXT"

if [ "$EXT" = "CPU" ]; then
    module load cmake/3.27.7
    module load gcc/12.1.0
    module load openblas/0.3.24-omp
elif [ "$EXT" = "GPU" ]; then
    module load binutils/2.40
    module load cuda/12.2.0
    module load cmake/3.27.7
    module load gcc/12.1.0
    module load openblas/0.3.24-omp
fi
module load ninja/1.11.1
module list

# DIRECTORIES
export TOPDIR_HIP=/ccs/proj/nph162/software/compile_chroma_etc
export PERMFIX=${TOPDIR_HIP}/./nph162_perm_fix.sh
export SRCROOT=${TOPDIR_HIP}/../source
#export BUILDROOT=${TOPDIR_HIP}/../build
export BUILDROOT=/gpfs/alpine2/proj-shared/nph162/software/build_gcc12
export INSTALLROOT=${TOPDIR_HIP}/../install_gcc12

[[ -d $INSTALLROOT ]] || mkdir -p $INSTALLROOT
[[ -d $BUILDROOT ]] || mkdir -p $BUILDROOT
[[ -d $SRCROOT ]] || mkdir -p $SRCROOT

# COMPILE ENV
CXX=mpicxx
CC=mpicc
C_FLAGS="-fopenmp -O3 -std=gnu99 -mcpu=power9 -mtune=power9"
CXX_FLAGS="-fopenmp -O3 -std=c++11 -mcpu=power9 -mtune=power9"
export CMAKE=cmake
export CMAKE_EXTRA_FLAGS="-DCMAKE_EXPORT_COMPILE_COMMANDS=1"
export CMAKE_MAKE_FLAGS="--parallel $(nproc)"

export CUDA_DIR=$CUDA_HOME
export MPI_HOME=$MPI_ROOT

export QUDA_GPU_ARCH=sm_70
export QUDA_TARGET_TYPE="CUDA"

# SRC
QMP=qmp
HDF5=hdf5-1.10.9
QDP=qdpxx
QUDA=quda
CHROMA=chroma
LALIBE=lalibe
# branch
QMP_BRANCH="--branch devel"
QDP_BRANCH="--branch devel"
QUDA_BRANCH="--branch feature/print-mdwf-b5c5"
CHROMA_BRANCH="--branch feature/mdwf-quda-upgrade"
LALIBE_BRANCH="--branch qedm"

# BUILD/INSTALL EXT
# USE $EXT in build scripts

# LD_LIBRARY_PATH
export LD_LIBRARY_PATH=${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}
export LD_LIBRARY_PATH=${INSTALLROOT}/${QMP}_${EXT}/lib:${LD_LIBRARY_PATH}
export LD_LIBRARY_PATH=${INSTALLROOT}/${HDF5}_${EXT}/lib:${LD_LIBRARY_PATH}
export LD_LIBRARY_PATH=${INSTALLROOT}/${QDP}_${EXT}/lib:${LD_LIBRARY_PATH}
if [ "$EXT" = "GPU" ]; then
    export LD_LIBRARY_PATH=${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}
    export LD_LIBRARY_PATH=${INSTALLROOT}/${QUDA}/lib:${LD_LIBRARY_PATH}
fi
export LD_LIBRARY_PATH=${INSTALLROOT}/${CHROMA}_${EXT}/lib:${LD_LIBRARY_PATH}
