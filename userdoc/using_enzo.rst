Using Enzo
----------

The enzo enviroment can be activated by executing:

   $ module load enzo

The pre-built ``enzo`` executable is compatible only with ``run/Hydro/Hydro-3D``
like problems.

Assuming that the problem being solved is a ``run/Hydro/Hydro-3D`` like
problem, the following script submits and runs the job on the cluster using
32 cores in total. The tasks are spread across 4 nodes with 8 cores on each
node:

.. literalinclude:: enzo/job.sh
   :linenos:
   :language: bash

After creating the job file ``job.sh``, submit the job to the scheduler

   $ bsub < job.sh

To compile ``enzo`` from the source code see BuildEnzoFromSource_.
To compile ``enzo`` from a custom problem see BuildEnzoFromSourceCustomProblem_.


.. _BuildEnzoFromSource:

Building Enzo from source on Arza
=================================

external references
^^^^^^^^^^^^^^^^^^^

http://enzo-project.org/BootCamp.html


dependencies
^^^^^^^^^^^^

- mercurial
- servial version of hdf5 1.8.15-patch1
- openmpi
- gcc-7.2

All these dependencies/prerequisites can be loaded through

   $ module load enzo/prerequisites

- download (or clone with mercurial) the enzo source code and extract it

.. code-block:: bash

    $ wget https://bitbucket.org/enzo/enzo-dev/get/enzo-2.5.tar.gz
    $ tar -xzvf enzo-2.5.tar.gz
    $ cd enzo-enzo-dev-2984068d220f

- configure it

.. code-block:: bash

    $ module load enzo/prerequisites
    $ ./configure

- change to the dir where the makefiles are located and place the following
  Arza Makefile in that directory (:download:`enzo/Make.mach.arza`)

.. literalinclude:: enzo/Make.mach.arza
   :linenos:
   :language: bash

- modify the file ``FSProb_RadiationSource.F90`` (this is necessary for gcc-7.2)

    change line 69 from

.. code-block:: fortran

        INTEGER   :: seed(12)

to

.. code-block:: fortran

        INTEGER   :: seed(33)

- now the enzo build process can be triggered through

.. code-block:: bash

    $ make machine-arza
    $ make show-config

  This command will modify the file ``Make.config.machine``

- after preparing the build make files, execute

    $ make -j8

  to compile and produce the ``enzo`` executable

- The installation has been tested with the problem ``CollapseTestNonCosmological``
  that is located at in the directory ``ENZO_SOURCE_TOPDIR/run/Hydro/Hydro-3D/CollapseTestNonCosmological/``.
  The test problem in the following link :download:`enzo/test_proglem.tar.gz
  <enzo/test_problem/CollapseTestNonCosmological.tar.gz>` can be run by
  executing ``bsub < job.sh`` after extracting the. Note: This script ``job.sh``
  of the test problem is designed run across multiple nodes.

.. _BuildEnzoFromSourceCustomProblem:

Build enzo for a custom problem
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To build enzo for the sample simulation e.g. ``run/CosmologySimulation/AMRCosmology``
after loading the enzo environment:

   $ module load enzo

.. note:: this loaded version of enzo might not be compatible with your custom
 problem, so a simulation run might fail. But the enzo executable in the loaded
 enzo environment is needed to produce the ``Enzo_Build`` file needed to compile
 enzo for your custom problem. Or you can produce an ``Enzo_Build`` file
 yourself if you know what your are doing.

- execute

   $ enzo AMRCosmology.enzo

  in the directory ``run/CosmologySimulation/AMRCosmology``

- this will generate a ``Enzo_Build`` file

- copy ``Enzo_Build`` to the enzo source code dir

   $ cp run/CosmologySimulation/AMRCosmology/Enzo_Build src/enzo/Make.settings.AMRCosmology

- configure the make files with the new settings

.. code-block:: bash

   $ make machine-arza
   $ make show-config
   $ make load-config-AMRCosmology
   $ make show-config

This will change the content of ``Make.config.override``

- build enzo

   $ make -j8

- copy the produced ``enzo.exe`` to the problem directory

- for this ``AMRCosmology`` also the ``inits.exe`` and ``ring.exe`` must be
  built. From the top level source directory

.. code-block:: bash

   # to build inits.exe
   $ cd src/inits
   $ make -j8

   # to build ring.exe
   $ cd src/ring
   $ make -j8

- copy also ``input/cool_rates.in`` into the simulation directory
  ``AMRCosmology`` and follow the instructions in notes.txt to start the
  simulation

.. note:: make sure to use ``./enzo.exe`` (that is the executable built for
 your problem) instead of just ``enzo.exe`` (that is the executable in the
 default enzo environment) in the script ``job.sh``.
