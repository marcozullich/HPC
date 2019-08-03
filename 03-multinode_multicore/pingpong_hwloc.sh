

module load impi-trial/5.0.1.035

rm /home/mzullich/HPC/03-multinode_multicore/pingpong_hwloc.txt

for i in $(seq 1 3); do
	mpirun -np 2 hwloc-bind core:0 core:7 /u/shared/programs/x86_64/intel/impi_5.0.1/bin64/IMB-MPI1 PingPong -iter 1000000 | egrep '^[ ]+[0-9]' | sed -r 's/^/same_socket/g' >> /home/mzullich/HPC/03-multinode_multicore/pingpong_hwloc.txt

	mpirun -np 2 hwloc-bind core:0 core:13 /u/shared/programs/x86_64/intel/impi_5.0.1/bin64/IMB-MPI1 PingPong -iter 1000000 | egrep '^[ ]+[0-9]' | sed -r 's/^/diff_socket/g' >> /home/mzullich/HPC/03-multinode_multicore/pingpong_hwloc.txt

	mpirun -np 2 -map-by ppr:1:node  /u/shared/programs/x86_64/intel/impi_5.0.1/bin64/IMB-MPI1 PingPong -iter 1000000 | egrep '^[ ]+[0-9]' | sed -r 's/^/diff__nodes/g' >> /home/mzullich/HPC/03-multinode_multicore/pingpong_hwloc.txt
done

module purge
