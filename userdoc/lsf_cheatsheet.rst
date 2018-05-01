.. _lsf_cheatsheet:

LSF cheatsheet help
-------------------

This page is dedicated to commonly used LSF commands with short tips and howto
quickies. You can find more details at https://hpcwiki.genomics.upenn.edu/index.php/HPC:User_Guide

Submitting a job
================
In order to submit a job, a script compliant with the scheduler directives
should be passed to ``bsub``

.. code-block:: bash

    $ bsub < my_job_script.sh

To submitting an interactive job on a compute node

.. code-block:: bash

    $ bsub -np 64 -Is bash

List of running jobs
====================

The list of jobs specific to the current user (i.e you) that are queued or
running

.. code-block:: bash

    $ bjobs

The list of jobs running or queueud on the cluster

.. code-block:: bash

    $ bjobs -u all

Remove a job from the queues
============================

Use ``bjobs`` to query the running jobs and get the ``JOBID``. Once the
job id (that is an integer in the first column of the output of ``bjobs``)
of the job to be killed is know, execute:

.. code-block:: bash

    $ bkill job_to_be_killed_id

List of hosts on the cluster
============================

.. code-block:: bash

    $ bhosts

.. warning:: do not login to the compute nodes through ssh

List of available queues
========================

Shows all the available queues and available slots of these queues

.. code-block:: bash

    $ bqueues
