#!/bin/bash
#SBATCH -o ./stats.out
#SBATCH -e ./stats.out

LD_LIBRARY_PATH=/opt/gcc-12.1.0/lib64
perf stat release/img-aos in mono-aos mono > mono-aos.txt