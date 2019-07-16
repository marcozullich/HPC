module purge
module load openmpi

rm *results.txt



#serial pi
echo serial
gcc pi.c -o serial.out

for i in $(seq 1 10); do
    echo Iteration ${i}
    # output time in millisec - run on 10M iter
    { time ./serial.out 10000000; } 2>&1 | grep user | sed -r 's/user\s*//g' >> serial_results.txt
done

#parallel pi
#compile
echo parallel strong
mpicc mpi_pi.c -o parallel.out

#strong scalability
for procs in 1 2 4 8 16 20 ; do
    echo proc ${procs}
    for i in $(seq 1 10); do
        echo Iteration ${i}
        # output time in millisec
        res=$({ time mpirun -np $procs parallel.out $((10000000/$procs)); } 2>&1 | grep user | sed -r 's/user\s*//g')
        echo "$res $procs" >> strong_results.txt
    done
done

#weak scalability
for procs in 1 2 4 8 16 20 ; do
    echo proc ${procs}
    for niter in 100000000 1000000000 ; do
        echo niter ${niter}
        for i in $(seq 1 10); do
            echo Iteration ${i}
            # output time in millisec
            res=$({ time mpirun -np $procs parallel.out $niter; } 2>&1 | grep user | sed -r 's/user\s*//g')
            echo "$res $procs" >> weak_results.txt
        done
    done
done

rm parallel.out serial.out

module purge