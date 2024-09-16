#!/usr/bin/bash

source ./env.sh $1

PKG=$QMP
PKG_EXT=${QMP}_${EXT}

pushd ${SRCROOT}

if [[ ! -d $SRCROOT/$PKG ]]; then
    pushd $SRCROOT
    git clone ${QMP_BRANCH} https://github.com/usqcd-software/qmp.git ${PKG}
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
      -G Ninja \
      -DQMP_MPI=ON \
      -DCMAKE_BUILD_TYPE=RelWithDebInfo \
      -DCMAKE_C_COMPILER=${CC} \
      -DCMAKE_C_FLAGS="$C_FLAGS" \
      -DCMAKE_INSTALL_PREFIX=${INSTALLROOT}/${PKG_EXT}  \
      -DBUILD_SHARED_LIBS=ON 

$CMAKE --build . $CMAKE_MAKE_FLAGS

if [[ -d ${INSTALLROOT}/${PKG_EXT} && ! -z $INSTALLROOT && ! -z $PKG_EXT ]]; then
    rm -rf ${INSTALLROOT}/${PKG_EXT}
fi

$CMAKE --install . 

$PERMFIX ${BUILDROOT}/${PKG_EXT}
$PERMFIX ${INSTALLROOT}/${PKG_EXT}

popd

