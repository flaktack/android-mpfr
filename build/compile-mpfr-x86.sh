#!/bin/bash

. "$(dirname "$BASH_SOURCE")/utils.sh"

ensure_toolchain x86    21
ensure_toolchain x86_64 21

export LDFLAGS='-Wl,-z,noexecstack,-z,relro,-z,now,--no-undefined'
export LIBGMP_LDFLAGS='-avoid-version'
export LIBGMPXX_LDFLAGS='-avoid-version'

################################################################################################################

# base CFLAGS set from ndk-build output
BASE_CFLAGS='-O2 -g -pedantic -Wa,--noexecstack -fomit-frame-pointer -ffunction-sections -funwind-tables -fstrict-aliasing -funswitch-loops -finline-limit=300 -no-canonical-prefixes'

# x86, CFLAGS set according to 'CPU Arch ABIs' in the r8c documentation
export CFLAGS="${BASE_CFLAGS} -fstack-protector -march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32"
mpfr_make_compile_install x86 --host=i686-linux-android

# x86_64, CFLAGS set according to 'CPU Arch ABIs' in the NDK documentation, LDFLAGS as observed from ndk-build
export CFLAGS="${BASE_CFLAGS} -fstack-protector-strong -march=x86-64 -msse4.2 -mpopcnt -m64 -mtune=intel"
mpfr_make_compile_install x86_64 --host=x86_64-linux-android
