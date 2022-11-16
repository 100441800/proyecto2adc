#!/bin/bash
#SBATCH -o ./out-stats.txt
#SBATCH -e ./out-stats.txt

export LD_LIBRARY_PATH=/opt/gcc-12.1.0/lib64 
echo "AOS MONO" 
perf stat -e power/energy-cores/,power/energy-pkg/,power/energy-ram/ -a -d release/img-aos in out mono  
echo "AOS HISTO" 
perf stat -e power/energy-cores/,power/energy-pkg/,power/energy-ram/ -a -d release/img-aos in out histo  
echo "AOS GAUSS" 
perf stat -e power/energy-cores/,power/energy-pkg/,power/energy-ram/ -a -d release/img-aos in out gauss  
echo "SOA MONO" 
perf stat -e power/energy-cores/,power/energy-pkg/,power/energy-ram/ -a -d release/img-soa in out mono  
echo "SOA HISTO" 
perf stat -e power/energy-cores/,power/energy-pkg/,power/energy-ram/ -a -d release/img-soa in out histo  
echo "SOA GAUSS" 
perf stat -e power/energy-cores/,power/energy-pkg/,power/energy-ram/ -a -d release/img-soa in out gauss 