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

+------+--------------+-----------------+--------------+--------------------+
| GPUs | host(s)      | GPU / host      | GPU ram (GB) |  GPU resource flag |
+======+==============+=================+==============+====================+
|      | onode10      | 1 x Nvidia V100 | 32           |   v100d32q:1       |
+------+--------------+-----------------+--------------+--------------------+
|   4  | onode11      | 1 x Nvidia V100 | 32           |   v100d32q:1       |
+------+--------------+-----------------+--------------+--------------------+
|      | onode12      | 1 x Nvidia V100 | 32           |   v100d32q:1       |
+------+--------------+-----------------+--------------+--------------------+
|      | onode17      | 1 x Nvidia V100 | 32           |   v100d32q:1       |
+------+--------------+-----------------+--------------+--------------------+
|   8  | anode[01-08] | 1 x Nvidia K20x | 4.5          |   k20:1            |
+------+--------------+-----------------+--------------+--------------------+

Allocating GPU resources
^^^^^^^^^^^^^^^^^^^^^^^^

In order to use a GPU for the deep learning job (or other jobs that require
GPU usage), the following flag must be specified in the job script:

   ``#SBATCH --gres=gpu``

Not all the GPUs have the same amout of memory. Using ``--gres=gpu`` will
allocate any available GPU. Advanced selections of the GPUs types can be
specifyied by passing extra flags to ``--gres``. The detailed flags for the
different GPU types are mentioned in the columns ``GPU resources flag`` in
the table above. For example, to allocate a Nvidia V100 GPU with 32GB GPU ram
use the flag:

   ``#SBATCH --gres=gpu:v100d32q:1``


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
    #SBATCH --partition=gpu

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


Distributed training and inference with torch
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Please follow the official documentation for distributed training and inference
with torch:

   - `torch run <https://docs.pytorch.org/docs/stable/elastic/run.html>`_
   - `torch.nn.DistributedDataParalle <https://docs.pytorch.org/docs/stable/generated/torch.nn.parallel.DistributedDataParallel.html>`_
   - `torch rpc parallel <https://docs.pytorch.org/docs/stable/rpc.html>`_

Job sript for octopus using GPUs
""""""""""""""""""""""""""""""""

master:

.. code-block:: bash

    torchrun --nproc-per-node=1 --nnodes=4 --node-rank=0 --master-addr=<SLURM_SUBMIT_HOST> --master-port=4444 \
       $PWD/my_torch_script.py baz --arg1=foo --arg2=bar

salve(s)

.. code-block:: bash

    torchrun --nproc-per-node=1 --nnodes=4 --node-rank=1 --master-addr=<COMPUTE_HOST> --master-port=4444 \
       $PWD/my_torch_script.py baz --arg1=foo --arg2=bar

    torchrun --nproc-per-node=1 --nnodes=4 --node-rank=2 --master-addr=<COMPUTE_HOST> --master-port=4444 \
       $PWD/my_torch_script.py baz --arg1=foo --arg2=bar

    torchrun --nproc-per-node=1 --nnodes=4 --node-rank=3 --master-addr=<COMPUTE_HOST> --master-port=4444 \
       $PWD/my_torch_script.py baz --arg1=foo --arg2=bar

Distributed training with tensorflow and keras
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Please follow the official documentation for distributed tensorflow training:

   - `tensorflow distributed <https://colab.research.google.com/github/tensorflow/docs/blob/master/site/en/tutorials/distribute/multi_worker_with_keras.ipynb>`_

Job sript for octopus using GPUs
""""""""""""""""""""""""""""""""

Multi-worker training with MirroredStrategy:

.. code-block:: bash

   #!/bin/bash

   #SBATCH --job-name=tf_dist
   #SBATCH --partition=gpu

   #SBATCH --nodes=4
   #SBATCH --ntasks-per-node=1
   #SBATCH --cpus-per-task=8
   #SBATCH --gres=gpu
   #SBATCH --mem=32000
   #SBATCH --time=0-01:00:00

   ## set the environment modules
   module purge
   module load cuda

   # on both machines
   module load python/ai-4

   # define the port number
   export TF_PORT=19090

   # srun dump the compute node hostname
   srun hostname -s > hosts.out

   # ensure that the tf config env var is unset
   unset TF_CONFIG

   srun python /home/shared/tensorflow_distributed/tensorflow_distributes_multi_worker_mirrored_strategy.py


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
specs of the GPU(s) (memory usage below is trimmed since it will depend on
whatever else is running on the node at the time)

.. code-block:: bash

    [test02@onode11 ~]$ nvidia-smi
    Tue Sep 15 14:34:44 2026
    +---------------------------------------------------------------------------------------+
    | NVIDIA-SMI 535.104.05             Driver Version: 535.104.05   CUDA Version: 12.2     |
    |-----------------------------------------+----------------------+----------------------+
    | GPU  Name                 Persistence-M | Bus-Id        Disp.A | Volatile Uncorr. ECC |
    | Fan  Temp   Perf          Pwr:Usage/Cap |         Memory-Usage | GPU-Util  Compute M. |
    |                                         |                      |               MIG M. |
    |=========================================+======================+======================|
    |   0  Tesla V100-PCIE-32GB           Off | 00000000:04:00.0 Off |                  Off |
    | N/A   46C    P0              39W / 250W |      0MiB / 32768MiB |      0%      Default |
    |                                         |                      |                  N/A |
    +-----------------------------------------+----------------------+----------------------+
    |   1  Tesla V100-PCIE-32GB           Off | 00000000:1B:00.0 Off |                  Off |
    | N/A   44C    P0              37W / 250W |      0MiB / 32768MiB |      0%      Default |
    |                                         |                      |                  N/A |
    +-----------------------------------------+----------------------+----------------------+

    +---------------------------------------------------------------------------------------+
    | Processes:                                                                            |
    |  GPU   GI   CI        PID   Type   Process name                            GPU Memory |
    |        ID   ID                                                             Usage      |
    |=======================================================================================|
    |  No running processes found                                                           |
    +---------------------------------------------------------------------------------------+

This snippet can be included in the job script

**check the deep learning framework backend**

For tensorflow, when the following snippet is executed:

.. code-block:: python

     import tensorflow as tf
     with tf.Session() as sess:
        devices = sess.list_devices()

the GPU(s) should be displayed in the output. Search for a line like
``StreamExecutor device (0): Tesla V100-PCIE-32GB, Compute Capability 7.0``; the card
name is whatever ``nvidia-smi -L`` reports on the node you landed on.

TensorFlow is chatty on start-up - it logs every CUDA library it opens and repeats a
harmless NUMA warning per device. The output below is trimmed to the lines that matter,
captured on ``onode11`` with ``python/tensorflow`` (TensorFlow 1.14.0):

.. code-block:: bash

    2026-09-15 15:13:32.895976: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1640] Found device 0 with properties:
    name: Tesla V100-PCIE-32GB major: 7 minor: 0 memoryClockRate(GHz): 1.38
    pciBusID: 0000:04:00.0
    2026-09-15 15:13:32.896326: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1640] Found device 1 with properties:
    name: Tesla V100-PCIE-32GB major: 7 minor: 0 memoryClockRate(GHz): 1.38
    pciBusID: 0000:1b:00.0
    ...
    2026-09-15 15:13:33.571370: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1763] Adding visible gpu devices: 0, 1
    ...
    2026-09-15 15:13:33.577946: I tensorflow/compiler/xla/service/service.cc:175]   StreamExecutor device (0): Tesla V100-PCIE-32GB, Compute Capability 7.0
    2026-09-15 15:13:33.577954: I tensorflow/compiler/xla/service/service.cc:175]   StreamExecutor device (1): Tesla V100-PCIE-32GB, Compute Capability 7.0

.. note:: the ``Created TensorFlow device ... with N MB memory`` lines report what was
    still free on the card at that moment, not the card's size. If that number looks
    small, another job is already using the GPU - check with ``nvidia-smi``.

.. note:: ``module load python/tensorflow`` currently provides TensorFlow 1.14, where
    ``tf.Session()`` and ``sess.list_devices()`` are the right API. Newer TensorFlow
    modules are also installed (``python/tensorflow-2.9.1``, ``python/ai-tensorflow-latest``);
    on those, ``tf.Session()`` no longer exists and the equivalent check is
    ``tf.config.list_physical_devices('GPU')``.

This snippet can be included at the top of the notebook or python script.

Similar checks can be done for ``pytorch``.
