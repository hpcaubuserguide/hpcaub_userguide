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

To see the details of the compute nodes with their respective specs

.. code-block:: bash

    $ sinfo_all

.. code-block:: bash

    NODELIST   STATE    AVAIL  CPUS  S:C:T   CPU_LOAD FREE_MEM   ACTIVE_FEATURES      REASON
    onode01    idle     up     16    2:8:1   0.01     62536      intel                none
    onode02    idle     up     16    2:8:1   0.01     63275      intel                none
    onode03    idle     up     16    2:8:1   0.01     63317      intel                none
    onode04    idle     up     16    2:8:1   0.08     63295      intel                none
    onode05    idle     up     16    2:8:1   0.06     18614      amd                  none
    onode06    idle     up     16    2:8:1   0.03     25758      amd                  none
    onode07    idle     up     16    2:8:1   0.01     59303      amd                  none
    onode08    idle     up     16    2:8:1   0.01     21531      amd                  none
    onode09    idle     up     16    2:8:1   0.01     18060      amd                  none
    onode10    idle     up     8     1:8:1   0.07     14140      amd                  none
    onode11    drain    up     8     1:8:1   0.01     32087      amd                  forced admin maintenance
    onode12    alloc    up     8     1:8:1   0.15     31365      amd                  none
    onode13    idle     up     64    8:8:1   0.01     63232      amd                  none
    onode14    idle     up     64    8:8:1   0.01     56430      amd                  none
    onode15    idle     up     64    8:8:1   0.01     63092      amd                  none
    onode16    idle     up     64    8:8:1   0.01     62363      amd                  none

To see the details of the available partition with their respective specs

.. code-block:: bash

    $ sinfo_partitions

.. code-block:: bash

    PARTITION           NODELIST            MAX_CPUS_PER_NODE   NODES               JOB_SIZE            CPUS                MEMORY              GRES                NODES(A/I/O/T)
    normal              onode[01-09,13-16]  UNLIMITED           13                  1-infinite          16+                 60000+              (null)              0/13/0/13
    normal              onode10             UNLIMITED           1                   1-infinite          8                   15000               gpu:v100d16q:1      0/1/0/1
    normal              onode[11-12]        UNLIMITED           2                   1-infinite          8                   32000               gpu:v100d32q:1      0/2/0/2
    msfea-ai            onode10             UNLIMITED           1                   1-infinite          8                   15000               gpu:v100d16q:1      0/1/0/1
    msfea-ai            onode12             UNLIMITED           1                   1-infinite          8                   32000               gpu:v100d32q:1      0/1/0/1
    cmps-ai             onode11             UNLIMITED           1                   1-infinite          8                   32000               gpu:v100d32q:1      0/1/0/1
    physics             onode[13-16]        UNLIMITED           4                   1-infinite          64                  64000               (null)              0/4/0/4
