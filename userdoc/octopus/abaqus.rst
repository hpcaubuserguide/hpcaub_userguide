Abaqus
------

`Abaqus <https://www.3ds.com/products-services/simulia/products/abaqus/>`_ is an
application that is used for solving structural simulation of multi-physics problems.

There are two main modes of running Abaqus on Octopus:

  - batch mode (using the command line or scripts)
  - graphical user interface mode (using desktop sessions)

To use any of these two the ``abaqus`` module should be loaded:

.. code-block:: bash

     module load abaqus

Graphical user interface mode
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

To launch the ``Abaqus`` GUI after connecting to a desktop environment, to launch
``CAE`` (Complete Abaqus Environment) the following command can be executed in a 
terminal:

.. code-block:: bash

    module load abaqus
    abaqus cae


Template Abaqus job (batch mode)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following job script can be used as a template to run ``abaqus`` batch jobs on
one compute node.

.. code-block:: bash

   #!/bin/bash

   ## specify the job and project name
   #SBATCH --job-name=abaqus
   #SBATCH --account=ab123

   ## specify the required resources
   #SBATCH --partition=normal
   #SBATCH --nodes=1
   #SBATCH --ntasks-per-node=1
   #SBATCH --cpus-per-task=16
   #SBATCH --mem=64000
   #SBATCH --time=1-00:00:00

   source ~/.bashrc
   module load abaqus/2020
   abaqus job=my_abaqus_sim_name input=my_sim.inp cpus=`nproc` mp_mode=threads interactive

Multi-node parallel Abaqus CAE jobs
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The following job script :ref:`below <abaqus_multinode_mpi>` can be used to run a
parallel Abaqus CAE job using multiple compute nodes. The script below can be 
downloaded by clicking :download:`here <abaqus/slurm_abaqus_mpi_job.sh>`

After the job is executed ``MPI`` must be selected in the the ``ABAQUS`` job in the GUI.

.. image:: abaqus/abaqus_mpi_job.png
   :width: 3000px

.. _abaqus_multinode_mpi:

.. code-block:: bash

   #!/bin/bash

   ## specify the job and project name
   #SBATCH --job-name=abaqus
   #SBATCH --account=ab123

   ## specify the required resources
   #SBATCH --partition=large
   #SBATCH --nodes=4
   #SBATCH --ntasks-per-node=1
   #SBATCH --cpus-per-task=64
   #SBATCH --mem=64000
   #SBATCH --time=1-00:00:00

   source ~/.bashrc
   module load abaqus/2020

   ##############################################################
   # DO NOT MODIFY BEYOND THIS UNLESS YOU KNOW WHAT YOU ARE DOING
   ##############################################################

   # dump the hosts to a text file
   SLURM_HOSTS_FILE=slurm-hosts-${SLURM_JOBID}.out

   #
   # generate the mp_host_list environment variable
   #
   srun hostname > ${SLURM_HOSTS_FILE}

   mp_host_list="["
   for HOST in `sort ${SLURM_HOSTS_FILE} | uniq`; do
       echo ${HOST}
       mp_host_list="${mp_host_list}""['${HOST}',`grep ${HOST} ${SLURM_HOSTS_FILE} | wc -l`]" 
   done

   mp_host_list=`echo ${mp_host_list} | sed 's/\]\[/\]\,\[/g'`"]"

   echo $mp_host_list

   #
   # write the abaqus environment file
   #
   ABAQUS_ENV_FILE="abaqus_v6.env"
   cat > ${ABAQUS_ENV_FILE} << EOF
   import os
   os.environ['ABA_BATCH_OVERRIDE'] = '1'
   verbose=3
   mp_host_list=${mp_host_list}
   if 'SLURM_PROCID' in os.environ:
       del os.environ['SLURM_PROCID']
   EOF

   abaqus cae -mesa

