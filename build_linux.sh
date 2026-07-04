#!/usr/bin/env bash
#================================================
# Build the OptiTrack Godot plugin for Linux (Ubuntu).
#
# Produces libOptiTrack-plugin.linux.template_{debug,release}.x86_64.so and
# stages them, together with libNatNet.so, into
# example-project/addons/optitrack_plugin/bin/.
#
# Requirements (Ubuntu):
#   sudo apt update
#   sudo apt install -y build-essential scons python3 git pkg-config
#================================================
set -euo pipefail

cd "$(dirname "$0")"

# godot-cpp is a git submodule and is required to compile the GDExtension.
# Initialise it if it's missing (works whether or not this is a git checkout).
if [ ! -f "godot-cpp/SConstruct" ]; then
    echo "godot-cpp not found. Fetching it..."
    if [ -d ".git" ] && git submodule status godot-cpp >/dev/null 2>&1; then
        git submodule update --init --recursive
    else
        # Not a git checkout (e.g. extracted from a release zip): clone directly.
        # 4.3 satisfies the plugin's compatibility_minimum = 4.1.
        rm -rf godot-cpp
        git clone -b 4.3 --depth 1 https://github.com/godotengine/godot-cpp.git godot-cpp
    fi
fi

# Detect CPU count for a parallel build.
JOBS="$(nproc 2>/dev/null || echo 4)"

echo "Building template_debug..."
scons platform=linux target=template_debug arch=x86_64 -j"${JOBS}"

echo "Building template_release..."
scons platform=linux target=template_release arch=x86_64 -j"${JOBS}"

echo
echo "Build complete. Staged binaries:"
ls -la example-project/addons/optitrack_plugin/bin/ | grep -E 'linux|libNatNet' || true
