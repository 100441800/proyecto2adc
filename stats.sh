#!/bin/bash
#SBATCH -o ./out-stats.txt
#SBATCH -e ./out-stats.txt

export LD_LIBRARY_PATH=/opt/gcc-12.1.0/lib64 
echo "AOS MONO" 
perf stat -a -d release/img-aos in out mono
perf stat -e power/energy-cores/,power/energy-pkg/,power/energy-ram/ release/img-aos in out mono  
echo "AOS HISTO" 
perf stat -a -d release/img-aos in out histo
perf stat -e power/energy-cores/,power/energy-pkg/,power/energy-ram/ -a -d release/img-aos in out histo  
echo "AOS GAUSS" 
perf stat -a -d release/img-aos in out gauss
perf stat -e power/energy-cores/,power/energy-pkg/,power/energy-ram/ -a -d release/img-aos in out gauss  
echo "SOA MONO" 
perf stat -a -d release/img-soa in out mono
perf stat -e power/energy-cores/,power/energy-pkg/,power/energy-ram/ -a -d release/img-soa in out mono  
echo "SOA HISTO" 
perf stat -a -d release/img-soa in out histo
perf stat -e power/energy-cores/,power/energy-pkg/,power/energy-ram/ -a -d release/img-soa in out histo  
echo "SOA GAUSS" 
perf stat -a -d release/img-soa in out gauss
perf stat -e power/energy-cores/,power/energy-pkg/,power/energy-ram/ -a -d release/img-soa in out gauss 