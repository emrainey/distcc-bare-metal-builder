#!/usr/bin/env bash
set -o xtrace

# Don't fallback to local compilers
export DISTCC_FALLBACK=0
# Skip retrying locally if a distcc job fails
export DISTCC_SKIP_LOCAL_RETRY=1
# Directory where distcc stores temporary files
export DISTCC_DIR=/tmp/distcc
# Verbosity level of distcc (0 = silent, 1 = verbose)
export DISTCC_VERBOSE=0

# Create the directory for distcc temporary files
mkdir -p ${DISTCC_DIR}

# Set default DISTCC_HOSTS if not already set
if [ -z "$DISTCC_HOSTS" ]; then
    export DISTCC_HOSTS="127.0.0.1"
fi

rm -rf test/build/
mkdir test/build/
# Change to your path to the ARM GNU Toolchain where arm-none-eabi-gcc is located
export PATH=/Applications/ArmGNUToolchain/13.2.Rel1/arm-none-eabi/bin:$PATH
export CC=arm-none-eabi-gcc
export CXX=arm-none-eabi-g++
cmake -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake \
      -DCMAKE_C_COMPILER_LAUNCHER=distcc \
      -DCMAKE_CXX_COMPILER_LAUNCHER=distcc \
      -B test/build/ -S test/
cmake --build test/build/
