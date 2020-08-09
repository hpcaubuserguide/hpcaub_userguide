Molecular dynamics
------------------

LAMMPS
^^^^^^

.. code-block:: bash

    #!/bin/bash

    #SBATCH --job-name=my_lammps_job
    #SBATCH --partition=normal

    #SBATCH --nodes=1
    #SBATCH --ntasks-per-node=1
    #SBATCH --cpus-per-task=1
    #SBATCH --mem=8000
    #SBATCH --time=0-01:00:00
    #SBATCH --account=foo_project

    ## load modules here

    ## run the program


GROMACS
^^^^^^^

.. code-block:: bash

    #!/bin/bash

    #SBATCH --job-name=my_gromacs_job
    #SBATCH --partition=normal

    #SBATCH --nodes=1
    #SBATCH --ntasks-per-node=1
    #SBATCH --cpus-per-task=1
    #SBATCH --mem=8000
    #SBATCH --time=0-01:00:00
    #SBATCH --account=foo_project

    ## load modules here

    ## run the program


HOOMD
^^^^^

.. code-block:: bash

    #!/bin/bash

    #SBATCH --job-name=my_hoomd_job
    #SBATCH --partition=normal

    #SBATCH --nodes=1
    #SBATCH --ntasks-per-node=1
    #SBATCH --cpus-per-task=1
    #SBATCH --mem=8000
    #SBATCH --time=0-01:00:00
    #SBATCH --account=foo_project

    ## load modules here

    ## execute the notebook

