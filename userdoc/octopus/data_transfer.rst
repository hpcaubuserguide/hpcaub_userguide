Transferring data
-----------------
.. _transferring_data:

There are several ways to transfer data from and to ``Octopus``. The following
is a subset and an incomplete list of methods and tools:

   - :ref:`scp <scp>`
   - :ref:`rsync <rsync>`
   - :ref:`winscp <winscp>`
   - :ref:`sftp <sftp>`

scp
+++

transfer/copy files from the local machine to ``~/`` on ``octopus``:

.. code-block:: bash

    scp -rp my_local_file <user>@octopus.aub.edu.lb:~/

To transfer files from ``octopus`` to the local machine ``rsync`` is more
suitable since the command should be executed on octopus and that requires
a connection from octopus to the local machine that is usually no possible
unless a ssh tunnel is created. ``rsync`` supports this out of the box.

More information on using scp can be found in the official `manual <https://linux.die.net/man/1/scp>`_.

rsync
+++++
.. _rsync

transfer/copy files from the local machine to ``~/`` on ``octopus``:

.. code-block:: bash

    rsync -PrlHvtpog my_local_file <user>@octopus.aub.edu.lb:~/

To transfer files from ``octopus`` to the local machine:

.. code-block:: bash

    rsync -PrlHvtpog <user>@octopus.aub.edu.lb:~/my_file .

More information on using rsync can be found in the official `manual <https://linux.die.net/man/1/rsync>`_.

winscp
++++++
.. _winscp

Winscp is a graphical user interface that can be used to transfer files
back and forth among the local machine and the HPC cluster. It is a free tool
that can be downloaded from the `here <https://winscp.net/eng/download.php>`_. The follwing
`tutorial <https://www.youtube.com/watch?v=xW0BQIaz7Ic&ab_channel=ExaVault>`_ is a good reference on how to use it.



sftp
++++

sftp is a command line based tool that provides the same functionality as winscp. 
To establish a secure ftp connection to octopus the following command can be used:

.. code-block:: bash

    sftp <user>@octopus.aub.edu.lb 

Once the connection is established sftp commands such as (get, put) can be used in the sftp prompt to send / receive
data (files, folders, ... etc).

More information on using rsync can be found in the official `manual <https://linux.die.net/man/1/sftp>`_.


