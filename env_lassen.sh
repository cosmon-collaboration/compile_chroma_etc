module load cuda/12.0.0
module load cmake/3.21.1
module load gcc/12.2.1
module load ninja/1.9.0

HDF5=hdf5-1.10.9
CXX=mpicxx
CC=mpicc
CHROMA_SRC=chroma
CHROMA=chroma_gpu
#CHROMA_CPU=chroma_cpu

QUDA_SRC=quda
QUDA=quda
export QUDA_GPU_ARCH=sm_70
export QUDA_TARGET_TYPE="CUDA"

QMP=qmp
QDP_SRC=qdpxx
QDP=qdpxx
LALIBE_SRC=lalibe
#LALIBE_CPU=lalibe_cpu
LALIBE=lalibe_gpu

CC=mpicc
CXX=mpicxx

HDF5=hdf5-1.10.9
H5_ONOFF=ON

#echo "Stack ${1}"
#if [ "$1" = "H5" ]; then
#  H5=ON
#  CHROMA=chroma_H5
#  QDP=qdpxx_H5
#  QUDA=quda_H5
#  LALIBE_CPU=lalibe_H5
#  LALIBE=lalibe_gpu_H5
   
#fi
#echo "Using/Setting up stack: ${CHROMA} ${QDP} ${QMP} ${QUDA}  Srcs: ${CHROMA_SRC} ${QUDA_SRC}"

export TOPDIR_HIP=/usr/workspace/coldqcd/software/lassen_smpi_RR_hm/software/lassen
export PERMFIX=${TOPDIR_HIP}/./coldqcd_permissions.sh
export SRCROOT=${TOPDIR_HIP}/../source
export BUILDROOT=${TOPDIR_HIP}/../build
export INSTALLROOT=${TOPDIR_HIP}/../install

[[ -d $INSTALLROOT ]] || mkdir -p $INSTALLROOT
[[ -d $BUILDROOT ]] || mkdir -p $BUILDROOT
[[ -d $SRCROOT ]] || mkdir -p $SRCROOT

export LD_LIBRARY_PATH=${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}
export LD_LIBRARY_PATH=${INSTALLROOT}/${QMP}/lib:${LD_LIBRARY_PATH}
export LD_LIBRARY_PATH=${INSTALLROOT}/${HDF5}/lib:${LD_LIBRARY_PATH}
export LD_LIBRARY_PATH=${INSTALLROOT}/${QDP}/lib:${LD_LIBRARY_PATH}
export LD_LIBRARY_PATH=${INSTALLROOT}/${QUDA}/lib:${LD_LIBRARY_PATH}
export LD_LIBRARY_PATH=${INSTALLROOT}/${CHROMA}/lib:${LD_LIBRARY_PATH}

#export CUDA_HOME=$CUDA_DIR
export CUDA_DIR=$CUDA_HOME
export MPI_HOME=$MPI_ROOT
