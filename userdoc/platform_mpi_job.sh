#BSUB -J my_mpi_job
#BSUB -n 1
#BSUB -oo my_mpi_job.o%J
#BSUB -eo my_mpi_job.e%J

export PATH=/opt/platform_mpi/bin:$PATH
export LD_LIBRARY_PATH=/opt/platform_mpi/lib/linux_amd64:$LD_LIBRARY_PATH
export MPI_ROOT=/opt/platform_mpi

mpirun my_program