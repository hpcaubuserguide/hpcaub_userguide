Python
------

The python environment can be activated using the command:

.. code-block:: bash

    module load python/3

Most of the python environment are set up based on ``anaconda`` in the
``/gpfs1/apps/sw/miniconda/`` directory.

Users who wish to extend/create custom python these environment can:

  - use the flag ``--user`` when using pip. For example to install ``ipython``
    a user can issue the command:

    .. code-block:: bash

          pip install --user ipython

    This will install ``ipython`` to ``~/.local/lib/python3.6/site-packages``.
    Users can check whether the imported package is the one installed in their
    home directory by importing it and printing it, e.g

    .. code-block:: ipython

        import IPython
        print(IPython)
        >>> <module 'IPython' from '/gpfs1/john/.local/lib/python3.6/site-packages/IPython/__init__.py'>

  - a similar approach can be done for ``anaconda`` environemnts.

    * new conda environment in a custom location

      .. code-block:: bash

          conda create --prefix /gpfs1/john/test-env python=2.7

  - ``virtualenvs`` are by default created in the home directory ``~/.virtualenvs``.
    It might be also useful to use the package ``Virtualenvwrapper``.

  - use ``pipenv`` that is a new and powerful way to creating and managing python
    environments. The following an excellent guide on getting started with
    ``pipenv`` https://robots.thoughtbot.com/how-to-manage-your-python-projects-with-pipenv

  - install anaconda locally in their home directories

  - compile and install ``python`` from source. This is non-trivial and requires
    good knowledge of what the user is doing, but gives full control on the build
    process and customization of python.

Connecting to a Jupyter-Lab notebook with the HPC backend
=========================================================

.. _jupyter_notebook_job_anchor:

Jupyter notebooks (http://jupyter.org/) are very handy for prototyping, testing
and running interactive computations in Python, R, C#, C++ and many other
languages https://github.com/jupyter/jupyter/wiki/Jupyter-kernels from the web
browser on your local terminal/workstation (local client). Also a notebook
can be fully exectued on the compute nodes.

To submit a job that runs a notebook server on one of the compute nodes,
the following job script can be used:


Assuming that there is already a vnc session running

.. literalinclude:: jupyter/job.sh
   :linenos:
   :language: bash

From lines 1 to 4 the job resource options are set (for more info on
using the scheduler click :ref:`here <_lsf_cheatsheet>`)

On the last two lines, the jupter notebook server is launched using port
38888 and in the last line, traffic to the port 38888 from the head node (head2)
is forwarded to the same port on the compute node.

.. note::

   The port number 38888 is arbitrary, it is recommended to use any other
   **available** port other than 38888, since probably many other users will
   use 38888 by mistake. Basically, if you run into problem and things don't work
   chose a port number > 1000.

In the following screencast the whole processes is demonstrated both for linux
and windows clients <`linux <http://website.aub.edu.lb/it/hpc/SiteAssets/Pages/faq/jupyter_with_hpc_backend_linux.mp4>`_> <`windwos <http://website.aub.edu.lb/it/hpc/SiteAssets/Pages/faq/jupyter_with_hpc_backend_windows.mp4>`_>

Access token of the jupyer server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The access token can be found in the file ``jupyter.log`` in the job directory
along with a url through which you can connect to the server.

It is possible to set a fixed password or disable a password prompt.
Both are explained in http://jupyter-notebook.readthedocs.io/en/stable/public_server.html

Connect to the jupyter server from a client (recommended)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

After the job is submitted it is possible to connect to the jupyter server (that
is running on the compute node) using ssh tunnels from your local client machine's
web browser. To create the tunnel, execute (on your local terminal)

.. code-block:: bash

      $ ssh -L localhost:38888:localhost:38888 hpc.aub.edu.lb -N

The diagram for the steps involved is:

After creating the tunnel, you can access the server from your browser by
typing in the url (with the token) found in ``jupyter.log`` (see previous
section)

.. figure:: jupyter/jupyter_hpc_usage_model.png
   :scale: 100 %
   :alt:

Connect to the jupyter server on the head node (not recommended)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. warning:: Users must be aware that the head nodes are intended for light
 computations only. Thus, users must be self conscious about the cpu and memory
 consumption of the notebook running on the head node, although the heavy work
 is being done on the compute nodes. This mode of using the notebook is not
 recommended since it is easy for a user to overlook resource usage and clog
 the head node and possible bring down the whole cluster.

After submitting the script, open a browser (e.g. firefox) on the head node
in your desktop of the vnc session and open the page

.. code-block:: bash

      /gpfs1/apps/sw/firefox/firefox-45.0/firefox http://localhost:38888/?token=a3b51a9ee42324d6a371002e433f5ca863ea60c4733b087a
