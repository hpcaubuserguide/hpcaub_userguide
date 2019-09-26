The Matlab environment
======================

Overview
^^^^^^^^

Matlab can be used on the cluster in several configurations.

  - run jobs directly on the compute nodes of the cluster (recommended)
        + out of the box parallelism up to 64 cores (a full max size node)
        + full parallelism on the cluster (guide not available yet)
  - run jobs on a client and use the cluster as a backend (requires setup).
        + supports windows clients (guide not available yet)
        + supports linux and mac clients (guide not available yet)

Matlab on the compute nodes of the cluster
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This configuration allows the user to run MATLAB scripts on the HPC cluster
directly through the scheduler. Once the jobs are complete the user can
chose to transfer the results to a local machine and analyze them or analyze
everything on the cluster as well and e.g retrieve a final product that could
be a plot or a some data files. This setup does not require the user to have
matlab installed on their local machine.

Serial jobs
+++++++++++

No setup is required to run a serial job on the cluster.

The following job script (``matlab_serial.sh``) can be used to submit a serial job
running the matlab script ``my_serial_script.m``.

.. code-block:: bash

     #!/bin/bash

     #SBATCH --job-name=matlab-smp
     #SBATCH --partition normal

     #SBATCH --nodes=1
     #SBATCH --ntasks-per-node=1
     #SBATCH --cpus-per-task=1
     #SBATCH --mem=16000
     #SBATCH --time=0-01:00:00

     module load matlab/2018b

     matlab -nodisplay -r "run('my_smp_script.m')"


.. code-block:: matlab

    tic
    values = zeros(200);
    for i = 1:size(values, 2)
        values(i) = sum(abs(eig(rand(800))));
    end
    toc

    disp(sum(sum(values)));

The following should be present in the output

.. code-block:: text

    Elapsed time is 113.542701 seconds.
    checksum = 9.492791e+05

.. note:: the ``Elapsed time`` could vary slightly since the execution time
 depends on the load of the compute node (if it is not the only running process)
 and the ``checksum`` could vary slightly since it is based on randon numbers.

Single node (shared memory - SMP) parallel jobs
+++++++++++++++++++++++++++++++++++++++++++++++

No setup is required to run a shared memory job on the cluster. Whenever
parallelism is required, Matlab will spawn the needed workers on the local
compute node.

The following job script (``matlab_smp.sh``) can be used to submit a serial job
running the matlab script ``my_smp_script.m``.


.. note:: the only differences with a serial job are:

   - the names of the script.
   - ``--nodes=1`` must be specified otherwise the resources would be allocated
     on other nodes and would not be accessible by matlab.
   - specify the parallel profile in the ``.m`` script e.g ``parpool('local', 64)``
   - ``for`` is replaced with ``parfor`` in the ``.m`` matlab script.

.. code-block:: bash

     #!/bin/bash

     #SBATCH --job-name=matlab-smp
     #SBATCH --partition normal

     #SBATCH --nodes=1
     #SBATCH --ntasks-per-node=1
     #SBATCH --cpus-per-task=64
     #SBATCH --mem=16000
     #SBATCH --time=0-01:00:00

     module load matlab/2018b

     matlab -nodisplay -r "run('my_smp_script.m')"

for example, the content of ``my_smp_script.m`` could be:

.. code-block:: matlab

    parpool('local', 64)
    tic
    values = zeros(200);
    parfor i = 1:size(values, 2)
        values(i) = min(eig(rand(800)));
    end
    toc

The following should be present in the output

.. code-block:: text

   Elapsed time is 10.660034 seconds.
   checksum = 9.492312e+05

.. note:: the ``Elapsed time`` could vary slightly since the execution time
 depends on the load of the compute node (if it is not the only running process)
 and the ``checksum`` could vary slightly since it is based on randon numbers.
