.. _slurm_cheatsheet:

SLURM cheatsheet help
---------------------

This page is dedicated to commonly used SLURM commands with short tips and howto
quickies. You can find more details in the official SLURM command summary:

   - https://slurm.schedmd.com/pdfs/summary.pdf

Submitting a job
================
In order to submit a job, a script compatible with the scheduler directives
should be passed to ``sbatch``

.. code-block:: bash

    $ sbatch my_job_script.sh

To submit an interactive for testing and/or debugging/development the
``srun`` command can be used

.. code-block:: bash

    # single core interactive bash terminal on a compute node (e.g for development)
    $ srun --pty /bin/bash

    # allocate a cpu only job (specify resources details)
    $ srun --partition=normal --nodes=1 --ntasks-per-node=4 --cpus-per-task=1 --mem=8000 --account=my_project --time=0-01:00:00 --pty /bin/bash

    # allocate a gpu job
    $ srun --partition=gpu --nodes=1 --ntasks-per-node=1 --cpus-per-task=1 --mem=8000 --gres=gpu --account=my_project --time=0-01:00:00 --pty /bin/bash

List of running jobs
====================

The list of jobs specific to the current user (i.e you) that are queued or
running

.. code-block:: bash

    $ squeue

The list of jobs running or queued on the cluster

.. code-block:: bash

    $ squeue -a

To show the estimated starting time of a pending job

.. code-block:: bash

    $ squeue --start -j <job_id>

Remove a job from the queue
===========================

Use ``squeue`` to query the running jobs and get the ``JOBID``. Once the
job id (that is an integer in the first column of the output of ``squeue``)
of the job to be killed is known, execute:

.. code-block:: bash

    $ scancel job_to_be_killed_id

List of hosts and queues/partitions on the cluster
==================================================

.. _hosts_and_partitions:

.. code-block:: bash

    $ sinfo

To see the details of the compute nodes with their respective specs

.. code-block:: bash

    $ sinfo_all

.. code-block:: bash

    NODELIST  STATE   AVAIL CPUS CPU_LOAD S:C:T  MEMORY   FREE_MEM   ACTIVE_FEATURES      REASON
    anode01   idle    up    16   0.01     2:8:1  64000    60024      intel                none
    anode02   idle    up    16   0.01     2:8:1  64000    59931      intel                none
    anode03   drain*  up    16   N/A      2:8:1  64000    N/A        intel                forced admin maintenance
    anode04   mix     up    16   5.52     2:8:1  64000    58422      intel                none
    anode05   drain*  up    16   N/A      2:8:1  64000    N/A        intel                forced admin maintenance
    anode06   idle    up    16   0.05     2:8:1  64000    60072      intel                none
    anode07   idle    up    16   0.01     2:8:1  64000    60059      intel                none
    anode08   idle    up    16   0.30     2:8:1  64000    48742      intel                none
    anode09   alloc   up    16   14.94    2:8:1  64000    45049      intel                none
    anode10   alloc   up    16   15.01    2:8:1  64000    44856      intel                none
    anode11   idle    up    16   0.11     2:8:1  64000    15586      intel                none
    anode12   alloc   up    16   14.97    2:8:1  64000    44556      intel                none
    anode13   alloc   up    16   15.01    2:8:1  64000    44615      intel                none
    anode14   idle    up    16   0.02     2:8:1  64000    60136      intel                none
    anode15   idle    up    16   0.32     2:8:1  64000    18936      intel                none
    anode16   drain*  up    16   N/A      2:8:1  64000    N/A        intel                forced admin maintenance
    onode01   drain   up    16   0.28     2:8:1  64000    372        intel                forced admin maintenance
    onode02   drain   up    16   0.01     2:8:1  64000    14997      intel                forced admin maintenance
    onode03   drain   up    16   0.01     2:8:1  64000    18031      intel                forced admin maintenance
    onode04   drain   up    16   0.01     2:8:1  64000    62878      intel                forced admin maintenance
    onode05   drain   up    16   0.01     2:8:1  64000    56410      intel                forced admin maintenance
    onode06   drain   up    16   0.01     2:8:1  64000    60209      intel                forced admin maintenance
    onode07   alloc   up    16   8.56     2:8:1  64000    59163      amd                  none
    onode08   alloc   up    16   5.06     2:8:1  64000    43996      amd                  none
    onode09   alloc   up    16   15.43    2:8:1  64000    44786      amd                  none
    onode10   alloc   up    8    3.60     1:8:1  128000   115136     amd                  none
    onode11   drain   up    8    0.01     1:8:1  128000   1331       amd                  forced admin maintenance
    onode12   alloc   up    8    3.37     1:8:1  128000   114551     amd                  none
    onode13   alloc   up    64   21.38    8:8:1  256000   187591     amd                  none
    onode14   alloc   up    64   0.01     8:8:1  256000   247124     amd                  none
    onode15   alloc   up    64   0.02     8:8:1  256000   244880     amd                  none
    onode16   alloc   up    64   19.47    8:8:1  500000   432007     amd                  none
    onode17   alloc   up    8    1.77     1:8:1  128000   119120     amd                  none
    onode18   alloc   up    16   7.67     2:8:1  64000    43999      amd                  none
    onode19   alloc   up    16   1.15     2:8:1  64000    56966      amd                  none
    onode20   drain   up    12   0.01     2:6:1  20000    11140      intel                forced admin maintenance
    onode21   drain*  up    12   N/A      2:6:1  20000    N/A        intel                forced admin maintenance
    onode22   drain*  up    12   N/A      2:6:1  20000    N/A        intel                forced admin maintenance
    onode23   idle    up    12   0.01     2:6:1  20000    4579       intel                none
    onode24   drain*  up    12   N/A      2:6:1  20000    N/A        intel                forced admin maintenance
    onode25   drain*  up    12   N/A      2:6:1  20000    N/A        intel                forced admin maintenance
    onode26   alloc   up    8    2.18     1:8:1  32000    24224      amd                  none
    onode27   mix     up    32   1.22     1:32:1 32000    21281      amd                  none

To see the details of the available partition with their respective specs

.. code-block:: bash

    $ sinfo_partitions

.. code-block:: bash

    PARTITION           TIMELIMIT           MAX_CPUS_PER_NODE   NODES               JOB_SIZE            CPUS                MEMORY              GRES                NODES(A/I/O/T)      NODELIST
    normal*             1-00:00:00          UNLIMITED           11                  1-infinite          16                  64000               (null)              5/0/6/11            onode[01-09,18-19]
    medium              1-00:00:00          UNLIMITED           2                   1-infinite          12                  20000               (null)              0/0/2/2             onode[20-21]
    mediumdev           5-00:00:00          UNLIMITED           2                   1-infinite          12                  20000               (null)              0/1/1/2             onode[22-23]
    gpu                 6:00:00             UNLIMITED           1                   1-infinite          32                  32000               gpu:v100d32q:1      1/0/0/1             onode27
    gpu                 6:00:00             UNLIMITED           5                   1-infinite          8                   32000+              gpu:v100d32q:2      4/0/1/5             onode[10-12,17,26]
    gpu                 6:00:00             UNLIMITED           7                   1-infinite          16                  64000               gpu:k20:1           1/5/1/7             anode[01-02,04-08]
    large               1-00:00:00          UNLIMITED           4                   1-infinite          64                  256000+             (null)              4/0/0/4             onode[13-16]
    arza                1-00:00:00          UNLIMITED           8                   1-infinite          16                  64000               (null)              4/3/1/8             anode[09-16]
    arza                1-00:00:00          UNLIMITED           8                   1-infinite          16                  64000               gpu:k20:1           1/5/2/8             anode[01-08]
    interactive         2:00:00             4                   23                  1                   12+                 20000+              (null)              9/4/10/23           anode[09-16],onode[0
    interactive         2:00:00             4                   8                   1                   16                  64000               gpu:k20:1           1/5/2/8             anode[01-08]
    interactive-gpu     2:00:00             4                   4                   1                   8                   128000              gpu:v100d32q:2      3/0/1/4             onode[10-12,17]
    interactive-gpu     2:00:00             4                   7                   1                   16                  64000               gpu:k20:1           1/5/1/7             anode[01-02,04-08]
    builder             4:00:00             4                   1                   1                   32                  32000               gpu:v100d32q:1      1/0/0/1             onode27
    builder             4:00:00             4                   1                   1                   16                  64000               (null)              1/0/0/1             onode07
    all                 1-00:00:00          UNLIMITED           1                   1-infinite          32                  32000               gpu:v100d32q:1      1/0/0/1             onode27
    all                 1-00:00:00          UNLIMITED           29                  1-infinite          12+                 20000+              (null)              13/4/12/29          anode[09-16],onode[0
    all                 1-00:00:00          UNLIMITED           5                   1-infinite          8                   32000+              gpu:v100d32q:2      4/0/1/5             onode[10-12,17,26]
    all                 1-00:00:00          UNLIMITED           8                   1-infinite          16                  64000               gpu:k20:1           1/5/2/8             anode[01-08]
    dev                 1-00:00:00          UNLIMITED           4                   1-infinite          16                  64000               (null)              2/1/1/4             anode[10,12,14,16]
    cudadev             3:00:00             4                   4                   1                   8                   128000              gpu:v100d32q:2      3/0/1/4             onode[10-12,17]
    cudadev             3:00:00             4                   7                   1                   16                  64000               gpu:k20:1           1/5/1/7             anode[01-02,04-08]
