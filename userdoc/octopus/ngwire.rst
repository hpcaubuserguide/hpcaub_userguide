NGWire - secular dynamics framework
------------------------------------

The ``ngwire`` enviroment can be activated by running the following command:

.. code-block:: bash

    $ module load ngwire

You now have access to all the dependencies required to run the ``ngwire`` code.

The next step is to clone the ``ngwire`` repository and build the code.
Alternatively, you can send a copy of the ngwire code using any data transfer
method you prefer (see :ref:`data trasfers <transferring_data>`).

Building ngwire
===============

The first step is to go to the directory where ``ngwire`` is located.

.. code-block:: bash

    $ cd /path/to/ngwire
    $ python setup.py configure
    $ make all

Next, start an interactive ``python`` session with the following command:

.. code-block:: bash

    $ make ipython

Now we can import the ``ngwire`` module in python.

.. code-block:: python

    import ngwire

To run python scripts that use the ``ngwire`` module, first start an interactive
python session like shown above, and then run the script using the ``%run`` command.

.. code-block:: python

    cd /path/to/script
    %run script.py