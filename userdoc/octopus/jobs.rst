Job scripts
-----------

The following script can be used as a template to exectute some bash commands
for a serial or parallel program. This is just a template that has the most
commontly used flags. For working example see the :ref:`job scripts examples <octopus_jobs_examples>`.

**template job script**

.. literalinclude:: sample_job.sh
   :linenos:
   :language: bash

**Flags Description**

- ``#SBATCH --job-name=my_job_name``: Set the name of the job. This will appear
  e.g. when the command ``squeue`` is executed to query the queued or running jobs.
- ``#SBATCH --account=abc123``: Specify the ID of the project. This number should
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
- ``#SBATCH --mail-type=ALL``: recieve email notification for all stages of a job,
  e.g when the job starts and terminates.
- ``#SBATCH --mail-user=abc123@aub.edu.lb``: The email address to which the job
  notification emails are sent.

Job scripts examples
^^^^^^^^^^^^^^^^^^^^

.. reference the scientific applications section of this guide


.. _octopus_jobs_examples:

Below is a list of job script that can be used to run serial or parallel jobs.
For more details please refer to the :ref:`scientific computing section <octopus_scientific_computing>`.

.. note:: all the jobs below are just basic working examples and can be copied
   and modified to suit the user needs. Make sure to change the account though
   to the one that you are using.

.. note:: Every application is different and might need special flags to run
   correctly. Please consult the documentation of the application that you are
   using to make sure that you are using the correct flags. You may also
   email it.helpdesk@aub.edu.lb for advise.

serial - single core job
""""""""""""""""""""""""

.. literalinclude:: serial_single_core_job.sh
   :linenos:
   :language: bash


single node smp job
"""""""""""""""""""

.. literalinclude:: smp_single_node_job.sh
   :linenos:
   :language: bash

parallel multi-host job
"""""""""""""""""""""""

.. literalinclude:: parallel_multi_host_job.sh
   :linenos:
   :language: bash

single host GPU job
"""""""""""""""""""

.. literalinclude:: single_host_gpu_job.sh
   :linenos:
   :language: bash

multi-host GPU job
""""""""""""""""""

.. literalinclude:: multi_host_gpu_job.sh
   :linenos:
   :language: bash

Batch job submission and monitoring procedure
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- submit the job script using SLURM

  .. code-block:: bash

      $ sbatch my_job_script.sh

  This will submit the job to the queueing system. The job could run immediately
  or set in pending mode until the requested resources are available for the job
  to run.

- check the status of the job for all and your user only

  .. code-block:: bash

      $ squeue -a

  .. code-block:: bash

      $ squeue -u $USER

- check the status and the priority of the jobs for all and your user only

  .. code-block:: bash

      $ sq

  .. code-block:: bash

      $ sq -u $USER    # show only your jobs

- Check the overall status of the partitions you have access to

  .. code-block:: bash

     $ sp

- After the job is dispatched for executing (starts running), monitor the
  output by checking the ``.o`` file.

For more information on using SLURM, please consult the ``man`` pages:

.. code-block:: bash

     $ man sbatch

.. code-block:: bash

     $ man sinfo

Interactive terminal jobs
^^^^^^^^^^^^^^^^^^^^^^^^^

For light weight testing and development or debugging jobs it is possible to obtain a
terminal session on a compute node using an interactive job thruough srun.

The simplest procedure is to use srun as follows:

.. code-block:: bash

     $  srun --partition=arza -N 1  --pty /bin/bash

It is recommended to specify a small amount of resources for the interactive job, i.e a few
cores and a few GB ram and maybe one gpu if needed. The following alias can be used to
allocate one core and 2GB ram in the ``normal`` partition for 30 minutes:

.. code-block:: bash

     $ serial_job

This command is the alias for:

.. code-block:: bash

    $ srun --partition=normal -N 1 --ntasks=1 --cpus-per-task=1 --mem=2000 --time=00:30:00 --pty /bin/bash

To allocate a gpu node for interactive use, the following alias can be used:

.. code-block:: bash

     $ gpu_job

This command is the alias for:

.. code-block:: bash

    $ srun --partition=gpu --nodes=1 --ntasks-per-node=1 --cpus-per-task=4 --gres=gpu:v100d32q:1 --mem=64000 --pty /bin/bash"

Jobs time limits and checkpoints
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _octopus_jobs_checkpoints_resume:

In-order to have fair usage of the resources and the partitions (queues), different
partitions have different time limits. The maximum time limit for jobs is 3 days.
Also paritions have different priorities that are necessary for fair usage, for
example, short jobs have higher priorities than long jobs. When a job reaches
the time limit that is specified in the job script or the time limit of the
partition, it is automatically killed and removed the the queue. It is the
responsibility of the user to set the job parameters based on the requirements
of the job and the available resources.

in all the examples below it is the responsibily of the user to manage writing
the checkpoint file and loading it.

Resubmit a job automatically using job arrays
=============================================

In the following example, a job array (``#SBATCH --array=1-30%1``) is used to
indicate that the job should be run as a chain of 30 jobs back to back. Using
this flow a job can be run for arbitarily long periods, in this case and for
the sake of demonstration, this job runs for 30 days using individual jobs
that run for 1 day each. When the first job finishes, a checkpoint file
``foo.chkp`` is written to the disk and the execution of the next job starts where
`foo.chkp`` is read and the program state is restored and the execution resumes.


.. code-block:: bash

     #!/bin/bash

     #SBATCH --job-name=my_job_name
     #SBATCH --account=abc123

     ## specify the required resources
     #SBATCH --partition=normal
     #SBATCH --nodes=1
     #SBATCH --ntasks-per-node=8
     #SBATCH --cpus-per-task=2
     #SBATCH --mem=12000
     #SBATCH --time=0-01:00:00
     #SBATCH --array=1-30%1

     ## load some modules
     module load python

     # start executing the program,
     MY_CHECKPOINT_FILE=foo.chkp
     if [ -z "${MY_CHECKPOINT_FILE}" ]; then
         # checkpoint file is not found, execute this command
         python train_model_from_scratch.py
     else
         # checkpoint file is found, read it and continue training
         python train_model_from_scratch.py --use-checkpoint=${MY_CHECKPOINT_FILE}
     fi

Each job in the job array will have its own ``.out`` file suffixed with the job
array index, e.g ``my_slurm_30.out``.

resubmit a job automatically using job dependencies
===================================================

The main difference between using job dependencies and job array is that
using dependencies the job will be resubmitted infinit times until the user
decides to cancel the automatic re-submission.

.. warning:: It is important to include a wait time of a few minuites (e.g 5 min)
 so that the scheduler will not be overloaded by the recursive resubmission of
 jobs in case something goes wrong.

In the template job script below, when the job is submitted, a ``sbatch`` command
submits the dependency from within the job. The simulation/program resume procedure
is the same as that of using job arrays, i.e if a checkpoint exists, run the
program from the checkpoint, otherwise run the program and create the checkpoint.

.. code-block:: bash

     #!/bin/bash

     #SBATCH --job-name=my_job_name
     #SBATCH --account=abc123

     ## specify the required resources
     #SBATCH --partition=normal
     #SBATCH --nodes=1
     #SBATCH --ntasks-per-node=8
     #SBATCH --cpus-per-task=2
     #SBATCH --mem=12000
     #SBATCH --time=0-01:00:00

     ## submit the dependency that will start after the current job finishes
     sbatch --dependency=afterok:${SLURM_JOBID} job.sh
     sleep 300

     # start executing the program,
     MY_CHECKPOINT_FILE=foo.chkp
     if [ -z "${MY_CHECKPOINT_FILE}" ]; then
         # checkpoint file is not found, execute this command
         python train_model_from_scratch.py
     else
         # checkpoint file is found, read it and continue training
         python train_model_from_scratch.py --use-checkpoint=${MY_CHECKPOINT_FILE}
     fi
