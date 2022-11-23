#!/bin/bash
#SBATCH -o ./img_soa_mono_threads.txt
export LD_LIBRARY_PATH=/opt/gcc-12.1.0/lib64
echo ""
echo "########## Program: img-soa in out mono ##########"
echo ""
export OMP_SCHEDULE="static"
echo "##### Schedule: ${OMP_SCHEDULE} #####"
echo "1 thread"
export OMP_NUM_THREADS=1
perf stat -r 5 -a -e power/energy-cores/,power/energy-pkg/,power/energy-ram/ ~/proyecto2PARALELO/release/img-soa in out mono > /dev/null
echo "2 threads"
export OMP_NUM_THREADS=2
perf stat -r 5 -a -e power/energy-cores/,power/energy-pkg/,power/energy-ram/ ~/proyecto2PARALELO/release/img-soa in out mono > /dev/null
echo "4 threads"
export OMP_NUM_THREADS=4
perf stat -r 5 -a -e power/energy-cores/,power/energy-pkg/,power/energy-ram/ ~/proyecto2PARALELO/release/img-soa in out mono > /dev/null
echo "8 threads"
export OMP_NUM_THREADS=8
perf stat -r 5 -a -e power/energy-cores/,power/energy-pkg/,power/energy-ram/ ~/proyecto2PARALELO/release/img-soa in out mono > /dev/null
echo "16 threads"
export OMP_NUM_THREADS=16
perf stat -r 5 -a -e power/energy-cores/,power/energy-pkg/,power/energy-ram/ ~/proyecto2PARALELO/release/img-soa in out mono > /dev/null

export OMP_SCHEDULE="dynamic"
echo "##### Schedule: ${OMP_SCHEDULE} #####"
echo ""
echo "1 thread"
export OMP_NUM_THREADS=1
perf stat -r 5 -a -e power/energy-cores/,power/energy-pkg/,power/energy-ram/ ~/proyecto2PARALELO/release/img-soa in out mono > /dev/null
echo "2 threads"
export OMP_NUM_THREADS=2
perf stat -r 5 -a -e power/energy-cores/,power/energy-pkg/,power/energy-ram/ ~/proyecto2PARALELO/release/img-soa in out mono > /dev/null
echo "4 threads"
export OMP_NUM_THREADS=4
perf stat -r 5 -a -e power/energy-cores/,power/energy-pkg/,power/energy-ram/ ~/proyecto2PARALELO/release/img-soa in out mono > /dev/null
echo "8 threads"
export OMP_NUM_THREADS=8
perf stat -r 5 -a -e power/energy-cores/,power/energy-pkg/,power/energy-ram/ ~/proyecto2PARALELO/release/img-soa in out mono > /dev/null
echo "16 threads"
export OMP_NUM_THREADS=16
perf stat -r 5 -a -e power/energy-cores/,power/energy-pkg/,power/energy-ram/ ~/proyecto2PARALELO/release/img-soa in out mono > /dev/null

export OMP_SCHEDULE="guided"
echo "##### Schedule: ${OMP_SCHEDULE} #####"
echo ""
echo "1 thread"
export OMP_NUM_THREADS=1
perf stat -r 5 -a -e power/energy-cores/,power/energy-pkg/,power/energy-ram/ ~/proyecto2PARALELO/release/img-soa in out mono > /dev/null
echo "2 threads"
export OMP_NUM_THREADS=2
perf stat -r 5 -a -e power/energy-cores/,power/energy-pkg/,power/energy-ram/ ~/proyecto2PARALELO/release/img-soa in out mono > /dev/null
echo "4 threads"
export OMP_NUM_THREADS=4
perf stat -r 5 -a -e power/energy-cores/,power/energy-pkg/,power/energy-ram/ ~/proyecto2PARALELO/release/img-soa in out mono > /dev/null
echo "8 threads"
export OMP_NUM_THREADS=8
perf stat -r 5 -a -e power/energy-cores/,power/energy-pkg/,power/energy-ram/ ~/proyecto2PARALELO/release/img-soa in out mono > /dev/null
echo "16 threads"
export OMP_NUM_THREADS=16
perf stat -r 5 -a -e power/energy-cores/,power/energy-pkg/,power/energy-ram/ ~/proyecto2PARALELO/release/img-soa in out mono > /dev/null