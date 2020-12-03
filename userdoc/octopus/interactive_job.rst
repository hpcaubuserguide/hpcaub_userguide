Interactive jobs - Desktop environment on a compute nodes
---------------------------------------------------------

.. _interactive_job_octopus_anchor:

Interactive jobs give the user a desktop like environment on a compute node.
Such jobs are useful for tasks where user interactions / input are needed.
For example, although ``matlab`` or ``Ansys Fluent`` jobs can be run as
batch jobs through the command line or scripts, sometimes interacting with their
GUIs is necessary.

Recommended workflow
++++++++++++++++++++

   1) :ref:`Create the VNC configuration <create_vnc_configuration>`. This step is
      done when the account is created and hence can be skipped. Execute the procedure
      described there if your VNC configuration does not exist or is corrupted.
   2) :ref:`submit the job script <submit_vnc_job>` ( e.g ``sbatch job.sh``)
   3) Get the port number after the job starts running from e.g slurm-166866.out get the VNC port number ``VNC_HEAD_PORT = 5201``.
   4) :ref:`create the tunnel <create_vnc_tunnel>`.
   5) connect using a vnc viewer to the vnc session running on the compute using e.g ``localhost:5201``


An interactive job on a compute node
++++++++++++++++++++++++++++++++++++

When the interactive job script is submitted, a vnc session is created on
the compute node. The session is terminated when the job exits or when the job
is killed.

To connect to the vnc session using a vnc viewer (client) a tunnel to the
``VNC_HEAD_PORT`` that is specified in the job script below should be created.

.. figure:: imgs/interactive_work_on_compute_nodes.png
   :scale: 100 %
   :alt:
  
details
^^^^^^^^

Create/edit folder and files
++++++++++++++++++++++++++++
.. _create_vnc_configuration:

- first check if the folder ``.vnc`` exists and has the following two files:
  ``xstartup`` and ``config`` by executing:

  .. code-block:: bash

       ls ~/.vnc

  the output should show

  .. code-block:: bash

       config  xstartup

  If these files don't exist, create them by copying the settings from a
  pre-defined directory on the shared filesystem ``/home/shared/sample_scripts/slurm_vnc_job``

  .. code-block:: bash

        rm -fvr ~/.vnc
        cp -fvr /home/shared/sample_scripts/slurm_vnc_job/.vnc ~/
        chown -Rc $USER ~/.vnc
        cp /home/shared/sample_scripts/slurm_vnc_job/job.sh ~/

  set the vnc password by executing the command (set a strong password that is
  at least 12 characters long)

  .. code-block:: bash

        vncpasswd
        # optionally set a view only password

submit the job
++++++++++++++
.. _submit_vnc_job:

The following job script can be used as a template and the resources options
can be changed to meet the demands of a particular simulation. This job
script is also included in ~/.vnc folder. After submitting the job, the
``VNC_HEAD_PORT`` is written to the ``slurm-JOBID.out`` file.

    .. code-block:: bash

        #!/bin/bash

        ## specify the job and project name
        #SBATCH --job-name=my_job_name
        #SBATCH --account=7672200

        ## specify the required resources
        #SBATCH --partition=normal
        #SBATCH --nodes=1
        #SBATCH --ntasks-per-node=1
        #SBATCH --cpus-per-task=8
        #SBATCH --mem=4000
        #SBATCH --time=0-01:00:00

        ### DO NOT EDIT BEYOND HERE UNLESS YOU KNOW WHAT YOU ARE DOING
        source ~/.bashrc

        VNC_HEAD_PORT=$(random_unused_port)
        echo "VNC_HEAD_PORT = ${VNC_HEAD_PORT}"

        JOB_INFO_FPATH=~/.vnc/slurm_${SLURM_JOB_ID}.vnc.out
        rm -f ${JOB_INFO_FPATH}

        VNC_SESSION_ID=$(vncserver 2>&1 | grep "desktop is" | tr ":" "\n" | tail -n 1)
        echo ${VNC_SESSION_ID} >> ${JOB_INFO_FPATH}

        ssh -R localhost:${VNC_HEAD_PORT}:localhost:$((5900 + ${VNC_SESSION_ID})) ohead1 -N &
        SSH_TUNNEL_PID=$!
        echo ${SSH_TUNNEL_PID} >> ${JOB_INFO_FPATH}

        sleep infinity

A copy of this file can be obtained from ``/home/shared/sample_scripts/slurm_vnc_job/job.sh``.
Altenatively create the file in your ``~/`` directory. The script can be submitted
the usual way using ``sbatch``.

.. code-block::bash

    $ sbatch job.sh

Create a ssh tunnel
+++++++++++++++++++

.. _create_vnc_tunnel:

On a **local** terminal, use the ``VNC_HEAD_PORT`` written to the ``slurm-JOBID.out``
file to create the tunnel. The tunnel can be created using other application such
as ``mobaxterm`` using its `graphical user interface <https://blog.mobatek.net/post/ssh-tunnels-and-port-forwarding/>`_.

.. code-block:: bash
		
   ssh -L localhost:<VNC_HEAD_PORT>:localhost:<VNC_HEAD_PORT> <user>@octopus.aub.edu.lb -N

Connect using a vnc viewer (client) to the ssh tunnel on localhost
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

If you're using RealVNC type in ``localhost:<VNC_HEAD_PORT>``
	
or on MobaXterm, ``session -> VNC``:

   - Remote hostname or IP address: ``localhost``
   - port: ``<VNC_HEAD_PORT>``
