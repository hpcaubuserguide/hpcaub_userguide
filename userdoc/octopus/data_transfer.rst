Transferring data
-----------------
.. _transferring_data

There are several ways to transfer data from and to ``Octopus``. The following
is a subset and an incomplete list of methods and tools:

   - scp
   - rsync
   - winscp
   - sftp

rsync
+++++

transfer/copy files from the local machine to ``~/`` on ``octopus``:

.. code-block:: bash

    rsync -PrlHvtpog my_local_file <user>@octopus.aub.edu.lb:~/

To transfer files from ``octopus`` to the local machine:

.. code-block:: bash

    rsync -PrlHvtpog <user>@octopus.aub.edu.lb:~/my_file .
