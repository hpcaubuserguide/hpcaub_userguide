Example job script
------------------

The following script can be used as a template to exectute some bash commands
for a serial or parallel programs.

.. literalinclude:: serial_job.sh
   :linenos:
   :language: bash

**Flags Description**

- ``#BSUB -J myjob``: set the name of the job. This will appear e.g. when the
  command ``bjobs`` is executed to query the queued or running jobs.
- ``#BSUB -n 8``: Specify the number of slots/cores. For more complicated
  resources allocation, have a look at the man pages of ``bsub``.
- ``#BSUB -R "span[ptile=2]``: The value of the parameter that is passed to
  ``ptile`` instructs the the scheduler to distribute 2 slots per node. This
  flag must be used in conjuction with ``-n``. In this case with ``-n 8`` the 8
  slots are spread accross 4 nodes. To allocate 1 slot per node for 8 nodes
  ``ptile=1`` must be used. This is typically useful for GPU jobs or jobs that
  require a large amount of memory. Another typical use case is to set
  ``ptile=16`` with ``-n 16``, that guarantees allocating all slots on the same
  node since there are only 16 slots per node.
- ``#BSUB -oo myjob.o%J``: the standard output will be dumped to a file called
  ``myjob.o`` appended by the job ID assigned by the scheduler.
- ``#BSUB -eo myjob.e%J``: the standard error will be dumped to a file called
  ``myjob.o`` appended by the job ID assigned by the scheduler.
- ``#BSUB -m "node10 node12``: Specify the list of the hosts where the job will
  run. If omitted (which is the recommended default) the scheduler will pick any
  available node depending on the requested resources.
- ``#BSUB -u foo42@aub.edu.lb``: Specify the email address to be used.
- ``#BSUB -N``: Enable email notification when the job starts and exits.
- ``#BSUB -B``: send an email when  the job status changes from pending to running

.. note:: For a serial job ``-n 1`` should be requested. The rest of the flags
 are arbitrary.

Batch jos submission and monitoring procedure
=============================================

- submit the job script using LSF

  .. code-block:: bash

      $ bsun < my_job_script.sh

  This will submit the job to the queueing system. The job could run immediately
  or set in pending mode until the requested resources are available for the job
  to run.

- check the status of the job

  .. code-block:: bash

      $ bjobs -u all

- After the job is dispatched for executing (starts running), monitor the
  output by checking the ``.e`` and the ``.o`` files, our any other diagnositic
  files the program created.

For more information on using LSF, please consult the ``man`` pages:

.. code-block:: bash

   $ man bsub