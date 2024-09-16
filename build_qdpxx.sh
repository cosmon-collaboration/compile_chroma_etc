#!/usr/bin/bash

source ./env.sh $1

PKG=$QDP
PKG_EXT=${QDP}_${EXT}

pushd ${SRCROOT}

if [[ ! -d $SRCROOT/$PKG ]]; then
    pushd $SRCROOT
    git clone --recursive ${QDP_BRANCH} https://github.com/usqcd-software/qdpxx.git ${PKG}
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

$CMAKE ${SRCROOT}/${PKG} \
      -DCMAKE_INSTALL_PREFIX=${INSTALLROOT}/${PKG_EXT} \
      -G "Ninja" \
      -DQDP_PARALLEL_ARCH=parscalar \
      -DQDP_PRECISION=double \
      -DCMAKE_BUILD_TYPE=RelWithDebInfo \
      -DBUILD_SHARED_LIBS=ON \
      -DCMAKE_CXX_COMPILER=${CXX} -DCMAKE_CXX_EXTENSIONS=OFF \
      -DCMAKE_C_COMPILER=${CC} -DCMAKE_C_EXTENSIONS=OFF \
      -DCMAKE_C_FLAGS="$C_FLAGS" \
      -DCMAKE_CXX_FLAGS="${CXX_FLAGS}" \
      -DHDF5_ROOT=${INSTALLROOT}/${HDF5}_${EXT} \
      -DQDP_USE_HDF5=ON \
      -DQMP_DIR=${INSTALLROOT}/${QMP}_${EXT}/lib/cmake/QMP

$CMAKE --build . $CMAKE_MAKE_FLAGS

if [[ -d ${INSTALLROOT}/${PKG_EXT} && ! -z $INSTALLROOT && ! -z $PKG_EXT ]]; then
    rm -rf ${INSTALLROOT}/${PKG_EXT}
fi

$CMAKE --install . 

$PERMFIX ${BUILDROOT}/${PKG_EXT}
$PERMFIX ${INSTALLROOT}/${PKG_EXT}

popd
