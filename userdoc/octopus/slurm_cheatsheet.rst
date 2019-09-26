.. _slurm_cheatsheet:

SLURM cheatsheet help
---------------------

This page is dedicated to commonly used SLURM commands with short tips and howto
quickies. You can find more details at (first two hits on google search):

   - https://slurm.schedmd.com/pdfs/summary.pdf
   - https://www.chpc.utah.edu/presentations/SlurmCheatsheet.pdf

Submitting a job
================
In order to submit a job, a script compliant with the scheduler directives
should be passed to ``sbatch``

.. code-block:: bash

    $ sbatch my_job_script.sh

To submit an interactive for testing and/or debugging/development the
``srun`` command can be used

.. code-block:: bash

    # allocate a cpu only job
    $ srun --partition normal --nodes=1 --ntasks-per-node=4 --cpus-per-task=1 --mem=8000 -A my_project --time=0-01:00:00 --pty /bin/bash

    # allocate a cpu/gpu job
    $ srun --partition normal --nodes=1 --ntasks-per-node=4 --cpus-per-task=1 --mem=8000 --gres=gpu:v100d32q:1 -A my_project --time=0-01:00:00 --pty /bin/bash

List of running jobs
====================

The list of jobs specific to the current user (i.e you) that are queued or
running

.. code-block:: bash

    $ squeue

The list of jobs running or queueud on the cluster

.. code-block:: bash

    $ squeue -a

Remove a job from the queues
============================

Use ``squeue`` to query the running jobs and get the ``JOBID``. Once the
job id (that is an integer in the first column of the output of ``squeue``)
of the job to be killed is know, execute:

.. code-block:: bash

    $ scancel job_to_be_killed_id

List of hosts and queues/partitions on the cluster
==================================================

.. code-block:: bash

    $ sinfo
