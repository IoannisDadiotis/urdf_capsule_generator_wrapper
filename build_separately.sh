#!/bin/bash
set -e  # exit on error

# Root directory of your repo
ROOT_DIR="$(pwd)"

# Where to install all packages
INSTALL_PREFIX="$ROOT_DIR/install"
    echo "=============================="
    echo "Install folder: $INSTALL_PREFIX"
    echo "=============================="

# List of packages in order
PACKAGES=(
  "roboptim-core"
  "roboptim-core-plugin-ipopt"
  "roboptim-capsule"
  "robot_capsule_generator"
)

#source paths
source ./source_paths.sh

# Optional: clean previous install
sudo rm -rf "$INSTALL_PREFIX"

# Loop over packages
for PKG in "${PACKAGES[@]}"; do
    echo "=============================="
    echo "Building and installing $PKG"
    echo "=============================="

    PKG_DIR="$ROOT_DIR/$PKG"
    BUILD_DIR="$PKG_DIR/build"

    # Create build directory
    mkdir -p "$BUILD_DIR"
    cd "$BUILD_DIR"

    # Configure with CMake
    cmake "$PKG_DIR" -DDISABLE_TESTS=ON -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX"

    # Build
    cmake --build . -- -j$(nproc)

    # Install
    sudo cmake --install .

    # Return to root dir
    cd "$ROOT_DIR"
    source ./source_paths.sh
done

echo "All packages built and installed to $INSTALL_PREFIX"
