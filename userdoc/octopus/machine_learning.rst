Machine Learning - Deep Learning - Artificial Intelligence jobs
---------------------------------------------------------------

Currently the following machine learning libraries are installed:

  - tensorflow
  - pytorch
  - sklearn

.. note:: Inorder to use a GPU for the deep learning job, the following flag
 must be specified in the job script ``#SBATCH --gres=gpu:v100d32q:1``

Using tensorflow, keras or pytorch
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The default environment for:

      tensorflow and keras is ``python/tensorflow``
      pytorch is ``python/pytorch``

A typical batch job script look like:

.. code-block:: bash

    #!/bin/bash

    #SBATCH --job-name=keras-classify
    #SBATCH --partition normal

    #SBATCH --nodes=1
    #SBATCH --ntasks-per-node=1
    #SBATCH --cpus-per-task=1
    #SBATCH --gres=gpu:v100d32q:1
    #SBATCH --mem=12000
    #SBATCH --time=0-01:00:00

    module purge
    module load cuda
    module load python/tensorflow

    python3 keras_classification.py

