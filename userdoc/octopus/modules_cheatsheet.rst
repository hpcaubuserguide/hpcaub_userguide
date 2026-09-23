Applications
------------

Several programs with different versions are available on HPC systems. Having
all the versions at the disposal of the user simultaneously leads to library
conflicts and clashes.  In any production environment only the needed packages
should be included in the environment of the user.  In-order to use ``python3``
the appropriate module should be loaded.

.. code-block:: bash

    $ module load python/3

Modules are "configuration" set/change/remove environment variables from
the current environment.

Useful ``module`` commands
==========================

  - ``module avail``: display the available packages that can be loaded
  - ``module avail foo``: filter that listing to packages whose name contains ``foo``
    (e.g. ``module avail cuda`` also matches ``cudnn``, ``nvshmem``, etc. - anything
    with ``cuda`` in the name, not just the ``cuda`` package itself)
  - ``module spider foo``: search for a specific package by name and list its
    available versions (e.g. ``module spider gcc``); more targeted than
    ``module avail foo``, which matches the pattern anywhere in the name
  - ``module list``: lists the loaded packages
  - ``module load foo``: to load the package ``foo``
  - ``module rm foo``: to unload the package ``foo`` 
  - ``module purge``: to unload all the loaded packages

For detailed information on the usage of ``module`` check the man pages

.. code-block:: bash

    $ man module

.. include:: app_list.rst
