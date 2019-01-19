Computation Chemistry
=====================

Gaussian 09
^^^^^^^^^^^

Gaussian (http://gaussian.com/) is a computational chemistry program that solves
for the electronic structure of systems starting from the fundamental laws of
quantum mechanics.

The current available version of Gaussian in ``Gaussian09``. Before using
``Gaussian``, make sure (or ask the admins) to add you the ``Gaussian`` users
group. ``Gaussian`` is a SMP parallel program, i.e it can make use of all the
cores and memory of a compute node.

Running Gaussian
^^^^^^^^^^^^^^^^

Sample job script
+++++++++++++++++

.. code-block:: bash

    #!/bin/bash
    #BSUB -J gaussian09
    #BSUB -q 32-hours
    #BSUB -n 16
    #BSUB -oo my_job.o%J
    #BSUB -eo my_job.e%J
    #BSUB -R "span[ptile=16]"

    module load gaussian/09

    g09 < my_input.com > run_output.log

