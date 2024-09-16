#!/usr/bin/bash

source ./env.sh $1

PKG=$CHROMA
PKG_EXT=${CHROMA}_${EXT}

pushd ${SRCROOT}

if [[ ! -d $SRCROOT/$PKG ]]; then
    pushd $SRCROOT
    git clone --recursive ${CHROMA_BRANCH} https://github.com/JeffersonLab/chroma.git ${PKG}
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
    QUDA="-DChroma_ENABLE_QUDA=ON -DQUDA_DIR=${INSTALLROOT}/${QUDA}/lib/cmake/QUDA"
else
    QUDA=""
fi


$CMAKE ${SRCROOT}/${PKG} \
      -DCMAKE_INSTALL_PREFIX=${INSTALLROOT}/${PKG_EXT} \
      -DCMAKE_CXX_COMPILER=${CXX} \
      -DCMAKE_C_COMPILER=${CC} -DCMAKE_C_EXTENSIONS=OFF  \
      -DCMAKE_C_FLAGS="$C_FLAGS" \
      -DCMAKE_CXX_FLAGS="${CXX_FLAGS}" \
      -DBUILD_SHARED_LIBS=ON \
      -DCMAKE_BUILD_TYPE=RelWithDebInfo \
      -DQDPXX_DIR=${INSTALLROOT}/${QDP}_${EXT}/lib/cmake/QDPXX \
      -DHDF5_ROOT=${INSTALLROOT}/${HDF5}_${EXT} \
      -DQMP_DIR=${INSTALLROOT}/${QMP}_${EXT}/lib/cmake/QMP \
      -DChroma_ENABLE_OPENMP=ON \
      $QUDA

$CMAKE --build . -j10

if [[ -d ${INSTALLROOT}/${PKG_EXT} && ! -z $INSTALLROOT && ! -z $PKG_EXT ]]; then
    rm -rf ${INSTALLROOT}/${PKG_EXT}
fi

$CMAKE --install .

$PERMFIX ${BUILDROOT}/${PKG_EXT}
$PERMFIX ${INSTALLROOT}/${PKG_EXT}

popd
