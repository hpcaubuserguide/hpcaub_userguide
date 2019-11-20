Pari - Computer Algebra
=======================

Introduction
^^^^^^^^^^^^

"PARI/GP is a specialized computer algebra system, primarily aimed at number
theorists, but can be used by anybody whose primary need is speed."

For more assisstance on using PARI please refer to the `official online user guide <https://pari.math.u-bordeaux.fr/pub/pari/manuals/2.11.1/users.pdf>`_


Running Pari (single threaded)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Sample job script
+++++++++++++++++

.. code-block:: bash

     #!/bin/bash

     #SBATCH --job-name=pari-serial
     #SBATCH --partition normal

     #SBATCH --nodes=1
     #SBATCH --ntasks-per-node=1
     #SBATCH --cpus-per-task=1
     #SBATCH --mem=16000
     #SBATCH --time=0-01:00:00

     module load pari

     gp < my_pari_commands.gp

where the content of ``my_pari_commands.gp`` could be

.. code-block:: text

    x = 1
    y = 2
    z = x + y
    print(z)

