#!/bin/bash

. "$(dirname "$BASH_SOURCE")/utils.sh"

ensure_toolchain arm   21
ensure_toolchain arm64 21

export LIBGMP_LDFLAGS='-avoid-version'
export LIBGMPXX_LDFLAGS='-avoid-version'

################################################################################################################

export BASE_CFLAGS='-O2 -g -pedantic -fomit-frame-pointer -Wa,--noexecstack -ffunction-sections -funwind-tables -no-canonical-prefixes -fno-strict-aliasing'

# LDFLAGS for 64-bit ARM
export LDFLAGS='-Wl,--no-undefined -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now'

# arm64-v8a
export CFLAGS="${BASE_CFLAGS} -fstack-protector-strong -finline-limit=300 -funswitch-loops"
mpfr_make_compile_install arm64-v8a --host=aarch64-linux-android

# LDFLAGS for 32-bit ARM
export LDFLAGS='-Wl,--fix-cortex-a8 -Wl,--no-undefined -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now'

# armeabi-v7a with neon (unsupported target: will cause crashes on many phones, but works well on the Nexus One)
export CFLAGS="${BASE_CFLAGS} -fstack-protector -finline-limit=64 -march=armv7-a -mfloat-abi=softfp -mfpu=neon -ftree-vectorize -ftree-vectorizer-verbose=2"
mpfr_make_compile_install armeabi-v7a-neon --host=arm-linux-androideabi

# armeabi-v7a
export CFLAGS="${BASE_CFLAGS} -fstack-protector -finline-limit=64 -march=armv7-a -mfloat-abi=softfp -mfpu=vfp"
mpfr_make_compile_install armeabi-v7a --host=arm-linux-androideabi

# armeabi
# export CFLAGS="${BASE_CFLAGS} -fstack-protector -finline-limit=64 -march=armv5te -mtune=xscale -msoft-float -mthumb"
# mpfr_make_compile_install armeabi --host=arm-linux-androideabi
