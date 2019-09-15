SMP parallel jobs
-----------------

openmp
======

In the following example, a simple ``C`` program is compiled using gcc with
openmp support. Each thread prints a message with its thread index.

.. note:: the number of threads is set through the ``OMP_NUM_THREADS``
 environment variable.

.. literalinclude:: openmp_hello_world.c
   :linenos:
   :language: C

To build and submit the job to the queue

.. literalinclude:: smp_openmp_job.sh
   :linenos:
   :language: bash

allocate a node exclusively
===========================

To allocate all the resources of a node just for yourself, a user must use the
flag ``-R "span[ptile=16]"`` that forces the scheduler to place all the 16
cores specified with the ``-n 16`` flag on the same host.


.. code-block:: bash
   :linenos:

    #BSUB -J my_full_node_job
    #BSUB -n 16
    #BSUB -oo my_job.o%J
    #BSUB -eo my_job.e%J
    #BSUB -R "span[ptile=16]"

    module load module1
    module load module2

    ./run_command_1
    ./run_command_2

Setting the core affinity
=========================

The ``-n`` flag of ``bsub`` specifies the number of slots, but this does not
set the affinity. For example a job submitted with ``-n 1`` is stil lable to
use all the cores on the node it is running on. Setting the core affinity
could potentialy improve the performance of compute intensive jobs.

In this sample script

.. code-block:: bash

   #BSUB -J test1
   #BSUB -n 1
   #BSUB -R "affinity[thread(1,same=core)]"
   #BSUB -oo my_mpi_job.o%J
   #BSUB -eo my_mpi_job.e%J

   export OMP_NUM_THREADS=16
   ./a.out

one slot is requested through the ``-n 1`` flag. The "process" is assigned to
one and only one core through ``"affinity[thread(1,same=core)]"``. Thus
irrespective of the ``export OMP_NUM_THREADS=16`` the program ``a.out`` can
not run on other cores. To incrase the number of cores available, the number of
threads can be changed to any number by setting N_CORES to the desired value
``"affinity[thread(N_CORES,same=core)]"``, e.g the follwoing
``"affinity[thread(4,same=core)]"`` requests 4 cores and binds the threads to
these 4 cores throughout the execution of the jobs.



