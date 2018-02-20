Machine Learning - Deep Learning - Artificial Intelligence jobs
===============================================================

Currently the following machine learning libraries are installed:

  - tensorflow
  - keras

.. note:: you can use node01 -> node08 for gpu jobs.

Using tensorflow and keras
^^^^^^^^^^^^^^^^^^^^^^^^^^

In order to use tensorflow and/or keras, the tensorflow module should be loaded
in the job script  ``module load tensorflow/1.1-py3``. This will load the needed
python environment, cuda and tensorflow and all their sub-dependencies.

Below is a sample script for running tensorflow on one gpu:

.. literalinclude:: tensorflow_sample_job.sh
   :linenos:
   :language: bash

The job script can be found :download:`tensorflow_sample_job.sh` and the
test python script for training a convolutional neural network used in the
job script can be downloaded from here :download:`convolutional_network.py`.
The job folder can obtained from this archive :download:`tensorflow_job.tgz`,
download and extract and run:

.. code-block:: bash

   $ bsub < tensorflow_sample_job.sh

More examples can be found at the following repo:

   https://github.com/aymericdamien/TensorFlow-Examples.git

.. note:: you can change the node on which the job will run by changing the
 argument of the `-m` flag in the job script (i.e line 6 in the sample script
 above)