GPU parallel jobs
=================

The hosts that have K20m Nvidia GPUs are node01 -> node08.

To monitor GPU resources usage through:

.. code-block:: bash

   lsload -l

more info at the following link:

   https://www.ibm.com/support/knowledgecenter/en/SSETD4_9.1.2/lsf_admin/define_gpu_mic_resources.html

A sample job script to submit a GPU job looks like

.. code-block:: bash
   :linenos:

   #BSUB -J my_tensorflow_job
   #BSUB -n 1
   #BSUB -oo my_tensorflow_job.o%J
   #BSUB -eo my_tensorflow_job.e%J
   #BSUB -a gpushared
   #BSUB -m node01

The list of hosts is specified on the last line (in this case ``node01``). To
request more hosts, more nodes can be added to list, such as:

.. code-block:: bash

   #BSUB -m node01 node02 node03

