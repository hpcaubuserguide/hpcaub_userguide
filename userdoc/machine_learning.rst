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
    tensorflow-1.12-devel-gpu-py3

A typical job script look like:

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

