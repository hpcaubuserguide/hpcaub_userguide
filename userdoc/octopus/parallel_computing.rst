Parallel Computing
------------------

Serial applications
^^^^^^^^^^^^^^^^^^^

Symmetric multiprocessing (SMP)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

MPI parallel applications
^^^^^^^^^^^^^^^^^^^^^^^^^

.. _mpi_parallel_applications_general:

In this section we will discuss how to run MPI https://www.mpi-forum.org/ parallel applications on the HPC systems. MPI
(Message Passing Interface) is a standard for writing parallel applications that run on distributed
memory systems. MPI is a library that allows the user to write parallel applications in C, C++, or
Fortran. The MPI library provides a set of functions that allow the user to send and receive
messages between processes. The user can write a parallel application that runs on multiple
nodes by using the MPI library.

Run a simple MPI application
++++++++++++++++++++++++++++

Run a simple application using MPI
""""""""""""""""""""""""""""""""""

Run an MPI application using ``srun`` without a job script. The following example runs the
``hostname`` command on two nodes using the ``pmix`` MPI launcher.

.. code-block:: bash

    module load mpi/openmpi/4.1.4-slurm-18.08.6
    srun --mpi=pmix -n 2 hostname

The expectedd output is the hostname of the two nodes. When you run this you most probably will see
different hostnames. The output will look like this:

.. code-block:: bash

    anode01
    anode02


Run a simple MPI application that prints the hostname using C
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

.. code-block:: c

    #include <stdio.h>
    #include <unistd.h>
    #include <mpi.h>   /* PROVIDES THE BASIC MPI DEFINITION AND TYPES */


    int main(int argc, char **argv) {

      char hostname[100];

      MPI_Init(&argc, &argv); /*START MPI */

      // Get the rank of the process
      int rank;
      MPI_Comm_rank(MPI_COMM_WORLD, &rank);

      gethostname(&hostname[0], 100);

      printf("[%s] Hello world from MPI RANK %d\n", hostname, rank);

      MPI_Finalize();  /* EXIT MPI */
    }

The following job script can be used to run the above C code:

.. code-block:: bash

    #!/bin/bash

    #SBATCH --job-name=hello-world-mpi
    #SBATCH --nodes=2
    #SBATCH --partition normal
    #SBATCH --ntasks-per-node=1
    #SBATCH --cpus-per-task=1
    #SBATCH --mem=8000
    ##SBATCH --gres=gpu:v100d8q:1
    #SBATCH --time=0-01:00:00

    module load gcc/8.3.0
    module load prun
    module load pmix
    module load mpi/openmpi/4.0.1

    mpicc mpi_hello_world.c -o mpi_hello_world
    srun ./mpi_hello_world

The expected output is the hostname of the two nodes. When you run this you most probably will see
different hostnames. The output will look like this:

.. code-block:: bash

    [onode07] Hello world from MPI RANK 0
    [onode08] Hello world from MPI RANK 1

The examples above are very basic and are intended just to demonstrate minimal functionality
and a basic job script.


Hybrid parallel applications
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Embarrassingly parallel applications
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^