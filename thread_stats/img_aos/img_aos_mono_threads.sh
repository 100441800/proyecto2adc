#!/bin/bash
export LD_LIBRARY_PATH=/opt/gcc-12.1.0/lib64
echo "\n########## Program: img-aos in out mono ##########"
export OMP_SCHEDULE="static"
echo "\n##### Schedule: ${OMP_SCHEDULE} #####"
echo "\n1 thread"
export OMP_NUM_THREADS=1
./release/img-aos in out mono
echo "\n2 threads"
export OMP_NUM_THREADS=2
./release/img-aos in out mono
echo "\n4 threads"
export OMP_NUM_THREADS=4
./release/img-aos in out mono
echo "\n8 threads"
export OMP_NUM_THREADS=8
./release/img-aos in out mono
echo "\n16 threads"
export OMP_NUM_THREADS=16
./release/img-aos in out mono

export OMP_SCHEDULE="dynamic"
echo "\n##### Schedule: ${OMP_SCHEDULE} #####"
echo "\n1 thread"
export OMP_NUM_THREADS=1
./release/img-aos in out mono
echo "\n2 threads"
export OMP_NUM_THREADS=2
./release/img-aos in out mono
echo "\n4 threads"
export OMP_NUM_THREADS=4
./release/img-aos in out mono
echo "\n8 threads"
export OMP_NUM_THREADS=8
./release/img-aos in out mono
echo "\n16 threads"
export OMP_NUM_THREADS=16
./release/img-aos in out mono

export OMP_SCHEDULE="guided"
echo "\n##### Schedule: ${OMP_SCHEDULE} #####"
echo "\n1 thread"
export OMP_NUM_THREADS=1
./release/img-aos in out mono
echo "\n2 threads"
export OMP_NUM_THREADS=2
./release/img-aos in out mono
echo "\n4 threads"
export OMP_NUM_THREADS=4
./release/img-aos in out mono
echo "\n8 threads"
export OMP_NUM_THREADS=8
./release/img-aos in out mono
echo "\n16 threads"
export OMP_NUM_THREADS=16
./release/img-aos in out mono

export OMP_SCHEDULE="auto"
echo "\n##### Schedule: ${OMP_SCHEDULE} #####"
echo "\n1 thread"
export OMP_NUM_THREADS=1
./release/img-aos in out mono
echo "\n2 threads"
export OMP_NUM_THREADS=2
./release/img-aos in out mono
echo "\n4 threads"
export OMP_NUM_THREADS=4
./release/img-aos in out mono
echo "\n8 threads"
export OMP_NUM_THREADS=8
./release/img-aos in out mono
echo "\n16 threads"
export OMP_NUM_THREADS=16
./release/img-aos in out mono