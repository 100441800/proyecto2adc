#!/bin/bash
#SBATCH -o ./out-test.out
#SBATCH -e ./out-test.out
export LD_LIBRARY_PATH=/opt/gcc-12.1.0/lib64
cd ./release/utest
make
./utest