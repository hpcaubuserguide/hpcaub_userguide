MPI parallel jobs
-----------------

OpenMPI
=======

Sample script for a MPI paralle job that uses the openmpi implementation of the
MPI standard. The hello world program ``mpi_hello_world.c`` is:

.. literalinclude:: mpi_hello_world.c
   :linenos:
   :language: C

That should be compiled with (on the terminal)

.. code-block:: bash

   module load mpi/openmpi/1.6.2
   mpicc mpi_hello_world.c -o mpi_hello_world

Alternatively the ``mpicc`` line (last line) can be included in the job script.
I.e the executable is produced at runtime when the jobs runs on the queue.

The job script is: ``openmpi_job.sh``

.. literalinclude:: openmpi_job.sh
   :linenos:
   :language: bash

Finally, submit the job

.. code-block:: bash

   bsub < openmpi_job.sh

IBM Platform MPI
================

Sample script for a MPI paralle job that uses the IBM implementation of the
MPI standard

.. literalinclude:: platform_mpi_job.sh
   :linenos:
   :language: bash

LSF sample scripts for different use cases
==========================================

LSF does the accounting with tasks (slots). The number of slots are specified
with the ``-n X`` argument that can be specified at the top of the LSF script
or on the command line.

Request X MPI tasks. In the example below X = 16.

.. code-block:: bash

    #BSUB -J my_mpi_job
    #BSUB -n 16
    #BSUB -oo my_mpi_job.o%J
    #BSUB -eo my_mpi_job.e%J

Request X MPI tasks distributed to N nodes with T mpi processes per node. In
the example below X = 32, N = 4, T = 8 ( X = N x T ). Note the span[ptile=8]
the specifies having 8 mpi tasks per node

.. code-block:: bash

    #BSUB -J my_mpi_job
    #BSUB -n 32
    #BSUB -R "span[ptile=8]"
    #BSUB -oo my_mpi_job.o%J
    #BSUB -eo my_mpi_job.e%J
