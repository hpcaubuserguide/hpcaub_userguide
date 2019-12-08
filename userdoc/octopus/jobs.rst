Example job script
------------------

The following script can be used as a template to exectute some bash commands
for a serial or parallel program.

.. literalinclude:: sample_job.sh
   :linenos:
   :language: bash

**Flags Description**

- ``#SBATCH --job-name=my_job_name``: Set the name of the job. This will appear
  e.g. when the command ``squeue`` is executed to query the queued or running jobs.
- ``#SBATCH --account=7561539``: Specify the ID of the project. This number should
  correspond to the project ID of the service request. Jobs without this flag
  will be rejected.
- ``#SBATCH --partition=normal``: The name of the partition, a.k.a queue to which
  the job will be submitted.
- ``#SBATCH --nodes=2``: The number of nodes that will be reserved for the job.
- ``#SBATCH --ntasks-per-node=8``: The number of cores (e.g mpi tasks) that will be
  reserved per node.
- ``#SBATCH --cpus-per-task=2``: The number of cores per task to be reserved for
  the job (e.g number of openmp threads per mpi task). The total number of cores
  reserved for the job is the product of the values of the flags ``--nodes``,
  ``--ntasks-per-node`` and ``--cpus-per-task``.
- ``#SBATCH --mem=32000``: the amount of memory per node in MB that will be
  reserved for the job. Jobs that do not specify this flag will be rejected.
- ``#SBATCH --time=1-00:00:00``: The time limit of the job. When the limit is
  reached, the job is killed by the scheduler. Jobs that do not specify this
  flag will be rejected.

Batch job submission and monitoring procedure
=============================================

- submit the job script using SLURM

  .. code-block:: bash

      $ sbatch my_job_script.sh

  This will submit the job to the queueing system. The job could run immediately
  or set in pending mode until the requested resources are available for the job
  to run.

- check the status of the job

  .. code-block:: bash

      $ squeue -a

- After the job is dispatched for executing (starts running), monitor the
  output by checking the ``.o`` file.

For more information on using SLURM, please consult the ``man`` pages:

.. code-block:: bash

   $ man sbatch