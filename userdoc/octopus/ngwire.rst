NGWire - secular dynamics framework
------------------------------------

The ``ngwire`` enviroment can be activated by running the following command:

.. code-block:: bash

    $ module load ngwire

You now have access to all the dependencies required to run the ``ngwire`` code. 

The next step is to clone the ``ngwire`` repository and build the code. Alternatively, you can send a copy of the ngwire code using any data transfer method you prefer (see data_transfer_). 

Building ngwire
===============

The first step is to go to the directory where ``ngwire`` is located.

.. code-block:: bash

    $ cd /path/to/ngwire
    $ python setup.py configure
    $ make all


Now we can import the ``ngwire`` module in python. 

.. code-block:: python

    import ngwire