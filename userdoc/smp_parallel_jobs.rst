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


