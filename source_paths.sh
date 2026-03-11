#!/bin/bash
ROOT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

export PATH="$ROOT_DIR/install/bin:$PATH"
# export LD_LIBRARY_PATH="$ROOT_DIR/install/lib/roboptim-core:$LD_LIBRARY_PATH"
export LD_LIBRARY_PATH="$ROOT_DIR/install/lib:$LD_LIBRARY_PATH"
export CMAKE_PREFIX_PATH="$ROOT_DIR/install:$CMAKE_PREFIX_PATH"
export LTDL_LIBRARY_PATH=$ROOT_DIR/install/lib/roboptim-core:$LTDL_LIBRARY_PATH
export PKG_CONFIG_PATH=$ROOT_DIR/install/lib/pkgconfig:$PKG_CONFIG_PATH
