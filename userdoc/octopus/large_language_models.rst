Large language models
---------------------

**Author: Mher Kazandjian**

.. warning:: This document is a work in progress and is subject to change.

Environments
^^^^^^^^^^^^

The following environments are available on ``octopus`` for running large
language models and developing new models:

  - python/ai-4
  - python/ai/transformers-r1

Resources requirements estimation tips and tricks
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. warning:: The following tips and tricks are not guaranteed to work for all
    models. They are just a starting point for estimating the resources
    required to run a model.

.. warning:: Do not expect for code or notebooks copied and pasted from
    huggingface, kaggle, github, stack overflow or elsewhere to work on
    ``octopus`` out of the box since the HPC contraints and optimizations
    should be taken into account and you should know what you are doing and
    understand the code being executed.
    This is a common amature mistake users frequently do and that results in
    degraded performance or wrong results.

.. warning:: Make sure that your scripts make use of accelerators whenever the
     GPU resources are specified in the job scripts. The V100 GPUs are
     enterprise grade high end GPUs. If the performace you are getting is
     slower than what you expect, most probably there is a bottelneck in your
     script. The bottelneck could be in:

      - make sure that the compute node you are running on has a GPU by executing
        ``nvidia-smi``. If you are not getting any output, then the compute node
        does not have a GPU.
      - data loading, data augmentation, model architecture, or the optimizer.
      - Make sure that you are using the GPU packages of e.g PyTorch,
        TensorFlow, etc. and not the CPU packages.
      - if you installed additional packages using pip or conda or set up
        your environment from scratch ensure that your changes do not override
        the pre-installed packages.
      - make sure to profile your script to identify the bottelneck. You can
        use basic profilers or use ``gpu_usage_live`` or ``nvtop`` to monitor
        the GPU usage.
      - Other advanced profilers are available on ``octopus``. You can use
        ``nsys`` or ``nvprof`` to profile your script. You can also use
        ``nvvp`` to visualize the profiling results.
      - Understand the resources requirements of your model for training or
        inference and compare that to the capabilities of the GPU. If the
        performace is much slower than expected then most probably there is a
        bottelneck in your script.
      - To optimize reads and writes you can use caching to the ram disk in
        ``/dev/shm`` on ``onode10`` and ``onode11``. These have 128GB of ram
        and can be used to cache the data.
      - if all the above attempts fail then please contact HPC support for
        further assistance.

Available models
^^^^^^^^^^^^^^^^

The following models are available on ``octopus``:

- llama-2-13b
- llama-2-13b-chat
- llama-2-13b-hf
- llama-2-7b
- llama-2-7b-chat
- llama-2-7b-hf
- falcon 1B
- falcon 7B
- falcon:180b-chat
- jais-13b-chat
- codellama:34b
- codellama:70b
- deepseek-coder:33b
- dolphin-mixtral:8x7b
- llava
- medllama2
- megadolphin
- mixtral:8x7b-instruct-v0.1-q8_0
- mixtral:latest
- phi
- stablelm-zephyr
- starcoder:7b
- starcoder:15b
- tinyllama
- wizardlm-uncensored:13b
- wizardlm:70b-llama2-q4_0
- yarn-mistral:7b-128k
- zephyr

The model directory is in ``/scratch/shared/ai/models/llms``.
and alot of ``ollama`` models (see :ref:`here <ollama>`)

It is a good practice to cache the model (if it fits) to ``/dev/shm/`` to speed
up loading the models for repeated use. The read and write speed to ``/dev/shm``
is around 4 GB/s. Loading the hugging face mistral 7B model can be done in about
5 seconds.


.. note:: In order to access the LLaMA models please email it.helpdesk@aub.edu.lb
   and provide a copy of your signed agreement https://llama.meta.com/llama-downloads/
   or place your own copy that you have obtained e.g from hugging face or if
   you have already obtained the model on ``octopus``.


Running inference and evaluating models
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Hugging face models using the transformers package
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

In the following example the mistral 7B model will be evaluated using the
transformers-r1 pre-deployed environment. The job script and the python script
that runs the model are available on ``octopus`` at:

.. code-block:: bash

    /apps/shared/...../path/to/example1

The expected evaluation time the example below is ?? seconds. This example
produces ?? tokens at an average rate of ?? tokens / min.
During this test a total of ?? GB is transfered from the disk to the GPU
and a total of ?? (float??) operations are done.
The total memory transfer from VRAM to the GPU is ?? GB at an average rate of
?? GB/s and a peak of ?? GB/s.

The job script is the following:

.. code-block:: bash

    ############################ eval_mistral.sh ###############################
    #!/bin/bash

    #SBATCH --job-name=eval-mistral
    #SBATCH --account=abc123

    #SBATCH --partition=gpu
    #SBATCH --nodes=1
    #SBATCH --ntasks-per-node=1
    #SBATCH --cpus-per-task=8
    #SBATCH --mem=32000
    #SBATCH --gres=gpu:v100d32q:1
    #SBATCH --time=0-00:10:00

    #SBATCH --mail-type=ALL
    #SBATCH --mail-user=abc123@mail.aub.edu

    # prepare the scripts and cache the model
    cp /scratch/llms/.../mistral7b... /dev/shm
    cp /apps/shared/ai/.../eval_mistral_userguide.py /dev/shm/

    # load the transformers environment and evaluate the model
    module load python/ai/transformers-r1
    cd /dev/shm
    python eval_mistral_userguide.py
    ########################## end eval_mistral.sh #############################

.. code-block:: python

    from transformers import AutoModelForCausalLM, AutoTokenizer
    device = "cuda" # the device to load the model onto

    model_name = "mistralai/Mistral-7B-v0.1"

    cache_dir = '/dev/shm/huggingface_cache'

    model = AutoModelForCausalLM.from_pretrained(
        model_name,
        cache_dir=cache_dir)
    tokenizer = AutoTokenizer.from_pretrained(
        model_name,
        trust_remote_code=True,
        cache_dir=cache_dir)

    # evaluate the model for 10 prompts
    prompts = [
        "My favourite condiment is",
        "My favourite condiment is",
        "My favourite condiment is",
        "My favourite condiment is",
        "My favourite condiment is",
        "My favourite condiment is",
        "My favourite condiment is",
        "My favourite condiment is",
        "My favourite condiment is",
        "My favourite condiment is"
    ]
    for prompt in tqdm.tqdm(prompts):
        model_inputs = tokenizer([prompt], return_tensors="pt").to(device)
        model.to(device)
        generated_ids = model.generate(**model_inputs, max_new_tokens=100, do_sample=True)
        tokenizer.batch_decode(generated_ids)[0]

Evaluating quantized models
^^^^^^^^^^^^^^^^^^^^^^^^^^^

Once a model is fine tuned or trained (see below) it is convient (assuming that
the loss in accuracy is not high to quantize the model to evaluate the quantized
model for testing purposes. For use cases that do not requite high accuracy
quantized models are good enough and they outperform the llama7B model (.. todo::
double check this statement).

Using llama.cpp
+++++++++++++++

In this section I will explain the basics of quantization and how to evaluate
such models without any optimization on a CPU. Later in this section I will
describe and demonstrate how to scale the model evaluation using a single GPU
and multiple GPUs across several hosts or across multiple mosts using only CPUs
and compare the performance.

Quantizing models
#################

.. todo:: add notes here

Evaluate the quantized model on a CPU - non optimized
######################################################


.. code-block:: bash

    module load gcc/12
    rsync -PrlHvtpog /scratch/shared/ai/models/llms/mistralai/Mistral-7B-v0.1/mistral-7b-v0.1.Q4_K_M /dev/shm/
    /apps/sw/llama.cpp/amd-avx2/bin/main -t 16 -ngl 24 --color --temp 0.7 -n 1 -m /dev/shm/mistral-7b-v0.1.Q4_K_M/mistral-7b-v0.1.Q4_K_M.gguf -p "Building a website can be done in 10 simple steps:\nStep 1:" -n 400 -e

Evaluate the quantized model on a CPU (optimized)
#################################################

.. code-block:: bash

    module load gcc/12
    module load cuda/12
    rsync -PrlHvtpog /scratch/shared/ai/models/llms/mistralai/Mistral-7B-v0.1/mistral-7b-v0.1.Q4_K_M /dev/shm/
    /apps/sw/llama.cpp/amd-v100-cublas-12/bin/main -t 8 -ngl 24 --color --temp 0.7 -n 1 -m /dev/shm/mistral-7b-v0.1.Q4_K_M/mistral-7b-v0.1.Q4_K_M.gguf -p "Building a website can be done in 10 simple steps:\nStep 1:" -n 400 -e

Evaluate the quantized model on a CPU across multiple hosts
###########################################################

.. code-block:: bash

    module load llama.cpp/mpi

Evaluate the quantized model on a GPU
#####################################

.. code-block:: bash

    module load llama.cpp/gpu-v100
    ...

    module load llama.cpp/gpu-k20
    ...

Evaluate the quantized model across multiple GPUs
#################################################


.. code-block:: bash

    module load llama.cpp/gpu-v100-mpi
    ...

    module load llama.cpp/gpu-k20-mpi
    ...

Benchmark the quantized model
#############################

.. code-block:: bash

    [test01@onode12 work]$ /apps/sw/llama.cpp/amd-v100-cublas-12/bin/llama-bench -m /dev/shm/mistral-7b-v0.1.Q4_K_M/mistral-7b-v0.1.Q4_K_M.gguf
    ggml_init_cublas: GGML_CUDA_FORCE_MMQ:   no
    ggml_init_cublas: CUDA_USE_TENSOR_CORES: yes
    ggml_init_cublas: found 1 CUDA devices:
      Device 0: Tesla V100-PCIE-32GB, compute capability 7.0, VMM: yes
    | model                          |       size |     params | backend    | ngl | test       |              t/s |
    | ------------------------------ | ---------: | ---------: | ---------- | --: | ---------- | ---------------: |
    | llama 7B Q4_K - Medium         |   4.07 GiB |     7.24 B | CUDA       |  99 | pp 512     |  2233.80 ± 65.69 |
    | llama 7B Q4_K - Medium         |   4.07 GiB |     7.24 B | CUDA       |  99 | tg 128     |     82.05 ± 0.15 |

Farm the evaluation of quantized models
#######################################

.. todo:: under development

# .. todo:: cache the model to some ram disks and then rsync it to other ram
    disks. decide depending on the read time from /scratch what is the best
    strategy that leads to having the model on all the machines the fastest.
    i.e figure out what is the best strategy to broadcast the model.

.. code-block:: bash

    # define your prompts in a .txt file with one prompt per line
    python farm_llama_cpp.py \
      --partitions=all \
      --prompts-file=/path/to/my_prompts.txt \
      --stats

Fine tuning large language models
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Fine tuning llama2 7B using the official facebook llama repo
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

**TL;DR** Procedure to fune-tune llama2 7B on one V100 GPU on ``octopus``.

The following pre-requisites are required to fine tune the llama2 7B model:

- The facebook llama-recipes repo (already installed on ``octopus``)
- The LLaMA 7B HF model (email it.helpdesk@aub.edu.lb to request access by
  presenting a copy of your signed agreement https://llama.meta.com/llama-downloads/
  or place your own copy in the right location - see below).
- A python environment with the right requirements (already installed on
  ``octopus``)
- The job script with the ``octopus`` specific hardware / software configuration
  that runs the fine tuning.

To run the fine tuning as described in the llama-recipes repo, the following
steps are done:

1. Load the llama-recipes environment
2. Clone and install the llama-recipes repo
3. Cache the model to ``/dev/shm`` to speed up the loading of the model
4. Run the fine tuning script

.. code-block:: bash

    module load llama
    cp -fvr /apps/sw/llama-recipes . && cd llama-recipes
    git checkout 2e768b1
    pip install .
    rsync -PrlHvtpog  /scratch/shared/ai/models/llms/llama/llama-2-7b-hf /dev/shm/
    mkdir models
    ln -s /dev/shm/llama-2-7b-hf models/7B
    time python -m llama_recipes.finetuning  \
      --use_peft --peft_method lora --quantization \
      --model_name models/7B --output_dir /dev/shm/PEFT/model/

The following output is expected:

.. code-block:: bash

    [test04@onode11 llama-recipes]$ time python -m llama_recipes.finetuning --use_peft --peft_method lora --quantization       --model_name models/7B --output_dir /dev/shm/PEFT/model/
    Loading checkpoint shards: 100%|███████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 2/2 [00:09<00:00,  4.51s/it]
    You are using the default legacy behaviour of the <class 'transformers.models.llama.tokenization_llama.LlamaTokenizer'>. This is expected, and simply means that the `legacy` (previous) behavior will be used so nothing changes for you. If you want to use the new behaviour, set `legacy=False`. This should only be set if you understand what it means, and thoroug
    hly read the reason why this was added as explained in https://github.com/huggingface/transformers/pull/24565
    --> Model models/7B
    --> models/7B has 262.41024 Million params
    trainable params: 4,194,304 || all params: 6,742,609,920 || trainable%: 0.06220594176090199
    Map: 100%|███████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 14732/14732 [00:01<00:00, 10651.47 examples/s]
    Map: 100%|█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 14732/14732 [00:24<00:00, 598.36 examples/s]
    --> Training Set Length = 14732
    Map: 100%|████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 818/818 [00:00<00:00, 8043.54 examples/s]
    Map: 100%|█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 818/818 [00:01<00:00, 582.25 examples/s]
    --> Validation Set Length = 818
    Preprocessing dataset: 100%|█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 14732/14732 [00:07<00:00, 1920.48it/s]
    Preprocessing dataset: 100%|█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 818/818 [00:00<00:00, 1971.12it/s]
    Training Epoch: 1:   0%|                                                                                | 0/388 [00:00<?, ?it/s]/home/mher/progs/sw/miniconda/envs/llama-orig-bench-1/lib/python3.10/site-packages/bitsandbytes/autograd/_functions.py:322: UserWarning: MatMul8bitLt: inputs will be cast from torch.float32 to float16 during quantization
    Training Epoch: 1/3, step 387/388 completed (loss: 1.7123626470565796): 100%|███████████████| 388/388 [3:34:24<00:00, 33.16s/it]
    Max CUDA memory allocated was 21 GB
    Max CUDA memory reserved was 24 GB
    Peak active CUDA memory was 21 GB
    Cuda Malloc retires : 0
    CPU Total Peak Memory consumed during the train (max): 2 GB
    evaluating Epoch: 100%|█████████████████████████████████████████████████████████████████████████| 84/84 [04:29<00:00,  3.21s/it]
     eval_ppl=tensor(5.2620, device='cuda:0') eval_epoch_loss=tensor(1.6605, device='cuda:0')
    we are about to save the PEFT modules
    PEFT modules are saved in /dev/shm/PEFT/model/ directory
    best eval loss on epoch 1 is 1.660506010055542
    Epoch 1: train_perplexity=5.3824, train_epoch_loss=1.6831, epoch time 12864.613309495151s
    Training Epoch: 2/3, step 387/388 completed (loss: 1.6909533739089966): 100%|███████████████| 388/388 [3:33:44<00:00, 33.05s/it]
    Max CUDA memory allocated was 21 GB
    Max CUDA memory reserved was 24 GB
    Peak active CUDA memory was 21 GB
    Cuda Malloc retires : 0
    CPU Total Peak Memory consumed during the train (max): 2 GB
    evaluating Epoch: 100%|█████████████████████████████████████████████████████████████████████████| 84/84 [04:29<00:00,  3.20s/it]
     eval_ppl=tensor(5.2127, device='cuda:0') eval_epoch_loss=tensor(1.6511, device='cuda:0')
    we are about to save the PEFT modules
    PEFT modules are saved in /dev/shm/PEFT/model/ directory
    best eval loss on epoch 2 is 1.6511057615280151
    Epoch 2: train_perplexity=5.1402, train_epoch_loss=1.6371, epoch time 12824.521782848984s
    Training Epoch: 3/3, step 11/388 completed (loss: 1.5718340873718262):   3%|▌                | 12/388 [06:36<3:26:57, 33.03s/it]
    Training Epoch: 3/3, step 387/388 completed (loss: 1.6727845668792725): 100%|███████████████| 388/388 [3:33:37<00:00, 33.03s/it]
    Max CUDA memory allocated was 21 GB
    Max CUDA memory reserved was 24 GB
    Peak active CUDA memory was 21 GB
    Cuda Malloc retires : 0
    CPU Total Peak Memory consumed during the train (max): 2 GB
    evaluating Epoch: 100%|█████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████| 84/84 [04:28<00:00,  3.20s/it]
     eval_ppl=tensor(5.1962, device='cuda:0') eval_epoch_loss=tensor(1.6479, device='cuda:0')
    we are about to save the PEFT modules
    PEFT modules are saved in /dev/shm/PEFT/model/ directory
    best eval loss on epoch 3 is 1.647936224937439
    Epoch 3: train_perplexity=5.0411, train_epoch_loss=1.6176, epoch time 12817.443107374012s
    Key: avg_train_prep, Value: 5.1879143714904785
    Key: avg_train_loss, Value: 1.6459529399871826
    Key: avg_eval_prep, Value: 5.223653316497803
    Key: avg_eval_loss, Value: 1.6531827449798584
    Key: avg_epoch_time, Value: 12835.526066572716
    Key: avg_checkpoint_time, Value: 0.040507279336452484

    real    659m9.844s
    user    349m26.981s
    sys     351m6.738s

The following table summarizes the performance of the fine tuning of the llama2

    =========== ============ ======  =========
      Model       GPU        Epochs  Wall Time
    =========== ============ ======  =========
     llama2 7B   Nvidia V100   3     10h 50m
    =========== ============ ======  =========

The full job script (below) that reproduces the results can be found
at ``/home/shared/fine_tune_llama_7b/job.sh``. It can be copied to your
home directory and executed as follows (change test04 with your username):

.. code-block::bash

    #!/bin/bash

    #SBATCH --job-name=llama7b-finetune
    #SBATCH --account=test04

    #SBATCH --partition=msfea-ai
    #SBATCH --nodes=1
    #SBATCH --ntasks-per-node=8
    #SBATCH --cpus-per-task=1
    #SBATCH --gres=gpu:v100d32q:1
    #SBATCH --mem=32000
    #SBATCH --time=0-12:00:00
    #SBATCH --mail-type=ALL
    #SBATCH --mail-user=test04@mail.aub.edu

    module load llama
    cp -fvr /apps/sw/llama-recipes . && cd llama-recipes
    git checkout 2e768b1
    pip install .
    rsync -PrlHvtpog  /scratch/shared/ai/models/llms/llama/llama-2-7b-hf /dev/shm/
    mkdir models
    ln -s /dev/shm/llama-2-7b-hf models/7B
    time python -m llama_recipes.finetuning  \
      --use_peft --peft_method lora --quantization \
      --model_name models/7B --output_dir /dev/shm/PEFT/model/

.. todo:: Add instructions for resuming from an epoch
.. todo:: Add instructions for providing a custom fine-tuning dataset

Fine tuning llama2 13B
^^^^^^^^^^^^^^^^^^^^^^

Prior to fine tuning the 13B llama2 model, it must be shared in-order fit on
two or four V100 GPUs.
### note:: i am not sure if it was possible to fine tune 13B on two GPUs!
    try again

Sharding
++++++++

.. todo:: add a section here on how to shard llama2 13B


Fine tuning
+++++++++++

# 4 GPUs
      python -m llama_recipes.finetuning  --use_peft --peft_method lora --quantization --model_name models/13B --output_dir /dev/shm/PEFT/model
    master
        $ torchrun --nproc-per-node=1 --nnodes=4 --node-rank=0 --master-addr=onode10 --master-port=4444 examples/finetuning.py --use_peft --peft_method lora --quantization --model_name models/13B --output_dir /dev/shm/PEFT/model
    slaves
        $ torchrun --nproc-per-node=1 --nnodes=4 --node-rank=1 --master-addr=onode10 --master-port=4444 examples/finetuning.py --use_peft --peft_method lora --quantization --model_name models/13B --output_dir /dev/shm/PEFT/model
        $ torchrun --nproc-per-node=1 --nnodes=4 --node-rank=2 --master-addr=onode10 --master-port=4444 examples/finetuning.py --use_peft --peft_method lora --quantization --model_name models/13B --output_dir /dev/shm/PEFT/model
        $ torchrun --nproc-per-node=1 --nnodes=4 --node-rank=3 --master-addr=onode10 --master-port=4444 examples/finetuning.py --use_peft --peft_method lora --quantization --model_name models/13B --output_dir /dev/shm/PEFT/model

Serving models using ollama
^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. _ollama:

There are a bunch of models that are available on ``octopus``. The models are

.. code-block:: bash

    $ ollama list
    NAME                                    ID              SIZE    MODIFIED
    codellama:34b                           685be00e1532    19 GB   9 days ago
    codellama:70b                           e59b580dfce7    38 GB   2 days ago
    codellama:70b-code                      f51f75d243f2    38 GB   2 days ago
    codellama:70b-instruct                  e59b580dfce7    38 GB   2 days ago
    deepseek-coder:1.3b                     3ddd2d3fc8d2    776 MB  8 days ago
    deepseek-coder:1.3b-base-q8_0           71f702eff852    1.4 GB  7 days ago
    deepseek-coder:1.3b-instruct            3ddd2d3fc8d2    776 MB  8 days ago
    deepseek-coder:33b                      acec7c0b0fd9    18 GB   7 days ago
    deepseek-coder:33b-base-q4_0            ca50732c8ee1    18 GB   7 days ago
    deepseek-coder:33b-instruct             acec7c0b0fd9    18 GB   8 days ago
    deepseek-coder:33b-instruct-fp16        b54904179335    66 GB   7 days ago
    deepseek-coder:6.7b                     ce298d984115    3.8 GB  7 days ago
    deepseek-coder:latest                   3ddd2d3fc8d2    776 MB  8 days ago
    dolphin-mixtral:8x7b                    cfada4ba31c7    26 GB   8 days ago
    falcon:180b-chat                        e2bc879d7cee    101 GB  8 days ago
    falcon:7b                               4280f7257e73    4.2 GB  9 days ago
    llava:latest                            cd3274b81a85    4.5 GB  9 days ago
    medllama2:latest                        a53737ec0c72    3.8 GB  9 days ago
    megadolphin:latest                      8fa55398527b    67 GB   8 days ago
    mistral:instruct                        61e88e884507    4.1 GB  9 days ago
    mistral:latest                          61e88e884507    4.1 GB  7 days ago
    mixtral:8x7b-instruct-v0.1-q8_0         a6689be5de7d    49 GB   9 days ago
    mixtral:latest                          7708c059a8bb    26 GB   9 days ago
    phi:latest                              e2fd6321a5fe    1.6 GB  9 days ago
    stablelm-zephyr:latest                  0a108dbd846e    1.6 GB  8 days ago
    starcoder:15b                           fc59c84e00c5    9.0 GB  9 days ago
    starcoder:1b                            77e6c46054d9    726 MB  9 days ago
    starcoder:3b                            847e5a7aa26f    1.8 GB  9 days ago
    starcoder:7b                            53fdbc3a2006    4.3 GB  9 days ago
    tinyllama:latest                        2644915ede35    637 MB  9 days ago
    wizardlm:70b-llama2-q4_0                2d269a65a092    38 GB   8 days ago
    wizardlm-uncensored:13b                 886a369d74fc    7.4 GB  8 days ago
    yarn-mistral:7b-128k                    6511b83c33d5    4.1 GB  8 days ago
    zephyr:latest                           bbe38b81adec    4.1 GB  8 days ago

Since downloading large models it time consuming please email
``it.helpdesk@aub.edu.lb`` for additional models that you would like to be
deployed that are not in the list above.


.. note:: The environment variable ``OLLAMA_MODELS`` is set to
    ``/scratch/shared/ai/models/llms/ollama/models``. This is the default
    location where the models are stored. If you would like to use a different
    location, you can set the environment variable ``OLLAMA_MODELS`` to the
    desired location. If there is a model that needs to be loaded / offloaded
    multiple time for some reason (such as a script that needs to execute
    many times that exists and re-runs) then caching the models to be used
    to ``/dev/shm`` is a good idea. In this case set the evn variable
    ``OLLAMA_MODELS`` to ``/dev/shm/ollama/models`` and put your models in
    there by copying them from the default location.

.. todo:: add a bash function that caches a certain named model to ``/dev/shm``

Load and list the models
++++++++++++++++++++++++

.. code-block:: bash

    module load ollama
    ollama list


Run a model in interactive mode
+++++++++++++++++++++++++++++++

.. code-block:: bash

    module load ollama

    ollama serve > /dev/null 2>&1 &
    # wait a bit (~ 20 seconds) until the server is up and running
    ollama run phi:latest

Run a model in batch mode
+++++++++++++++++++++++++

Create a python script that uses the ollama client to run the model.
In the example below the ``phi`` model is used since it is small and can
be loaded quickly.

.. code-block:: python

    import ollama
    response = ollama.chat(model='phi', messages=[
      {
        'role': 'user',
        'content': 'Why is the sky blue?',
      },
    ])
    print(response['message']['content'])

.. code-block:: bash

    module load ollama
    module load python/ai-4

    ollama serve > /dev/null 2>&1 &
    sleep 20
    python ollama_eval.py

.. Training large language models
.. ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
