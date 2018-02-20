Example job script for serial jobs
----------------------------------

Serial job
==========

The following script can be used as a template to exectute some bash commands.
One cpu core is allocated. The job name is ``myjob``, the standard output is
dumped to ``myjob.oNNNNN`` where ``NNNNN`` is the job id assigned by the
scheduler. The executed command just writes ``hello world`` to stdout.

.. literalinclude:: serial_job.sh
   :linenos:
   :language: bash

Serial job: matlab
==================

Sample script for running a matlab job

.. literalinclude:: serial_job_matlab.sh
   :linenos:
   :language: bash
