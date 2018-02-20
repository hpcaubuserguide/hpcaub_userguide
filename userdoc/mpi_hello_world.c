#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <mpi.h>

#define MAXSTRLEN 1024

int main(int argc, char **argv)
{
    int n_procs,rank;
    char hostname[MAXSTRLEN];

    MPI_Init(&argc,&argv);

    MPI_Comm_size(MPI_COMM_WORLD, &n_procs);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    gethostname(hostname, MAXSTRLEN);

    printf("%s: rank=%05d hello world.\n", hostname, rank);
    MPI_Finalize();

    exit(0);
}
