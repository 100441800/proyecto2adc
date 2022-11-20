echo "\n########## Program: img-soa in out gauss ##########"
export OMP_SCHEDULE="static"
echo "\n##### Schedule: ${OMP_SCHEDULE} #####"
echo "\n1 thread"
export OMP_NUM_THREADS=1
./release/img-soa in out gauss
echo "\n2 threads"
export OMP_NUM_THREADS=2
./release/img-soa in out gauss
echo "\n4 threads"
export OMP_NUM_THREADS=4
./release/img-soa in out gauss
echo "\n8 threads"
export OMP_NUM_THREADS=8
./release/img-soa in out gauss
echo "\n16 threads"
export OMP_NUM_THREADS=16
./release/img-soa in out gauss

export OMP_SCHEDULE="dynamic"
echo "\n##### Schedule: ${OMP_SCHEDULE} #####"
echo "\n1 thread"
export OMP_NUM_THREADS=1
./release/img-soa in out gauss
echo "\n2 threads"
export OMP_NUM_THREADS=2
./release/img-soa in out gauss
echo "\n4 threads"
export OMP_NUM_THREADS=4
./release/img-soa in out gauss
echo "\n8 threads"
export OMP_NUM_THREADS=8
./release/img-soa in out gauss
echo "\n16 threads"
export OMP_NUM_THREADS=16
./release/img-soa in out gauss

export OMP_SCHEDULE="guided"
echo "\n##### Schedule: ${OMP_SCHEDULE} #####"
echo "\n1 thread"
export OMP_NUM_THREADS=1
./release/img-soa in out gauss
echo "\n2 threads"
export OMP_NUM_THREADS=2
./release/img-soa in out gauss
echo "\n4 threads"
export OMP_NUM_THREADS=4
./release/img-soa in out gauss
echo "\n8 threads"
export OMP_NUM_THREADS=8
./release/img-soa in out gauss
echo "\n16 threads"
export OMP_NUM_THREADS=16
./release/img-soa in out gauss

export OMP_SCHEDULE="auto"
echo "\n##### Schedule: ${OMP_SCHEDULE} #####"
echo "\n1 thread"
export OMP_NUM_THREADS=1
./release/img-soa in out gauss
echo "\n2 threads"
export OMP_NUM_THREADS=2
./release/img-soa in out gauss
echo "\n4 threads"
export OMP_NUM_THREADS=4
./release/img-soa in out gauss
echo "\n8 threads"
export OMP_NUM_THREADS=8
./release/img-soa in out gauss
echo "\n16 threads"
export OMP_NUM_THREADS=16
./release/img-soa in out gauss