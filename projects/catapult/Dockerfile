FROM gcr.io/oss-fuzz-base/base-builder
RUN apt-get -y update && apt-get install -y \
    curl
RUN curl -o cmake-3.15.3-Linux-x86_64.sh -SL "https://github.com/Kitware/CMake/releases/download/v3.15.3/cmake-3.15.3-Linux-x86_64.sh" && \
    chmod +x cmake-3.15.3-Linux-x86_64.sh && \
    ./cmake-3.15.3-Linux-x86_64.sh --skip-license --prefix=/usr && \
    rm -rf cmake-3.15.3-Linux-x86_64.sh
RUN curl -o boost_1_71_0.tar.gz -SL https://dl.bintray.com/boostorg/release/1.71.0/source/boost_1_71_0.tar.gz && \
    tar -xzf boost_1_71_0.tar.gz && \
    cd boost_1_71_0 && \
    export CXXFLAGS="$CXXFLAGS -pthread" && \
    ./bootstrap.sh --with-toolset=clang --prefix=/usr && \
    ./b2 toolset=clang cxxflags='-std=c++1y ${CXXFLAGS}' linkflags='-stdlib=libc++' \
      --without-python -j 8 stage release && \
    ./b2 toolset=clang cxxflags='-std=c++1y ${CXXFLAGS}' linkflags='-stdlib=libc++' \
      --without-python install || \
    true
RUN git clone --single-branch --branch=1.15.1 https://github.com/mongodb/mongo-c-driver.git && \
    cd mongo-c-driver && \
    mkdir _build && cd _build && \
    cmake -DENABLE_AUTOMATIC_INIT_AND_CLEANUP=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr .. && \
    make && make install
RUN git clone --single-branch --branch=r3.4.0-nem https://github.com/nemtech/mongo-cxx-driver.git && \
    cd mongo-cxx-driver && \
    mkdir _build && cd _build && \
    cmake -DCMAKE_CXX_STANDARD=17 -DCMAKE_CXX_FLAGS='-stdlib=libc++ -pthread' \
        -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr .. && \
    make && make install && \
    cd ../.. && \
    rm -rf mongo-cxx-driver mongo-c-driver
RUN git clone --single-branch --branch=v4.3.2 git://github.com/zeromq/libzmq.git && \
    cd libzmq && \
    mkdir _build && cd _build  && \
    cmake -DCMAKE_CXX_FLAGS='-std=c++1y -stdlib=libc++' -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr .. && \
    make && make install
RUN git clone --single-branch --branch=v4.4.1 https://github.com/zeromq/cppzmq.git && \
    cd cppzmq && \
    mkdir _build && cd _build && \
    cmake -DCMAKE_CXX_FLAGS='-std=c++1y -stdlib=libc++' -DCPPZMQ_BUILD_TESTS=OFF -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr .. && \
    make && make install
RUN git clone --single-branch --branch=v6.2.4-nem https://github.com/nemtech/rocksdb.git && \
    cd rocksdb && \
     USE_RTTI=1 make install-shared

RUN git clone --single-branch --branch=fix_break_fuzz https://github.com/Wayonb/catapult-server.git catapult-server
WORKDIR catapult-server
COPY build.sh $SRC/
