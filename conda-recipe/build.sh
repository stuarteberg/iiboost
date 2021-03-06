IIBOOST_LDFLAGS="${LDFLAGS} -Wl,-rpath,${PREFIX}/lib -L${PREFIX}/lib"
IIBOOST_CXXFLAGS="${CFLAGS} -std=c++11"

PY_VER=$(python -c "import sys; print('{}.{}'.format(*sys.version_info[:2]))")
PY_ABIFLAGS=$(python -c "import sys; print('' if sys.version_info.major == 2 else sys.abiflags)")
PY_ABI=${PY_VER}${PY_ABIFLAGS}

DYLIB_EXT=so
CC=${PREFIX}/bin/gcc
CXX=${PREFIX}/bin/g++
IIBOOST_USE_OPENMP=YES

if [[ $(uname) == 'Darwin' ]]; then
    DYLIB_EXT=dylib
    #IIBOOST_CXXFLAGS="${IIBOOST_CXXFLAGS} -stdlib=libc++"
    #CC=clang
    #CXX=clang++
    #IIBOOST_USE_OPENMP=NO
fi

mkdir build
cd build
cmake .. \
    -DCMAKE_C_COMPILER=${CC} \
    -DCMAKE_CXX_COMPILER=${CXX} \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=${PREFIX} \
    -DCMAKE_PREFIX_PATH=${PREFIX} \
    -DCMAKE_CXX_FLAGS="${IIBOOST_CXXFLAGS}" \
    -DCMAKE_SHARED_LINKER_FLAGS="${IIBOOST_LDFLAGS}" \
    -DCMAKE_EXE_LINKER_FLAGS="${IIBOOST_LDFLAGS}" \
    -DBUILD_PYTHON_WRAPPER=1 \
    -DIIBOOST_PYTHON_INSTALL_DIR=${SP_DIR} \
    -DPYTHON_EXECUTABLE=${PYTHON} \
    -DPYTHON_INCLUDE_PATH=${PREFIX}/include/python${PY_ABI} \
    -DPYTHON_LIBRARIES=${PREFIX}/lib/libpython${PY_ABI}.${DYLIB_EXT} \
    -DPYTHON_NUMPY_INCLUDE_DIR=${SP_DIR}/numpy/core/include \
    -DITK_DIR=${PREFIX}/lib/cmake/ITK-4.6 \
    -DIIBOOST_USE_OPENMP=${IIBOOST_USE_OPENMP} \
##

# BUILD
make -j${CPU_COUNT} 2> >(python "${RECIPE_DIR}"/filter-macos-linker-warnings.py)

# "install" to the build prefix (conda will relocate these files afterwards)
make install
