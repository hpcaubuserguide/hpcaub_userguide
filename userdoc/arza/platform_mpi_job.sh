#BSUB -J my_mpi_job
#BSUB -n 1
#BSUB -oo my_mpi_job.o%J
#BSUB -eo my_mpi_job.e%J

module load mpi/platform/9
mpirun -lsf my_program