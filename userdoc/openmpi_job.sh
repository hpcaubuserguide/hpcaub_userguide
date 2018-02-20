#BSUB -J my_mpi_job
#BSUB -n 32
#BSUB -oo my_mpi_job.o%J
#BSUB -eo my_mpi_job.e%J

module load mpi/openmpi/1.6.2

hostname

mpirun ./mpi_hello_world
