Computation Chemistry
=====================

Gaussian 09
^^^^^^^^^^^

Gaussian (http://gaussian.com/) is a computational chemistry program that solves
for the electronic structure of systems starting from the fundamental laws of
quantum mechanics.

The current available version of Gaussian in ``Gaussian09``. ``Gaussian`` is a
SMP parallel program, i.e it can make use of all the cores and memory of a
compute node.

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

Common problems
^^^^^^^^^^^^^^^

Permission to use ``Gaussian``
++++++++++++++++++++++++++++++
Gaussian is a licensed software. Currently there is a limited number of licenses
available. Before using ``Gaussian``, make sure you can execute ``Gaussian``
by checking that your user account is part of the ``g09`` group. You can check
that by executing the command ``group`` on  the terminal. The output of ``group``
should contain ``g09``. If you need access to the ``g09`` group, please contact
the admins by submitting a ticket.

``/tmp`` directory is full
++++++++++++++++++++++++++

Gaussian uses the ``/tmp`` directory by default to write temporary data.
Sometimes this directory becomes full and the jobs could crash because Gaussian
can not write to ``/tmp``. You can check whether ``/tmp`` is full or not, you
can use the ``df`` command, on the compute node where the job is running.

.. code-block:: bash

   df /tmp

``Use%`` in the ouput should have enough space for your work. Alternatively
you can change the location of the defaul ``tmp`` direcotry. Please consult the
Gaussian user guide on how to do that.
