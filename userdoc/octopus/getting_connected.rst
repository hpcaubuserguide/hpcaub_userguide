Getting connected
-----------------
.. _Getting_started_octopus:

Connecting to a terminal
========================

When on the AUB network (also valid when connected through the VPN service
https://servicedesk.aub.edu.lb/TDClient/1398/Portal/Requests/Service/29740/Secure-Socket-Layer-Virtual-Private-Network-SSL-VPN ),
any of the following methods can be used to login to the head node of the cluster.

.. code-block:: bash

    ssh my_user_name@octopus.aub.edu.lb   # preferred
    ssh my_user_name@ohead1.aub.edu.lb    # optional  (not recommended)
    ssh my_user_name@ohead2.aub.edu.lb    # optional  (not recommended)

TIP: Passwordless login can be set up to avoid typing the password every time and
     is safer than saving the password in the ssh client or re-typing it.

.. warning:: SECURITY: make sure to change your account password after the
 administrators have created your account. To change the account password
 after logging in, use the command ``passwd``

.. note:: direct ssh access to the compute nodes is disabled and not allowed.

Tools for connecting
====================

Any of the following can be used to connect to Octopus:

   - native ssh on linux or mac (recommended)
   - `msys2 <https://www.msys2.org>`_ (recommended on windows) [execute ``pacman -S openssh rsync``]
   - `mobaxterm <https://mobaxterm.mobatek.net>`_ (most user friendly) [install the portable version]
   - winscp: https://winscp.net/eng/index.php
   - putty: https://putty.org/


Generating a ssh private-public key pair
========================================

SSH keys can be used to authenticate yourself to login to the cluster. This is
the recommended method and is more secure than typing in password or saving
the password in the ssh client (e.g putty). The generated key pair will allow
you to login to the cluster from your local machine.


.. code-block:: text

       my machine         ---------->    HPC cluster
       (linux/win/mac)                   (linux)

on linux and mac
^^^^^^^^^^^^^^^^

The key pair consists of two files:

   - public key : ``~/.ssh/id_ed25519.pub``
   - private key: ``~/.ssh/id_ed25519``

execute the following command in a terminal on your machine:

.. code-block:: bash

   # create the ssh directory and set the correct permission flag
   my machine> mkdir -p ~/.ssh
   my machine> chmod 700 ~/.ssh

   # generate an ed25519 key pair
   my machine> ssh-keygen -t ed25519 -f ~/.ssh/id_ed25519

.. warning:: this will overwrite any keys that already exist. You can specify
 a new identity name using the ``-f my_output_keyfile``

.. note:: this same process can be done on windows also from the command line
 assuming that you already have openssh installed. (e.g using ``msys2``)

.. todo:: add a screencast showing how to generate an ssh key pair on linux/mac
   and log in for the first time. The previous SharePoint-hosted screencast has
   expired and was removed. Replace it with the new "SSH keys and first login"
   recording once it has been reviewed and hosted.

on windows using mobaxterm
^^^^^^^^^^^^^^^^^^^^^^^^^^

``Mobaxterm`` can be used to generate a ssh private-public key pair.
`screencast <http://website.aub.edu.lb/it/hpc/SiteAssets/Pages/faq/generate_ssh_public_private_key_pair_mobaxterm_windows_and_enable_passwordless_login.mp4>`__

.. todo:: review this MobaXterm screencast (it is also linked in the login
   section below) and update or re-record it if it no longer matches the
   current MobaXterm version or the steps on this page.

Login to the HPC cluster using a ssh public key
===============================================

At this point, it is assumed that you already have a ssh identity
(public-private key pair). If not, see the section above.

on linux/mac
^^^^^^^^^^^^

to push your public key to the cluster, the command ``ssh-copy-id`` can be
used.

.. code-block:: bash

    $ ssh-copy-id -i ~/.ssh/id_ed25519.pub test02@octopus.aub.edu.lb

To test if the key has been added correctly:

.. code-block:: bash

    $ ssh -i ~/.ssh/id_ed25519 test02@octopus.aub.edu.lb

`screencast <http://website.aub.edu.lb/it/hpc/SiteAssets/Pages/faq/login_with_ssh_key_linux.mp4>`__

.. todo:: review this screencast of logging in with an ssh key on linux and
   re-record it if it no longer matches the steps above (ed25519 key,
   ``ssh-copy-id -i ~/.ssh/id_ed25519.pub``).

on windows with mobaxterm
^^^^^^^^^^^^^^^^^^^^^^^^^

The second part of the following `screencast <http://website.aub.edu.lb/it/hpc/SiteAssets/Pages/faq/generate_ssh_public_private_key_pair_mobaxterm_windows_and_enable_passwordless_login.mp4>`_ covers using mobaxterm and a ssh
identity to log in without a password.

Connecting to a graphical user interface
========================================

VNC session are useful only if you want to have a desktop like environment that runs
on the HPC cluster but is displayed on your computer with which the user can interact
(e.g with a mouse). Such desktop environments are useful for example for lightweight
visualizations of data that are rendered on the HPC cluster or for testing and prototyping.
In this section the procedure for creating a VNC session on the head node is described.

.. note::

   VNC session on the head node should be restricted for non-compute or memory or input/output
   intensive tasks. For demanding interactive work with a desktop environment use the job script
   for running a VNC server on a :ref:`compute node <interactive_job_octopus_anchor>` that has
   significantly more resources than the head node and significantly more rendering power on
   the GPU nodes.

VNC session are not needed for command line work or for running batch jobs.

VNC clients
^^^^^^^^^^^

VNC is a simple way to join a remote desktop session on the cluster. There
are several flavours and clients of VNC. We recommend the following:

   - realVNC: https://www.realvnc.com/en/connect/download/viewer/linux/  (easy)
   - TigerVNC: https://wiki.archlinux.org/title/TigerVNC                 (easy-advanced)

TigerVNC can be easily installed on most linux operating systems. RealVNC
is more user friendly and is available for most common operating systems.

Creating SSH tunnels
====================

SSH tunnels are handy for redirecting traffic from one host/port to another.
Here are some links on how to create tunnels on various platforms, since we
will be using them in what follows:

  - native linux tunnel https://www.revsys.com/writings/quicktips/ssh-tunnel.html
  - tunnels with putty
        + https://www.youtube.com/watch?v=7YNd1tFJfwc
  - tunnels with powershell https://www.youtube.com/watch?v=gh03CpaUxbQ
  - tunnels with mobaxterm
        + https://blog.mobatek.net/post/ssh-tunnels-and-port-forwarding/
        + https://mobaxterm.mobatek.net/documentation.html#2_1_5
  - contact it.helpdesk and mention ``HPC getting connected``

Example: reaching a port on the cluster from your machine
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following example uses two terminals. In the first one, log in to the
cluster and start a small web server on port ``8765``. Binding it to
``127.0.0.1`` means it only accepts connections from the head node itself, so it
cannot be reached directly from your machine:

.. code-block:: bash

    # terminal 1: log in to the cluster, then start the web server there
    $ ssh test02@octopus.aub.edu.lb
    $ python3 -m http.server 8765 --bind 127.0.0.1

In a second terminal on your own machine, nothing is listening on port ``8765``
yet, so the request fails:

.. code-block:: bash

    # terminal 2: on your machine
    $ curl http://localhost:8765
    curl: (7) Failed to connect to localhost port 8765: Connection refused

Now open the tunnel from the same terminal and repeat the request. This time
``curl`` prints the directory listing returned by the web server on the cluster:

.. code-block:: bash

    $ ssh -f -N -L 8765:localhost:8765 test02@octopus.aub.edu.lb
    $ curl http://localhost:8765

The options of the tunnel command are:

  - ``-L 8765:localhost:8765``: listen on port ``8765`` of your machine and
    forward everything sent to it to ``localhost:8765`` as seen from the cluster,
    i.e. the web server started in the first terminal. The general form is
    ``-L local_port:destination_host:destination_port``.
  - ``-N``: do not run a remote command, only forward the port.
  - ``-f``: go to the background after logging in, so the terminal can still be used.

If port ``8765`` is already in use, pick another port number (on the cluster,
``random_unused_port`` prints a free one). When you are done, stop the web server
with ``Ctrl+C`` in the first terminal and end the background ``ssh`` process that
holds the tunnel, e.g. find its process id with ``ps aux | grep "ssh -f -N -L"``
and ``kill`` it.

The :ref:`Jupyter notebook <jupyter_notebook_job_octopus>` and
:ref:`VNC / noVNC <create_vnc_tunnel>` instructions use the same pattern: they ask
you to run an ``ssh -L`` command on your machine and then connect to ``localhost``
on the forwarded port.
