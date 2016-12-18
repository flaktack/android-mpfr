set -e
set -x

NDK="${NDK:-/tank/android/android-ndk-r10e}"
DESTBASE="${DESTBASE:-$PWD}"

if [ ! -x configure ]
then
  echo "Run this script from the GMP/MPFR base directory"
  exit 1
fi

if [ ! -d ${NDK} ]
then
  echo "Please download and install the NDK, then update the path in this script."
  echo "  http://developer.android.com/sdk/ndk/index.html"
  exit 1
fi

function ensure_toolchain {
  local ARCH=$1
  local TARGET=$2
  local TOOLCHAIN="/tmp/android-toolchain-${TARGET}-${ARCH}"
  if [ ! -d ${TOOLCHAIN} ]
  then
    echo "Creating toolchain: ${TOOLCHAIN}"
    ${NDK}/build/tools/make_standalone_toolchain.py --arch ${ARCH} --api ${TARGET} --install-dir ${TOOLCHAIN}
  else
    echo "Using existing toolchain: ${TOOLCHAIN}"
  fi
  PATH="${TOOLCHAIN}/bin:${PATH}"
}


function gmp_make_compile_install {
  local TAG=$1
  local MPN_PATH=$2
  shift; shift

  echo "======= COMPILING FOR $TAG ======="
  ./configure --prefix=$DESTBASE/$TAG --disable-static --enable-cxx --build=x86_64-pc-linux-gnu $@ MPN_PATH="$MPN_PATH"
  make -j8 V=1 2>&1 | tee android-$TAG.log
  make install
  pushd $DESTBASE/$TAG
  popd
  make distclean
}

function mpfr_make_compile_install {
  local TAG=$1
  shift

  echo "======= COMPILING FOR $TAG ======="
  ./configure --prefix=$DESTBASE/$TAG --with-gmp-include=$DESTBASE/$TAG/include --with-gmp-lib=$DESTBASE/$TAG/lib --disable-static --enable-cxx --build=x86_64-pc-linux-gnu $@
  make -j8 V=1 2>&1 | tee android-$TAG.log
  make install
  pushd $DESTBASE/$TAG
  rm -rf usr
  popd
  make distclean
}
