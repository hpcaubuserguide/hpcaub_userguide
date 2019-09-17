Enzo
----

The enzo enviroment can be activated by executing:

.. code-block:: bash

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

.. code-block:: bash

   $ bsub < job.sh

To compile ``enzo`` from the source code see BuildEnzoFromSource_.
To compile ``enzo`` from a custom problem see BuildEnzoFromSourceCustomProblem_.


.. _BuildEnzoFromSource:

Building Enzo from source on Arza
=================================

external references
^^^^^^^^^^^^^^^^^^^

http://enzo-project.org/BootCamp.html
https://grackle.readthedocs.io/en/latest/
https://grackle.readthedocs.io/en/latest/Installation.html#downloading


dependencies
^^^^^^^^^^^^

- mercurial
- servial version of hdf5 1.8.15-patch1
- openmpi
- gcc-7.2
- libtool (for grackle)
- Intel compiler (optional)

All these dependencies/prerequisites can be loaded through

.. code-block:: bash

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

  .. code-block:: bash

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

.. code-block:: bash

   $ module load enzo

.. note:: this loaded version of enzo might not be compatible with your custom
 problem, so a simulation run might fail. But the enzo executable in the loaded
 enzo environment is needed to produce the ``Enzo_Build`` file needed to compile
 enzo for your custom problem. Or you can produce an ``Enzo_Build`` file
 yourself if you know what your are doing.

- execute

  .. code-block:: bash

    $ enzo AMRCosmology.enzo

  in the directory ``run/CosmologySimulation/AMRCosmology``

- this will generate a ``Enzo_Build`` file

- copy ``Enzo_Build`` to the enzo source code dir

  .. code-block:: bash

    $ cp run/CosmologySimulation/AMRCosmology/Enzo_Build src/enzo/Make.settings.AMRCosmology

- configure the make files with the new settings

.. code-block:: bash

   $ make machine-arza
   $ make show-config
   $ make load-config-AMRCosmology
   $ make show-config

This will change the content of ``Make.config.override``

- build enzo

  .. code-block:: bash

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


Build enzo with the Intel compiler
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To produce the enzo Makefile with the needed Intel compiler flags:

- create copy the arza makefile

  .. code-block:: bash

     cp Make.mach.arza Make.mach.arza-intel-2018u2

- do the following changes to ``Make.mach.arza-intel-2018u2``

  .. code-block:: bash

      LOCAL_GRACKLE_INSTALL = /gpfs1/apps/sw/grackle-3.2-intel-2018u2
      MACH_CC_MPI    = mpiicc  # C compiler when using MPI
      MACH_CXX_MPI   = mpiicpc # C++ compiler when using MPI
      MACH_FC_MPI    = mpiifort   # Fortran 77 compiler when using MPI
      MACH_F90_MPI   = mpiifort   # Fortran 90 compiler when using MPI
      MACH_LD_MPI    = mpiicpc # Linker when using MPI
      MACH_CC_NOMPI  = icc   # C compiler when not using MPI
      MACH_CXX_NOMPI = icpc  # C++ compiler when not using MPI
      MACH_FC_NOMPI  = ifort # Fortran 77 compiler when not using MPI
      MACH_F90_NOMPI = ifort # Fortran 90 compiler when not using MPI
      MACH_LD_NOMPI  = icpc  # Linker when not using MPI
      MACH_OPT_AGGRESSIVE  = -O3 -xHost

      #-----------------------------------------------------------------------
      # Precision-related flags
      #-----------------------------------------------------------------------

      MACH_FFLAGS_INTEGER_32 = -i4
      MACH_FFLAGS_INTEGER_64 = -i8
      MACH_FFLAGS_REAL_32    = -r4
      MACH_FFLAGS_REAL_64    = -r8

      LOCAL_LIBS_MACH   = -limf -lifcore # Machine-dependent libraries

- to compile with the new intel makefile

  .. code-block:: bash

     $ module load intel/2018u2
     $ module load grackle/3.2-intel
     $ make machine-arza-intel-2018u2
     $ make opt-high

     # (optional - use if needed)
     # or for agressive optimization, before publishing results with such
     # agressive optimization, check the scientific results with those
     # run with opt-high or even opt-debug
     $make opt-aggressive

     # compile enzo
     $ make -j16


Compile Grackle and build it
^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- download the Grackle source code and extract it (or clone it from github)

create a copy of the makefile ``Make.mach.linux-gnu``

.. code-block:: bash

   $ cp Make.mach.linux-gnu Make.mach.arza

in the ``Arza`` makefile, specify  by specifying the path to HDF5 and the
install prefix:

.. code-block:: bash

   MACH_FILE  = Make.mach.arza
   LOCAL_HDF5_INSTALL = /gpfs1/apps/sw/hdf/hdf5-1.8.15-patch1-serial-gcc-7.2
   MACH_INSTALL_PREFIX = /gpfs1/apps/sw/grackle/grackle-3.2

To build and install grackle, execute:

.. code-block:: bash

    $ cd grackle/src/clib
    $ make machine-arza
    $ make
    $ make install

Compile grackle with the Intel compiler
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Copy the makefile and create one specific to the intel compiler

.. code-block:: bash

   $ cp Make.mach.arza Make.mach.arza-intel-2018u2

.. code-block:: bash

   MACH_CC_NOMPI  = icc   # C compiler
   MACH_CXX_NOMPI = icpc  # C++ compiler
   MACH_FC_NOMPI  = ifort # Fortran 77
   MACH_F90_NOMPI = ifort # Fortran 90
   MACH_LD_NOMPI  = icc   # Linker
   MACH_INSTALL_PREFIX = /gpfs1/apps/sw/grackle/grackle-3.2-intel-2018u2

To build and install it, execute:

.. code-block:: bash

    $ module unload gcc
    $ module load intel/2018u2
    $ cd grackle/src/clib
    $ make machine-arza-intel-2018u2
    $ make
    $ make install

Using Yt to postprocess Enzo snapshots
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Yt`` can be used either in interactive mode by submitting an interactive
job :ref:`interactive job <interactive_job_arza_anchor>`, through :ref:`jupyter notebooks <jupyter_notebook_job_anchor>`,
or by using python script via regular batch jobs. A simple visualization can be
produced by executing the following (after a job is allocated):

.. code-block:: python

     import yt
     ds = yt.load("/gpfs1/john/my_enzo_simulation/DD0000/DD0000")
     print ("Redshift =", ds.current_redshift)
     p.save()

A ``.png`` file will be saved to disk in this case. In an interactive job
the images can be viewed live.