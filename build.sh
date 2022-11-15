#!/bin/bash
#SBATCH -o ./config.out
#SBATCH -e ./config.out

if [ $# -eq 1 ] && [ $1 == avignon ]; then
# Config build directories for Avignon
	rm -rf release
	LD_LIBRARY_PATH=/opt/gcc-12.1.0/lib64
	cmake -S . -B release -DCMAKE_CXX_COMPILER=/opt/gcc-12.1.0/bin/g++ -DCMAKE_BUILD_TYPE=Release  
elif [ $# -eq 1 ] && [ $1 == macos ]; then
# Config build directories for MacOS
	find . -name ".DS_Store" -delete
	cmake -S . -B release -DCMAKE_CXX_COMPILER=/opt/homebrew/bin/g++-12 -DCMAKE_BUILD_TYPE=Release
else
	echo "Incorrect arguments: use macos, windows or avignon"
	exit -1
fi

cmake --build release --clean-first