#!/bin/bash
#SBATCH -o ./img_aos_histo_threads.txt
export LD_LIBRARY_PATH=/opt/gcc-12.1.0/lib64
echo ""
echo "########## Program: img-aos in out histo ##########"
echo ""
export OMP_SCHEDULE="static"
echo "##### Schedule: ${OMP_SCHEDULE} #####"
echo "1 thread"
export OMP_NUM_THREADS=1
./release/img-aos in out histo
echo "2 threads"
export OMP_NUM_THREADS=2
./release/img-aos in out histo
echo "4 threads"
export OMP_NUM_THREADS=4
./release/img-aos in out histo
echo "8 threads"
export OMP_NUM_THREADS=8
./release/img-aos in out histo
echo "16 threads"
export OMP_NUM_THREADS=16
./release/img-aos in out histo

export OMP_SCHEDULE="dynamic"
echo "##### Schedule: ${OMP_SCHEDULE} #####"
echo ""
echo "1 thread"
export OMP_NUM_THREADS=1
./release/img-aos in out histo
echo "2 threads"
export OMP_NUM_THREADS=2
./release/img-aos in out histo
echo "4 threads"
export OMP_NUM_THREADS=4
./release/img-aos in out histo
echo "8 threads"
export OMP_NUM_THREADS=8
./release/img-aos in out histo
echo "16 threads"
export OMP_NUM_THREADS=16
./release/img-aos in out histo

export OMP_SCHEDULE="guided"
echo "##### Schedule: ${OMP_SCHEDULE} #####"
echo ""
echo "1 thread"
export OMP_NUM_THREADS=1
./release/img-aos in out histo
echo "2 threads"
export OMP_NUM_THREADS=2
./release/img-aos in out histo
echo "4 threads"
export OMP_NUM_THREADS=4
./release/img-aos in out histo
echo "8 threads"
export OMP_NUM_THREADS=8
./release/img-aos in out histo
echo "16 threads"
export OMP_NUM_THREADS=16
./release/img-aos in out histo