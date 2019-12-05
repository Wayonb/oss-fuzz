#!/bin/bash

mkdir -p _build
cd _build

cmake_args=()
cmake_args+=("-DCMAKE_INSTALL_PREFIX=${OUT}")
cmake_args+=("-DCMAKE_BUILD_TYPE=RelWithDebInfo")
#cmake_args+=("-DUSE_KECCAK=TRUE")

#
#cmake_args+=("-DUSE_SANITIZER= sanitizer name ")
#

cmake_args+=("-DENABLE_TESTS=OFF")
cmake_args+=("-DENABLE_FUZZING=ON")

cmake "${cmake_args[@]}" ..
make publish
make -j8 server plugins extensions 
make install

# copy the fuzz target
cp $OUT/bin/catapult.tools.pipeline $OUT

# copy the rocksdb lib
cp /usr/local/lib/librocksdb.so* $OUT
