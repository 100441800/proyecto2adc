#!/bin/bash
#SBATCH -o ./out-build.out
#SBATCH -e ./out-build.out

if [ $# -eq 1 ] && [ $1 == avignon ]; then
# Config build directories for Avignon
	rm -rf release
	export LD_LIBRARY_PATH=/opt/gcc-12.1.0/lib64
	cmake -S . -B release -DCMAKE_CXX_COMPILER=/opt/gcc-12.1.0/bin/g++ -DCMAKE_BUILD_TYPE=Release
	cmake --build release
elif [ $# -eq 1 ] && [ $1 == macos ]; then
# Config build directories for MacOS
	find . -name ".DS_Store" -delete
	cmake -S . -B release -DCMAKE_CXX_COMPILER=/opt/homebrew/bin/g++-12 -DCMAKE_BUILD_TYPE=Release
	cmake --build release --clean-first
elif [ $# -eq 1 ] && [ $1 == ubuntu ]; then
# Config build directories for MacOS
	cmake -S . -B release -DCMAKE_CXX_COMPILER=/usr/bin/g++-12 -DCMAKE_BUILD_TYPE=Release
	cmake --build release --clean-first
else
	echo "Incorrect arguments: use macos or avignon"
	exit -1
fi