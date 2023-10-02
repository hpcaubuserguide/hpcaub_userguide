Oil and Gas Applications
========================

Eclipse - Petrel
^^^^^^^^^^^^^^^^

Copying Example Data
---------------------

Firstly, copy the example data from the provided directory to your home directory.
You can do this with the following command:

.. code-block:: bash

   cp -fvr /apps/sw/petrel_2019.2/2019.2/eclipse/data/ ~/eclipse_example_data

Loading the Module
------------------

Before running any simulations, make sure to load the `eclipse` module using the
following command:

.. code-block:: bash

   module load eclipse

Running the Simulation
----------------------

To run the simulation with the `GASWATER.DATA` file, use the following command:

.. note::

   Note that while Windows is case-insensitive, Linux is case-sensitive, so
   ensure the filename is written in all uppercase letters.

.. code-block:: bash

   cd ~/eclipse_example_data
   eclrun eclipse GASWATER.DATA

Modifying Parallel Execution Settings
-------------------------------------

To modify the simulation to utilize more than one core, you will need to edit
the `PARALLEL` directive in the input data file, `GASWATER.DATA`. Set it to the
desired number of cores.

.. code-block:: text

   PARALLEL
      4 /

Running with MPI
----------------

To run the simulation in parallel using MPI, generate a hostfile using `srun`,
then specify the hostfile, number of processes, and number of threads per process when invoking `eclrun`. Here is an example of how to do this:

.. code-block:: bash

   module load mpi/openmpi
   srun hostname > hostfile.out
   eclrun --hostfile hostfile.out --np 2 --threads 8 eclipse U22.DATA

In this example, we are specifying 2 MPI processes (`--np 2`) and 8 threads per
process (`--threads 8`). Ensure the `U22.DATA` file name is in uppercase, as
Linux is case-sensitive.
