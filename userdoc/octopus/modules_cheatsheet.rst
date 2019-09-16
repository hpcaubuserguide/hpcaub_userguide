Modules cheatsheet
------------------

Several programs with different versions are available on HPC systems. Having
all the versions at the disposal of the user simultaneously leads to library
conflicts and clashes.  In any production environment only the needed pacakges
should be included in the environment of the user.  In-order to use ``python3``
the appropriate module should be loaded.

.. code-block:: bash

    $ module load python/3

Modules are "configuration" set/change/remove environment variables from
the current environment.

Useful ``module`` commands
==========================

  - ``module avail``
  - ``module list``
  - ``module load module_to_be_loaded``
  - ``module rm module_to_be_removed``
  - ``module purge``

For detailed information on the usage of ``module`` check the man pages

.. code-block:: bash

    $ man module