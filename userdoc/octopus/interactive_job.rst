Interactive jobs
----------------

.. _interactive_job_octopus_anchor:

Summary
^^^^^^^

To connect to a vnc session on a compute node:

  1) create a ``.vnc`` folder with ``xstartup`` and ``config`` files
	this step may already be done automatically, but make sure of the content (shown below)
  2) submit the job script (shown below)
  3) create a ssh tunnel from **your** machine to the head node of the cluster
  4) connect using a vnc viewer (client) to the ssh tunnel on **localhost**

An interactive job on a compute node
++++++++++++++++++++++++++++++++++++

Interactive jobs are useful for simulations that require human intervention
or monitoring. When the job script is submitted, a vnc session is created on
the compute node. The session is terminated when the job exits or is killed.

To connect to the vnc session using a vnc viewer (client) a tunnel to the
``VNC_HEAD_PORT`` that is specified in the job script below should be created.

.. figure:: imgs/interactive_work_on_compute_nodes.png
   :scale: 100 %
   :alt:

caveats
========
- ``VNC_HEAD_PORT`` is not used by any user on the head node and is available

  
details
^^^^^^^^   
1) create/edit folder and files
++++++++++++++++++++++++++++++++

- first check if the folder ``.vnc`` and files ``xstartup`` and ``config`` already exist.
  go to the folder:

         .. code-block:: bash
                cd ~/.vnc
  check the files:

        .. code-block:: bash

                ls

        If they don't exist, create them:

	.. code-block:: bash 
		
                cd ~/.
		mkdir .vnc
                cd ~/.vnc
		touch xstartup
		touch config

- now open ``xstartup``:

        .. code-block:: bash

                cd ~/.vnc
                vi xstartup

- and check if it contains:

	.. code-block:: bash
		
		#!/bin/sh
		
		unset DBUS_SESSION_BUS_ADDRESS
		[ -x /etc/vnc/xstartup ] && exec /etc/vnc/xstartup
		[ -r $HOME/.Xresources ] && xrdb $HOME/.Xresources
		xsetroot -solid grey
		vncconfig -iconic &
		x-terminal-emulator -geometry 80x24+10+10 -ls -title "$VNCDESKTOP Desktop" &
		mate-session &

        .. note::
                * to exit: 
                        press Esc then ":" then "q" then Enter

                * to exit without saving:
                        press Esc then ":" then "q" then "!" then Enter

                * to edit: 
                        press "i"

                * to save and exit:            
                        press Esc then ":" then "x" then Enter

- then go to ``config``:

         .. code-block:: bash

                cd ~/.vnc
                vi config

- And check if it contains:
       
        .. code-block:: bash
		
		## Supported server options to pass to vncserver upon invocation can be listed
		## in this file. See the following manpages for more: vncserver(1) Xvnc(1).
		## Several common ones are shown below. Uncomment and modify to your liking.
	
		securitytypes=vncauth
		desktop=sandbox
		#geometry=2500x1400
		#geometry=3800x2140
		geometry=1280x720
		dpi=120
		localhost
		alwaysshared
	
2) submit the job
++++++++++++++++++

	The following job script can be used as a template and the resources options
	can be changed to meet the demands of a particular simulation

		.. code-block:: bash

			#!/bin/bash

			## specify the job and project name
			#SBATCH --job-name=my_job_name
			#SBATCH -A foo_project

			## specify the required resources
			#SBATCH --partition normal
			##SBATCH --nodelist onode01
			#SBATCH --nodes=1
			#SBATCH --ntasks-per-node=1
			#SBATCH --cpus-per-task=1
			#SBATCH --mem=4000
			#SBATCH --time=0-01:00:00

			# change this port number to something that is available on the head node
			VNC_HEAD_PORT=59000

			### DO NOT EDIT BEYOND HERE UNLESS YOU KNOW WHAT YOU ARE DOING
			JOB_INFO_FPATH=~/.vnc/slurm_${SLURM_JOB_ID}.vnc.out
			rm -f ${JOB_INFO_FPATH}

			VNC_SESSION_ID=$(vncserver 2>&1 | grep "desktop is" | tr ":" "\n" | tail -n 1)
			echo ${VNC_SESSION_ID} >> ${JOB_INFO_FPATH}

			ssh -R localhost:${VNC_HEAD_PORT}:localhost:$((5900 + ${VNC_SESSION_ID})) ohead1 -N &
			SSH_TUNNEL_PID=$!
			echo ${SSH_TUNNEL_PID} >> ${JOB_INFO_FPATH}

			sleep infinity

3) create a ssh tunnel from **your** machine to the head node of the cluster
+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	on a **local** terminal:

	.. code-block:: bash
		
		ssh -L localhost:<VNC_HEAD_PORT>:localhost:<VNC_HEAD_PORT> <user>@octopus.aub.edu.lb -N	

4) connect using a vnc viewer (client) to the ssh tunnel on localhost
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	if you're using RealVNC type in ``localhost:<VNC_HEAD_PORT>``
	
	or on MobaXterm, session->VNC: 
		Remote hostname or IP address: ``localhost`` 
		
		port: ``<VNC_HEAD_PORT>``
