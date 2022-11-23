#!/bin/bash
#SBATCH -o ./img_aos_gauss_threads.txt
export LD_LIBRARY_PATH=/opt/gcc-12.1.0/lib64
echo ""
echo "########## Program: img-aos in out gauss ##########"
echo ""
export OMP_SCHEDULE="static"
echo "##### Schedule: ${OMP_SCHEDULE} #####"
echo "1 thread"
export OMP_NUM_THREADS=1
~/proyecto2PARALELO/release/img-soa in out gauss
echo "2 threads"
export OMP_NUM_THREADS=2
~/proyecto2PARALELO/release/img-soa in out gauss
echo "4 threads"
export OMP_NUM_THREADS=4
~/proyecto2PARALELO/release/img-soa in out gauss
echo "8 threads"
export OMP_NUM_THREADS=8
~/proyecto2PARALELO/release/img-soa in out gauss
echo "16 threads"
export OMP_NUM_THREADS=16
~/proyecto2PARALELO/release/img-soa in out gauss

export OMP_SCHEDULE="dynamic"
echo "##### Schedule: ${OMP_SCHEDULE} #####"
echo ""
echo "1 thread"
export OMP_NUM_THREADS=1
~/proyecto2PARALELO/release/img-soa in out gauss
echo "2 threads"
export OMP_NUM_THREADS=2
~/proyecto2PARALELO/release/img-soa in out gauss
echo "4 threads"
export OMP_NUM_THREADS=4
~/proyecto2PARALELO/release/img-soa in out gauss
echo "8 threads"
export OMP_NUM_THREADS=8
~/proyecto2PARALELO/release/img-soa in out gauss
echo "16 threads"
export OMP_NUM_THREADS=16
~/proyecto2PARALELO/release/img-soa in out gauss

export OMP_SCHEDULE="guided"
echo "##### Schedule: ${OMP_SCHEDULE} #####"
echo ""
echo "1 thread"
export OMP_NUM_THREADS=1
~/proyecto2PARALELO/release/img-soa in out gauss
echo "2 threads"
export OMP_NUM_THREADS=2
~/proyecto2PARALELO/release/img-soa in out gauss
echo "4 threads"
export OMP_NUM_THREADS=4
~/proyecto2PARALELO/release/img-soa in out gauss
echo "8 threads"
export OMP_NUM_THREADS=8
~/proyecto2PARALELO/release/img-soa in out gauss
echo "16 threads"
export OMP_NUM_THREADS=16
~/proyecto2PARALELO/release/img-soa in out gauss