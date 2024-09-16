#!/usr/bin/bash

source ./env.sh

PKG=$QUDA
PKG_EXT=${QUDA}

pushd ${SRCROOT}

if [[ ! -d $SRCROOT/$PKG ]]; then
    pushd $SRCROOT
    git clone ${QUDA_BRANCH} https://github.com/lattice/quda.git ${PKG}
    popd
fi
$PERMFIX ${PKG}
popd

pushd ${BUILDROOT} 
if [ -d ${PKG_EXT} ];
then
  rm -rf ${PKG_EXT}
fi

mkdir  ${PKG_EXT}
cd ${PKG_EXT}

cmake ${SRCROOT}/${PKG} \
  -G "Ninja" \
  -DQUDA_TARGET_TYPE=${QUDA_TARGET_TYPE} \
  -DQUDA_GPU_ARCH=${QUDA_GPU_ARCH} \
  -DCMAKE_INSTALL_PREFIX=${INSTALLROOT}/${PKG_EXT} \
  -DQUDA_DIRAC_CLOVER=ON \
  -DQUDA_DIRAC_DOMAIN_WALL=ON \
  -DQUDA_MDW_FUSED_LS_LIST="8,12,16,20" \
  -DQUDA_DIRAC_STAGGERED=OFF \
  -DQUDA_DIRAC_TWISTED_MASS=OFF \
  -DQUDA_DIRAC_TWISTED_CLOVER=OFF \
  -DQUDA_DIRAC_WILSON=ON \
  -DQUDA_FORCE_GAUGE=OFF \
  -DQUDA_FORCE_HISQ=OFF \
  -DQUDA_GAUGE_ALG=OFF \
  -DQUDA_GAUGE_TOOLS=OFF \
  -DQUDA_QDPJIT=OFF \
  -DCUDAToolkit_ROOT=${CUDA_DIR} \
  -DQUDA_INTERFACE_QDPJIT=OFF \
  -DQUDA_INTERFACE_MILC=OFF \
  -DQUDA_INTERFACE_CPS=OFF \
  -DQUDA_INTERFACE_QDP=ON \
  -DQUDA_INTERFACE_TIFR=OFF \
  -DQUDA_QMP=ON \
  -DQMP_DIR=${INSTALLROOT}/${QMP}_${EXT}/lib/cmake/QMP \
  -DQDPXX_DIR=${INSTALLROOT}/${QDP}_${EXT}/lib/cmake/QDPXX \
  -DQUDA_QIO=ON \
  -DQIO_DIR=${INSTALLROOT}/${QDP}_${EXT}/lib/cmake/QIO \
  -DQUDA_OPENMP=OFF \
  -DQUDA_MULTIGRID=ON \
  -DQUDA_NVSHMEM=OFF \
  -DQUDA_MAX_MULTI_BLAS_N=9 \
  -DQUDA_DOWNLOAD_EIGEN=ON \
  -DQUDA_EIGEN_VERSION=3.3.9 \
  -DQUDA_DOWNLOAD_USQCD=OFF \
  -DCMAKE_BUILD_TYPE="DEVEL" \
  -DCMAKE_CXX_COMPILER="${CXX}"\
  -DCMAKE_C_FLAGS="${C_FLAGS}" \
  -DCMAKE_CXX_FLAGS="${CXX_FLAGS}" \
  -DCMAKE_CXX_EXTENSIONS=OFF \
  -DCMAKE_C_COMPILER="${CC}" \
  -DBUILD_SHARED_LIBS=ON \
  -DQUDA_BUILD_SHAREDLIB=ON \
  -DQUDA_BUILD_ALL_TESTS=ON \
  -DQUDA_CTEST_DISABLE_BENCHMARKS=OFF \
  -DCMAKE_SHARED_LINKER_FLAGS="-L${CUDA_DIR}/lib64"

$CMAKE --build . $CMAKE_MAKE_FLAGS

if [[ -d ${INSTALLROOT}/${PKG_EXT} && ! -z $INSTALLROOT && ! -z $PKG_EXT ]]; then
    rm -rf ${INSTALLROOT}/${PKG_EXT}
fi

$CMAKE --install .

$PERMFIX ${BUILDROOT}/${PKG_EXT}
$PERMFIX ${INSTALLROOT}/${PKG_EXT}

popd
