#!/usr/bin/env bash
set -euo pipefail

DOCKER="${1:?"Usage: $0 <docker> <image> <outfile>"}"
IMAGE="${2:?"Usage: $0 <docker> <image> <outfile>"}"
OUTFILE="${3:?"Usage: $0 <docker> <image> <outfile>"}"

mkdir -p "$(dirname "$OUTFILE")"

# Collect versions from the image
distcc_ver=$("$DOCKER" run --rm --entrypoint /bin/bash "$IMAGE" -c 'distccd --version 2>&1' | head -1 | awk '{print $2}')
gcc_ver=$("$DOCKER" run --rm --entrypoint /bin/bash "$IMAGE" -c 'gcc --version 2>&1' | head -1 | awk '{print $NF}')
gxx_ver=$("$DOCKER" run --rm --entrypoint /bin/bash "$IMAGE" -c 'g++ --version 2>&1' | head -1 | awk '{print $NF}')
arm_gcc_ver=$("$DOCKER" run --rm --entrypoint /bin/bash "$IMAGE" -c 'arm-none-eabi-gcc --version 2>&1' | head -1 | awk '{print $(NF-1)}')
arm_gxx_ver=$("$DOCKER" run --rm --entrypoint /bin/bash "$IMAGE" -c 'arm-none-eabi-g++ --version 2>&1' | head -1 | awk '{print $(NF-1)}')
clang_ver=$("$DOCKER" run --rm --entrypoint /bin/bash "$IMAGE" -c 'clang-22 --version 2>&1' | head -1 | awk '{print $4}')

# Short composite tag for easy identification
composite="gcc${gcc_ver}-armgcc${arm_gcc_ver}-clang${clang_ver}"

# Apply tags
"$DOCKER" tag "$IMAGE" "$IMAGE:${composite}"
"$DOCKER" tag "$IMAGE" "$IMAGE:distcc-${distcc_ver}"
"$DOCKER" tag "$IMAGE" "$IMAGE:gcc-${gcc_ver}"
"$DOCKER" tag "$IMAGE" "$IMAGE:arm-none-eabi-gcc-${arm_gcc_ver}"
"$DOCKER" tag "$IMAGE" "$IMAGE:clang-${clang_ver}"

# Write versions file
cat > "$OUTFILE" <<EOF
distcc=${distcc_ver}
gcc=${gcc_ver}
g++=${gxx_ver}
arm-none-eabi-gcc=${arm_gcc_ver}
arm-none-eabi-g++=${arm_gxx_ver}
clang=${clang_ver}

image=${IMAGE}
composite_tag=${composite}
tags=distcc-${distcc_ver} gcc-${gcc_ver} arm-none-eabi-gcc-${arm_gcc_ver} clang-${clang_ver}
EOF

echo "Tagged ${IMAGE} with: ${composite}"
