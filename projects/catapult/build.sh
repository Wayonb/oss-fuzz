#!/bin/bash

mkdir -p _build
cd _build

cmake_args=()
cmake_args+=("-DCMAKE_INSTALL_PREFIX=${OUT}")
cmake_args+=("-DCMAKE_BUILD_TYPE=RelWithDebInfo")
cmake_args+=("-DUSE_KECCAK=TRUE")

#
#cmake_args+=("-DUSE_SANITIZER= sanitizer name ")
#

cmake_args+=("-DENABLE_TESTS=OFF")

cmake "${cmake_args[@]}" ..
make publish
make -j8 server plugins extensions 
make install
mkdir $OUT/resources
cp $SRC/catapult-server/resources/* $OUT/resources 
