Getting connected
-----------------
.. _Getting_started_octopus:

Connecting to a terminal
========================

When on the AUB network (also valid when connected through the VPN service
https://servicedesk.aub.edu.lb/TDClient/Requests/ServiceDet?ID=29740 ),
any of the following methods can be used to login to the head node of the cluster.

.. code-block:: bash

    ssh my_user_name@octopus.aub.edu.lb   # preferred
    ssh my_user_name@ohead1.aub.edu.lb    # optional  (not recommended)
    ssh my_user_name@ohead2.aub.edu.lb    # optional  (not recommended)
    ssh my_user_name@192.168.137.23       # last resort (if all of the above do not work)

TIP: Passwordless login can be set up to avoid typing the password everytime and
     is safer than saving the password in the ssh client or re-typing it.

.. warning:: SECURITY: make sure to change your account password after the
 administrators have created your account. To change the account password
 after logging in, use the command ``passwd``

.. note:: direct ssh access to the compute nodes is disabled and not allowed.

Tools for connecting
====================

- native ssh on linux or mac (recommended)
- msys2: https://www.msys2.org/ (recommended on windows)
- mobaxterm (most user freindly): https://mobaxterm.mobatek.net/
    .. note:: install the portable version, it does not require admin access
- winscp: https://winscp.net/eng/index.php
- putty: https://putty.org/


Generating a ssh private-public key pair
========================================

SSH keys can be used to authenticate yourself to login to the cluster. This is
the recommended method and is more secure than typing in password or saving
the passowrd in the ssh client (e.g putty). The generated key pair will allow
you to login to the cluster from your local machine.


.. code-block:: text

       my machine         ---------->    HPC cluster
       (linux/win/mac)                   (linux)

on linux and mac
^^^^^^^^^^^^^^^^

To generate the key files:

   - public key : ``~/.ssh/id_rsa.pub``
   - private key: ``~/.ssh/id_rsa``

execute the following command in a terminal on you machine:

.. code-block:: bash

    # first generate an ssh key on A
    my machine> ssh-keygen -t rsa -b 4096

.. warning:: this will overwrite any keys that already exist. You can specify
 a new identity name using the ``-f my_ouptut_keyfie``

.. note:: this same process can be done on windows also from the command line
 assuming that you already have openssh installed. (e.g using ``msys2``)

<`screencast <http://website.aub.edu.lb/it/hpc/SiteAssets/Pages/faq/generate_ssh_key_linux.mp4>`_>

on windwows using mobaxterm
^^^^^^^^^^^^^^^^^^^^^^^^^^^

``Mobaxterm`` can be used to generate a ssh private-public key pair.
<`screencast <http://website.aub.edu.lb/it/hpc/SiteAssets/Pages/faq/generate_ssh_public_private_key_pair_mobaxterm_windows_and_enable_passwordless_login.mp4>`_>

Login to the HPC cluster using a ssh public key
===============================================

At this point, it is assumed that you already have a ssh identity
(public-private key pair). If not, see the section above.

on linux/mac
^^^^^^^^^^^^

to push your public key to the cluster, the command ``ssh-copy-id`` can be
used.

.. code-block:: bash

    $ ssh-copy-id -i id_rsa john@octopus.aub.edu.lb

To test if the key has been added correctly:

.. code-block:: bash

    $ ssh -i ~/.ssh/id_rsa john@octopus.aub.edu.lb

<`screencast <http://website.aub.edu.lb/it/hpc/SiteAssets/Pages/faq/login_with_ssh_key_linux.mp4>`_>

on windows using mobaxterm
^^^^^^^^^^^^^^^^^^^^^^^^^^

The second part of the following `screencast <http://website.aub.edu.lb/it/hpc/SiteAssets/Pages/faq/generate_ssh_public_private_key_pair_mobaxterm_windows_and_enable_passwordless_login.mp4>`_ covers using mobaxterm and a ssh
identity to log in without a password.

Connecting to a graphical user interface
========================================

VNC sessions are useful only if you want to have a desktop like environment on
the HPC cluster displayed on your computer. VNC sessions are not needed if you
want to use the command line and submit batch jobs.

VNC clients
^^^^^^^^^^^

VNC is a simple way to join a remote desktop session on the cluster. There
are several flavours and clients of VNC. We recommend the following:

   - realVNC: https://www.realvnc.com/en/connect/download/viewer/linux/  (easy)
   - TigerVNC: https://wiki.archlinux.org/index.php/TigerVNC             (easy-advanced)

TigerVNC can be easily installed on most linux operating systems. RealVNC
is more user freindly and is available on most common operating systems.

Creating SSH tunnels
====================

SSH tunnels are handy for redirecting traffic from one host/port to another.
Here are some links on how to create tunnels on various platforms, since we
will be using them in what follows:

  - native linux tunnel https://www.revsys.com/writings/quicktips/ssh-tunnel.html
  - tunnels with putty
        + https://infosecaddicts.com/perform-local-ssh-tunneling/
        + https://www.youtube.com/watch?v=7YNd1tFJfwc
  - tunnels with powershell https://www.youtube.com/watch?v=gh03CpaUxbQ
  - tunnels with mobaxterm
        + https://blog.mobatek.net/post/ssh-tunnels-and-port-forwarding/
        + http://emp.byui.edu/ercanbracks/cs213/SSH%20tunneling%20with%20Mobaxterm.htm
  - contact it.helpdesk and mention ``HPC getting connected``
