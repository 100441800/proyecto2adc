#!/bin/bash
#SBATCH -o ./stats.out
#SBATCH -e ./stats.out

export LD_LIBRARY_PATH=/opt/gcc-12.1.0/lib64
perf stat release/img-aos stats/in stats/out mono > mono-aos.txt