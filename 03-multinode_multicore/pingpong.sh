

module load impi-trial/5.0.1.035

rm pingpong.txt

for i in $(seq 1 3); do
	mpirun -np 2 /u/shared/programs/x86_64/intel/impi_5.0.1/bin64/IMB-MPI1 -iter 10000 PingPong >> /home/mzullich/HPC/03-multinode_multicore/pingpong.txt
done

module purge
