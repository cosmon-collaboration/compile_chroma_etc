#!/usr/bin/bash

source ./env.sh $1

PKG=$LALIBE
PKG_EXT=${LALIBE}_${EXT}

pushd ${SRCROOT}

if [[ ! -d $SRCROOT/$PKG ]]; then
    pushd $SRCROOT
    git clone --recursive ${LALIBE_BRANCH} https://github.com/callat-qcd/lalibe.git ${PKG}
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

if [ "${EXT}" = "GPU" ]; then
    QUDA="-DQUDA_DIR=${INSTALLROOT}/${QUDA}/lib/cmake/QUDA"
else
    QUDA=""
fi

$CMAKE ${SRCROOT}/${PKG} \
       -DCMAKE_INSTALL_PREFIX=${INSTALLROOT}/${PKG_EXT} \
       -DCMAKE_C_COMPILER=${CC} -DCMAKE_C_EXTENSIONS=OFF \
       -DCMAKE_CXX_COMPILER=${CXX} \
       -DCMAKE_C_FLAGS="$C_FLAGS" \
       -DCMAKE_CXX_FLAGS="${CXX_FLAGS}" \
       -DCHROMA_ROOT=${INSTALLROOT}/${CHROMA}_${EXT}/lib/cmake/Chroma \
       -DQDPXX_DIR=${INSTALLROOT}/${QDP}_${EXT}/lib/cmake/QDPXX \
       -DQMP_DIR=${INSTALLROOT}/${QMP}_${EXT}/lib/cmake/QMP \
       -DBUILD_HDF5=ON \
       -DHDF5_ROOT=${INSTALLROOT}/${HDF5}_${EXT} \
       $QUDA

$CMAKE --build . $CMAKE_MAKE_FLAGS

if [[ -d ${INSTALLROOT}/${PKG_EXT} && ! -z $INSTALLROOT && ! -z $PKG_EXT ]]; then
    rm -rf ${INSTALLROOT}/${PKG_EXT}
fi

$CMAKE --install .

$PERMFIX ${BUILDROOT}/${PKG_EXT}
$PERMFIX ${INSTALLROOT}/${PKG_EXT}

popd
