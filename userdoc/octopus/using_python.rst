Python
------

The python environment can be activated using the command:

.. code-block:: bash

    module load python/3

Most of the python environment are set up based on ``anaconda`` in the
``/apps/sw/miniconda/`` directory.

Users who wish to extend/create custom python these environment can:

  - use the flag ``--user`` when using pip. For example to install ``ipython``
    a user can issue the command:

    .. code-block:: bash

          pip install --user ipython

    This will install ``ipython`` to ``~/.local/lib/python3.7/site-packages``.
    Users can check whether the imported package is the one installed in their
    home directory by importing it and printing it, e.g

    .. code-block:: ipython

        import IPython
        print(IPython)
        >>> <module 'IPython' from '/home/john/.local/lib/python3.7/site-packages/IPython/__init__.py'>

  - a similar approach can be done for ``anaconda`` environemnts.

    * new conda environment in a custom location

      .. code-block:: bash

          conda create --prefix /home/john/test-env python=3.8

  - ``virtualenvs`` are by default created in the home directory ``~/.virtualenvs``.
    It might be also useful to use the package ``Virtualenvwrapper``.

  - use ``pipenv`` that is a new and powerful way to creating and managing python
    environments. The following an excellent guide on getting started with
    ``pipenv`` https://robots.thoughtbot.com/how-to-manage-your-python-projects-with-pipenv

  - install anaconda locally in their home directories

  - compile and install ``python`` from source. This is non-trivial and requires
    good knowledge of what the user is doing, but gives full control on the build
    process and customization of python. For optimial performance, this is the
    recomended approach.

