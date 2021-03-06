#!/bin/bash

. "$(dirname "$BASH_SOURCE")/utils.sh"

ensure_toolchain mips   21
ensure_toolchain mips64 21

export LDFLAGS='-Wl,--no-undefined -Wl,-z,noexecstack -Wl,-z,relro -Wl,-z,now'
export LIBGMP_LDFLAGS='-avoid-version'
export LIBGMPXX_LDFLAGS='-avoid-version'

################################################################################################################

# base CFLAGS set from ndk-build output
BASE_CFLAGS='-O2 -g -pedantic -fomit-frame-pointer -Wa,--noexecstack -fno-strict-aliasing -finline-functions -ffunction-sections -funwind-tables -fmessage-length=0 -fno-inline-functions-called-once -fgcse-after-reload -frerun-cse-after-loop -frename-registers -no-canonical-prefixes'

# mips CFLAGS not specified in 'CPU Arch ABIs' in the NDK documentation
export CFLAGS="${BASE_CFLAGS}"
gmp_make_compile_install mips "mips32 generic" --host=mipsel-linux-android

# mips64 CFLAGS not specified in 'CPU Arch ABIs' in the NDK documentation
export CFLAGS="${BASE_CFLAGS}"
# Ugly hack: delete incompatible assembly code from MPN directory
rm -f mpn/mips64/{addmul_1.asm,submul_1.asm,mul_1.asm,sqr_diagonal.asm,umul.asm}
gmp_make_compile_install mips64 "mips64 generic" --host=mips64el-linux-android

exit 0
