#!/bin/bash
#SBATCH -o ./out-test.txt
#SBATCH -e ./out-test.txt
export LD_LIBRARY_PATH=/opt/gcc-12.1.0/lib64
export OMP_NUM_THREADS=1024;
export OMP_SCHEDULE="dynamic"

cd ./release/utest
make
./utest