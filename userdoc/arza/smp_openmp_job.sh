#BSUB -J myjob
#BSUB -oo myjob.o%J
#BSUB -eo myjob.e%J

module load gcc/7.2.0

# compile the program
gcc openmp_hello_world.c -fopenmp -o openmp_hello_world

# submit the program to the queue
export OMP_NUM_THREADS=4
./openmp_hello_world
