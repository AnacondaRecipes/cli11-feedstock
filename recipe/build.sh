#!/bin/bash

# Isolate the build.
mkdir -p Build
cd Build || exit 1

# Don't build tests for `s390x` since boost is missing.
if [ "${target_platform}" == 'linux-s390x' ]; then
    build_tests=OFF
else
    build_tests=ON
fi


# Generate the build files.
cmake .. -G"Ninja" ${CMAKE_ARGS} \
      -DCLI11_BUILD_TESTS=${build_tests} \
      -DCLI11_BUILD_EXAMPLES=OFF \
      -DCMAKE_PREFIX_PATH=$PREFIX \
      -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_BUILD_TYPE=Release

# Build and install.
ninja install || exit 1


# Exit early for s390x since `libboost` is not available.
if [ "${target_platform}" == 'linux-s390x' ]; then
    exit 0
fi


# Perform tests.
ninja test || exit 1
