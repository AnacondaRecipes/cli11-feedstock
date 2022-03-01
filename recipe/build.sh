#!/bin/bash

# Isolate the build.
mkdir -p Build
cd Build || exit 1

# Generate the build files.
cmake .. -G"Ninja" ${CMAKE_ARGS} \
      -DCLI11_BUILD_TESTS=ON \
      -DCLI11_BUILD_EXAMPLES=OFF \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_BUILD_TYPE=Release

# Build and install.
ninja install || exit 1


# Exit early for s390x since `libboost` is not available.
if [ "${target_platform}" == 'linux-aarch64' ]; then
    exit 0
fi


# Perform tests.
ninja test || exit 1
