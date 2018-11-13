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
- ``#BSUB -n 1``: Specify the number of slots/cores. For more complicated
  resources allocation, have a look at the man pages of ``bsub``.
- ``#BSUB -oo myjob.o%J``: the standard output will be dumped to a file called
  ``myjob.o`` appended by the job ID assigned by the scheduler.
- ``#BSUB -eo myjob.e%J``: the standard error will be dumped to a file called
  ``myjob.o`` appended by the job ID assigned by the scheduler.
- ``#BSUB -m node10``: Specify the main node for the submitted job. If omitted
  the scheduler will pick any available node depending on the requested
  resources.
- ``#BSUB -N``: Enable email notification when the job starts and exits.
- ``#BSUB -u foo42@aub.edu.lb``: Specify the email address to be used.

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