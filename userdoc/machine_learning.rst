Machine Learning - Deep Learning - Artificial Intelligence jobs
===============================================================

Currently the following machine learning libraries are installed:

  - tensorflow
  - keras
  - sklearn

.. note:: you can use ``node01 -> node08`` for gpu jobs.

Using tensorflow and keras
^^^^^^^^^^^^^^^^^^^^^^^^^^

In order to use a recent version of tensorflow and/or keras with GPU support the
jobs must use a singularity container. The HPC admins have prepared these
containers that can run such jobs out of the box. The containers are located at

.. code-block:: text

   /gpfs1/apps/sw/singularity/containers/deep_learning/

The following containers have been deployed


.. code-block:: text

    tensorflow-1.7.1-devel-gpu-py3-arza-release-1.0   (default)
    tensorflow-1.12-devel-gpu-py3                     (latest)
    ubuntu-16.04-pytorch-0.4.1-cuda-9.0               (default-pytorch)

A typical batch job script look like:

.. code-block:: bash

    #!/usr/bin/env bash
    #BSUB -J my_gpu_job
    #BSUB -n 16
    #BSUB -oo output.o%J
    #BSUB -eo output.e%J
    #BSUB -m node01

    module load singularity/2.4

    cd $HOME/my/job/directory

    singularity exec \
          /gpfs1/apps/sw/singularity/containers/deep_learning/latest \
          python my_program.py

.. note::

   the node(s) must be specified in the job script using the ``-m`` flag. In
   the example about ``-m node01`` instructs the scheduler to submit the job
   to ``node01``

   Moreover the ``-n 16`` flag must be used to allocate the full node exclusively
   for the job.

**SLURM job script sample**

.. code-block:: bash

  #!/bin/bash

  #SBATCH --job-name=keras-classify
  #SBATCH --partition normal

  #SBATCH --nodes=1
  #SBATCH --ntasks-per-node=8
  #SBATCH --cpus-per-task=1
  #SBATCH --gres=gpu:v100d32q:1
  #SBATCH --mem=32000
  #SBATCH --time=0-01:00:00
  #SBATCH -A my_ai_project

  module purge
  module load cuda
  module load python/ai

  which python3

  python3 keras_classification.py

Run a jupyter lab notebook server
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

A jupyter lab server is run on a compute node to which a user can connect
to using a browser on the local machine (i.e laptop/desktop/terminal)

The following job script can be used as a template to submit a job.
For more details on getting connected to a jupyter notebook can be found in the
:ref:`getting connected <Getting_started>` section of the user guide.

.. code-block:: bash

    #!/usr/bin/env bash
    #BSUB -J my_gpu_job
    #BSUB -n 16
    #BSUB -R "span[ptile=16]"
    #BSUB -m node02
    #BSUB -q 6-hours
    #BSUB -oo output.o%J
    #BSUB -eo output.e%J

    # change this to a different number to avoid clashes with other
    # users
    JUPYTER_PORT=58888

    module load singularity/2.4

    # copy the training and testing data to the /tmp dir where
    # tensorflow expects to find it. Currently the compute nodes
    # do not have access to the internet through port 80, and since
    # the script would try to download the data if it is not in the /tmp
    # dir, we short circuit that step by putting the data before hand.
    # you need to replace the line
    #    mnist = input_data.read_data_sets("/tmp/data/", one_hot=False)
    # by
    #    mnist = input_data.read_data_sets("data", one_hot=False)
    # before you run the python script
    rsync -PrlHvtpog /gpfs1/data_public/tensorflow/data .

    singularity exec \
        /gpfs1/apps/sw/singularity/containers/deep_learning/latest \
        jupyter-lab  --no-browser --port=${JUPYTER_PORT} > jupyter.log 2>&1 &

    ssh -R localhost:${JUPYTER_PORT}:localhost:${JUPYTER_PORT} hpc.aub.edu.lb -N


Run a Keras example
^^^^^^^^^^^^^^^^^^^

The following job script (and job directory) can be used as a template to
develop your own deep learning scripts. In what follows convolutional LSTM
neural network is trained using Keras.


.. literalinclude:: tensorflow_keras_sample_job.sh
   :linenos:
   :language: bash

The job script can be found here :download:`tensorflow_keras_sample_job.sh` and
the python script for training a convolutional LSTM neural network used in the
job script can be downloaded from here :download:`conv_lstm.py`.
The job folder can obtained from this archive :download:`tensorflow_keras_job.tar.gz`,
download and extract and run:

.. code-block:: bash

   $ bsub < tensorflow_keras_sample_job.sh

This example has been taken from:

    https://github.com/keras-team/keras/blob/master/examples/conv_lstm.py

more examples can be found at the following repo:

    https://github.com/keras-team/keras/tree/master/examples

Run a simple example
^^^^^^^^^^^^^^^^^^^^

The following job script (and job directory) can be used as a template to
develop your own deep learning scripts. In what follows convolutional
neural network is trained using raw tensorflow


.. literalinclude:: tensorflow_sample_job.sh
   :linenos:
   :language: bash

The job script can be found here :download:`tensorflow_sample_job.sh` and the
test python script for training a convolutional neural network used in the
job script can be downloaded from here :download:`convolutional_network.py`.
The job folder can obtained from this archive :download:`tensorflow_job.tar.gz`,
download and extract and run:

.. code-block:: bash

   $ bsub < tensorflow_sample_job.sh

This example has been taken from:

    https://github.com/aymericdamien/TensorFlow-Examples/blob/master/examples/3_NeuralNetworks/convolutional_network.py

more examples can be found at the following repo:

   https://github.com/aymericdamien/TensorFlow-Examples.git

