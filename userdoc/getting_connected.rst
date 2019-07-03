Getting connected
-----------------
.. _Getting_started:

Connecting to a terminal
========================

When on the AUB network (also valid when connected through the VPN service
https://website.aub.edu.lb/it/services/staff/configs/sslvpn/Pages/index.aspx),
any of the following mehtod can be used to login to the head node of the cluster.

.. code-block:: bash

    ssh my_user_name@hpc.aub.edu.lb       # preffered (inside AUB network only)
    ssh my_user_name@head2.aub.edu.lb     # optional  (when on AUB VPN network)
    ssh my_user_name@head1.aub.edu.lb     # optional  (when on AUB VPN network)
    ssh my_user_name@192.168.19.49        # not recommended (anywhere)

TIP: Passwordless login can be set up to avoid typing the password everytime.

.. warning:: SECURITY: make sure to change your account password after the
 administrators have created your account.

.. note:: if ``hpc.aub.edu.lb`` does not work (due to, e.g. name resolution)
 use ``head2.aub.edu.lb``. This applies to the rest of the user guide as well.

Tools for connecting
====================

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

execute the following command in a termanl on you machine:

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

to push you public key to the cluster, the command ``ssh-copy-id`` can be
used.

.. code-block:: bash

    $ ssh-copy-id -i id_rsa john@hpc.aub.edu.lb

To test if the key has been added correctly:

.. code-block:: bash

    $ ssh -i ~/.ssh/id_rsa john@hpc.aub.edu.lb

<`screencast <http://website.aub.edu.lb/it/hpc/SiteAssets/Pages/faq/login_with_ssh_key_linux.mp4>`_>

on windows using mobaxterm
^^^^^^^^^^^^^^^^^^^^^^^^^^

The second part of the following `screencast <http://website.aub.edu.lb/it/hpc/SiteAssets/Pages/faq/generate_ssh_public_private_key_pair_mobaxterm_windows_and_enable_passwordless_login.mp4>`_ covers using mobaxterm and a ssh
identity to log in without a password.

Connecting to a graphical user interface
========================================

VNC session are useful only if you want to have a desktop like environment on
the HPC cluster displayed on your computer. VNC session are not needed if you
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
Here are some links on how to create tunnels on various platfroms, since we
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

Create a VNC session
^^^^^^^^^^^^^^^^^^^^

To connect to a remote session, a vnc server must be already running on the
the HPC cluster. This can be done once by logging through the command line
and executing the command:

.. code-block:: bash

       vncserver

When the session is created, a similiar output to this screenshot is shown
on the terminal

.. figure:: imgs/vnc_session_create.png
   :scale: 50 %
   :alt:

Set a password to the new vnc session (otherwise anyone can connect to your
vnc session).

.. code-block:: bash

        vncpasswd

To make sure that the server has started, the list of running VNC server can
be obtained through:

.. code-block:: bash

       vncserver -list

keep note of the process ID (VNCPID) of the vnc server. We will assume it is
VNCPORT. The default port number if 5900, but if this port is already used,
the port number will be different.

.. figure:: imgs/vnc_server_list.png
   :scale: 50 %
   :alt:

Find the port number of a certain VNC session
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The port number is needed to create a SSH tunnel to the head node (where the
VNC server session is running). There are two ways to get the ``port`` number
of the VNC session.

For every VNC session there is an associated ``.log`` file. In the screenshot
above, there is one VNC session running, ``:7``. The log file of session ``:7``
is the file ``~/.vnc/head2:7.log``. Each user gets a different session number,
The log file of session ``:NNN`` is the file ``~/.vnc/head2:NNN.log``.

To find the port number, search for the line

    ``vncext: Listening for VNC connections on all interface(s), port 5907``

see the following screenshot.

.. figure:: imgs/vnc_session_log.png
   :scale: 50 %
   :alt:

Another way of getting the ``port`` number is using the command ``netstat``.
To find the port number of the session we want to connect to, execute

.. code-block:: bash

      netstat -tnlp | grep VNCPID

.. figure:: imgs/vnc_netstat.png
   :scale: 50 %
   :alt:

In this case the ``VNCPORT`` is ``5907`` (the first line in the screenshot).

.. warning:: make sure to set secure a password to the VNC session. This can
 be set to anything irrespective of the login password.

Obtain the port number from ``~/.vnc/head:X.log`` file
++++++++++++++++++++++++++++++++++++++++++++++++++++++

The port number is also logged to ``~/.vnc/head:X.log``, there might be several
``.log`` files in ``~/.vnc``, but usually a user gets assigned always the same
port number. Executing the following command will display one (or more) port
numbers. Try them out until one works (agian, usually there should be one
number). If all fails, kill the ``vncserver`` and delete the
``~/.vnc/head:*.log`` and re-create a vncserver.

.. code-block:: bash

      grep "Listening for VNC connections" ~/.vnc/head2\:*.log | awk '{print $NF}' | uniq

.. figure:: imgs/vnc_log_port.png
   :scale: 50 %
   :alt:


Create the ssh tunnel
^^^^^^^^^^^^^^^^^^^^^

Once the port (VNCPORT) is known, create a ssh tunnel by local port forwarding
to the bound port on the HPC cluster. On a terminal on your local machine
(i.e the machine where the vnc viewer/client will run)

.. code-block:: bash

    ssh -L localhost:VNCPORT:localhost:VNCPORT my_user_name@hpc.aub.edu.lb -N

It is recommended to use the actual IP address of the node where the vnc server
is running since the ``VNCPORT`` would most likely be closed when connected
through the VPN. An actual example could look like:

.. code-block:: bash

    ssh -L localhost:5907:localhost:5907 my_user_name@hpc.aub.edu.lb

The IP address of the HPC node where the server is running can be obtaine with
``ifconfig``

.. figure:: imgs/ifconfig.png
   :scale: 50 %
   :alt:

Once the tunnel is created, the vnc client can be used to connect to the desktop
session that is running on the HPC cluster (head node). In the example below
we will use ``realvnc``


.. figure:: imgs/vnc3.png
   :scale: 50 %
   :alt:

After creating the vnc connection (icon) you can connect by double clicking
on the shortcut icon.

.. figure:: imgs/vnc4.png
   :scale: 50 %
   :alt:

There are several options that can be set in the file ``~/.vnc/xstartup``
that allow for customized in the graphical session.


Connecting to a Jupyter-Lab notebook with the HPC backend
=========================================================

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



