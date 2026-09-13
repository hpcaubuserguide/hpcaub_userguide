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

The following screencast walks through the whole workflow end to end: generating an
ed25519 key pair, copying the public key to the cluster with ``ssh-copy-id`` and
logging in with the key.

.. youtube:: m792_cUm088
   :width: 100%

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
