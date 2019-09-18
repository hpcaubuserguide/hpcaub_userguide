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

Connecting to a jupyter notebook server on a compute node or nodes
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A jupyter lab server is run on a compute node to which a user can connect
to using a browser on the local machine (i.e laptop/desktop/terminal)

The following job script can be used as a template to submit a job.

.. code-block:: bash

    #!/bin/bash

    #SBATCH --job-name=jupyter-servre
    #SBATCH --partition normal

    #SBATCH --nodes=1
    #SBATCH --ntasks-per-node=1
    #SBATCH --cpus-per-task=1
    #SBATCH --mem=8000
    #SBATCH --time=0-01:00:00
    #SBATCH -A foo_project

    # change this to a different number to avoid clashes with other users
    JUPYTER_PORT=38888

    module load python/3
    jupyter-lab  --no-browser --port=${JUPYTER_PORT} > jupyter.log 2>&1 &
    ssh -R localhost:${JUPYTER_PORT}:localhost:${JUPYTER_PORT} ohead1 -N

Connect to the jupyter server from a client
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

After the job is submitted it is possible to connect to the jupyter server (that
is running on the compute node) using ssh tunnels from your local client machine's
web browser. To create the tunnel, execute (on your local terminal)

.. code-block:: bash

      $ ssh -L localhost:38888:localhost:38888 octopus.aub.edu.lb -N

After creating the tunnel, you can access the server from your browser by
typing in the url (with the token) found in ``jupyter.log`` (see previous
section)

The diagram for the steps involved is:

.. figure:: jupyter/jupyter_hpc_usage_model.png
   :scale: 100 %
   :alt:
