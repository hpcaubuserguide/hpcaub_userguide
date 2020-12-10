Abaqus
------

.. code-block:: bash

     module load abaqus
     abaqus cae

Template Abaqus job (batch mode)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

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

