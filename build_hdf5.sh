#!/usr/bin/bash

source ./env.sh $1

PKG=$HDF5
PKG_EXT=${HDF5}_${EXT}

pushd ${SRCROOT}
if [[ ! -d $SRCROOT/$PKG ]]; then
    curl -O https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/${PKG}/src/${PKG}.tar.bz2
    tar -xf ${PKG}.tar.bz2
fi
$PERMFIX ${PKG}
popd

pushd ${BUILDROOT}

if [ -d ./${PKG_EXT} ];
then
    rm -rf ./${PKG_EXT}
fi

mkdir  ./${PKG_EXT}
cd ./${PKG_EXT}

$CMAKE ${SRCROOT}/${PKG} \
      -G "Unix Makefiles" \
      -DCMAKE_CXX_COMPILER=${CXX} \
      -DCMAKE_C_COMPILER=${CC}  \
      -DCMAKE_BUILD_TYPE:STRING=Release \
      -DBUILD_SHARED_LIBS:BOOL=OFF \
      -DBUILD_TESTING:BOOL=ON \
      -DHDF5_BUILD_TOOLS:BOOL=ON \
      -DCMAKE_CXX_FLAGS="${CXX_FLAGS} -I${INSTALLROOT}/${PKG_EXT}/include " \
      -DCMAKE_C_FLAGS="${C_FLAGS}  -I${INSTALLROOT}/${PKG_EXT}/include " \
      -DCMAKE_SHARED_LINKER_FLAGS="${MPI_LDFLAGS}" \
      -DCMAKE_EXE_LINKER_FLAGS="${MPI_LDFLAGS}" \
      -DHDF5_ENABLE_PARALLEL:BOOL=ON \
      -DCMAKE_INSTALL_PREFIX=${INSTALLROOT}/${PKG_EXT}


$CMAKE --build . $CMAKE_MAKE_FLAGS

if [[ -d ${INSTALLROOT}/${PKG_EXT} && ! -z $INSTALLROOT && ! -z $PKG_EXT ]]; then
    rm -rf ${INSTALLROOT}/${PKG_EXT}
fi

$CMAKE --install . 

$PERMFIX ${BUILDROOT}/${PKG_EXT}
$PERMFIX ${INSTALLROOT}/${PKG_EXT}

popd
