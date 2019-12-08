Machine Learning - Deep Learning - Artificial Intelligence jobs
---------------------------------------------------------------

Deep learning frameworks
^^^^^^^^^^^^^^^^^^^^^^^^

Currently the following machine learning libraries are installed:

  - tensorflow
  - keras
  - pytorch
  - sklearn

Hardware optimized for deep learning
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

There are three hosts that are available for running deep learning jobs

+------------+-----------------+---------------+---------------------+
| host       | GPU             | GPU ram (GB)  |  GPU resource flag  |
+============+=================+===============+=====================+
| onode10    | 1 x Nvidia V100 | 16            |   v100d16q:1        |
+------------+-----------------+---------------+---------------------+
| onode11    | 1 x Nvidia V100 | 32            |   v100d32q:1        |
+------------+-----------------+---------------+---------------------+
| onode12    | 1 x Nvidia V100 | 32            |   v100d32q:1        |
+------------+-----------------+---------------+---------------------+

Allocating GPU resources
^^^^^^^^^^^^^^^^^^^^^^^^

In order to use a GPU for the deep learning job (or other jobs that require
GPU usage), the following flag must be specified in the job script:

   ``#SBATCH --gres=gpu``

Not all the GPUs have the same amout of memory. Using ``--gres=gpu`` will
allocate any available GPU. Advanced selections of the GPUs types can be
specifyied by passing extra flags to ``--gres``. The detailed flags for the
different GPU types are mentioned in the columns ``GPU resources flag`` in
the table above. For example, to allocate a Nvidia V100 GPU with 16GB GPU ram
use the flag:

   ``#SBATCH --gres=gpu:v100d16q:1``


Using tensorflow, Keras or pytorch
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The default environment for:

      - tensorflow, keras and sklearn: ``python/tensorflow``
      - pytorch: ``python/pytorch``

For any of these environment the ``cuda`` module must be imported.

A typical batch job script looks like:

.. code-block:: bash

    #!/bin/bash

    #SBATCH --job-name=keras-classify
    #SBATCH --partition normal

    #SBATCH --nodes=1
    #SBATCH --ntasks-per-node=1
    #SBATCH --cpus-per-task=1
    #SBATCH --gres=gpu
    #SBATCH --mem=12000
    #SBATCH --time=0-01:00:00

    ## set the environment modules
    module purge
    module load cuda
    module load python/tensorflow

    ## execute the python job
    python3 keras_classification.py

To connect to a ``jupyter`` notebook with the deep learning environment copy the
jupyter notebook server job script from the :ref:`python jupyter server guide
<jupyter_notebook_job_octopus>` and load the ``cuda`` module and shown above in
addition to the needed machine learning framework module.

Deep learning jobs tips and best practices
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

It is recommended to:

   - develop and prototype using interactive jobs such as jupyter notebooks or
     VNC sessions or batch interactive jobs and run the production models using
     bactch jobs.
   - use checkpoints in-order to have higher turnover of GPU jobs since the
     resources are scarce.

Tensorflow has built in checkpointing features for training models. Details on
possible workflows for jobs with checkpoints can be found in the
:ref:`slurm jobs guide <octopus_jobs_checkpoints_resume>`


Troubleshooting
^^^^^^^^^^^^^^^

**check the nvidia driver**

To make sure that the job that has been dispatched to a node that has a GPU,
the following command can be included in the job script before the command
that executes a notebook or a command that runs the training for example:

.. code-block:: bash

    # BUNCH OF SBATCH COMMANDS (JOB HEADER)

    ## set the environment modules
    module purge
    module load cuda
    module load python/tensorflow

    nvidia-smi

the expected output should be similar to the following where the Nvidia driver
version is mentioned in addition to the CUDA toolkit version and some other
specs of the GPU(s) and the list of GPU processes at the end (in this case none)

.. code-block:: bash

    [john@onode12 ~]$ nvidia-smi
    Sun Dec  8 00:41:27 2019
    +-----------------------------------------------------------------------------+
    | NVIDIA-SMI 430.30       Driver Version: 430.30       CUDA Version: 10.2     |
    |-------------------------------+----------------------+----------------------+
    | GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
    | Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
    |===============================+======================+======================|
    |   0  GRID V100D-32Q      On   | 00000000:02:02.0 Off |                    0 |
    | N/A   N/A    P0    N/A /  N/A |  31657MiB / 32638MiB |     13%      Default |
    +-------------------------------+----------------------+----------------------+

    +-----------------------------------------------------------------------------+
    | Processes:                                                       GPU Memory |
    |  GPU       PID   Type   Process name                             Usage      |
    |=============================================================================|
    |   No running processes found                                                |
    +-----------------------------------------------------------------------------+

This snippet can be included in the job script

**check the deep learning framework backend**

For tensorflow, when the following snippet is executed:6Q, Compute Capability 7.0``)

.. code-block:: python

     import tensorflow as tf
     with tf.Session() as sess:
        devices = sess.list_devices()

the GPU(s) should be displayed in the output (search for ``StreamExecutor device (0): GRID V100D-16Q

.. code-block:: bash

    2019-12-08 01:01:44.211101: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcuda.so.1
    2019-12-08 01:01:44.246405: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1005] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
    2019-12-08 01:01:44.247114: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1640] Found device 0 with properties:
    name: GRID V100D-16Q major: 7 minor: 0 memoryClockRate(GHz): 1.38
    pciBusID: 0000:02:02.0
    2019-12-08 01:01:44.254377: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcudart.so.10.1
    2019-12-08 01:01:44.288733: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcublas.so.10
    2019-12-08 01:01:44.310036: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcufft.so.10
    2019-12-08 01:01:44.345122: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcurand.so.10
    2019-12-08 01:01:44.378862: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcusolver.so.10
    2019-12-08 01:01:44.395244: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcusparse.so.10
    2019-12-08 01:01:44.448277: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcudnn.so.7
    2019-12-08 01:01:44.448677: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1005] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
    2019-12-08 01:01:44.449664: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1005] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
    2019-12-08 01:01:44.450245: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1763] Adding visible gpu devices: 0
    2019-12-08 01:01:44.451105: I tensorflow/core/platform/cpu_feature_guard.cc:142] Your CPU supports instructions that this TensorFlow binary was not compiled to use: SSE4.1 SSE4.2 AVX AVX2 FMA
    2019-12-08 01:01:44.461730: I tensorflow/core/platform/profile_utils/cpu_utils.cc:94] CPU Frequency: 1996250000 Hz
    2019-12-08 01:01:44.462592: I tensorflow/compiler/xla/service/service.cc:168] XLA service 0x5650b0feed20 executing computations on platform Host. Devices:
    2019-12-08 01:01:44.462644: I tensorflow/compiler/xla/service/service.cc:175]   StreamExecutor device (0): <undefined>, <undefined>
    2019-12-08 01:01:44.463168: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1005] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
    2019-12-08 01:01:44.463942: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1640] Found device 0 with properties:
    name: GRID V100D-16Q major: 7 minor: 0 memoryClockRate(GHz): 1.38
    pciBusID: 0000:02:02.0
    2019-12-08 01:01:44.464020: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcudart.so.10.1
    2019-12-08 01:01:44.464037: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcublas.so.10
    2019-12-08 01:01:44.464052: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcufft.so.10
    2019-12-08 01:01:44.464067: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcurand.so.10
    2019-12-08 01:01:44.464080: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcusolver.so.10
    2019-12-08 01:01:44.464094: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcusparse.so.10
    2019-12-08 01:01:44.464109: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcudnn.so.7
    2019-12-08 01:01:44.464181: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1005] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
    2019-12-08 01:01:44.464867: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1005] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
    2019-12-08 01:01:44.465426: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1763] Adding visible gpu devices: 0
    2019-12-08 01:01:44.465481: I tensorflow/stream_executor/platform/default/dso_loader.cc:42] Successfully opened dynamic library libcudart.so.10.1
    2019-12-08 01:01:44.729323: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1181] Device interconnect StreamExecutor with strength 1 edge matrix:
    2019-12-08 01:01:44.729383: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1187]      0
    2019-12-08 01:01:44.729399: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1200] 0:   N
    2019-12-08 01:01:44.729779: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1005] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
    2019-12-08 01:01:44.730551: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1005] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
    2019-12-08 01:01:44.731236: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:1005] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
    2019-12-08 01:01:44.731866: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1326] Created TensorFlow device (/job:localhost/replica:0/task:0/device:GPU:0 with 14226 MB memory) -> physical GPU (device: 0, name: GRID V100D-16Q, pci bus id: 0000:02:02.0, compute capability: 7.0)
    2019-12-08 01:01:44.734308: I tensorflow/compiler/xla/service/service.cc:168] XLA service 0x5650b1acf9a0 executing computations on platform CUDA. Devices:
    2019-12-08 01:01:44.734353: I tensorflow/compiler/xla/service/service.cc:175]   StreamExecutor device (0): GRID V100D-16Q, Compute Capability 7.0

This snippet can be included at the top of the notebook or python script.

Similar checks can be done for ``pytorch``.
