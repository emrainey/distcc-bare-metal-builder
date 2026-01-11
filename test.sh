#!/usr/bin/env bash
set -o xtrace

export DISTCC_FALLBACK=0
export DISTCC_SKIP_LOCAL_RETRY=1
export DISTCC_DIR=/tmp/distcc
export DISTCC_VERBOSE=1

mkdir -p ${DISTCC_DIR}

if [ -z "DISTCC_HOSTS" ]; then
    export DISTCC_HOSTS="127.0.0.1"
fi

rm -rf test/build
mkdir test/build/
cmake -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake \
      -DCMAKE_C_COMPILER_LAUNCHER=distcc \
      -DCMAKE_CXX_COMPILER_LAUNCHER=distcc \
      -B test/build/ -S test/
cmake --build test/build/
