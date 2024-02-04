Large language models
---------------------

**Author: Mher Kazandjian**

.. info:: This document is a work in progress and is subject to change.

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

  - mistral 7B V0.1
  - mistral 7B Instruct 7B
  - llama2 7B
  - llama2 13B
  - falcon 1B
  - falcon 7B
  - falcon 17B

The model directory is in ``/scratch/shared/ai/models/llms``.

It is a good practice to cache the model (if it fits) to ``/dev/shm/`` to speed
up loading the models for repeated use. The read and write speed to ``/dev/shm``
is around 4 GB/s. Loading the hugging face mistral 7B model can be done in about
5 seconds.

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

.. todo:: add notes here

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

Fine tuning llama2 7B
^^^^^^^^^^^^^^^^^^^^^

source ~/progs/sw/miniconda/etc/profile.d/conda.sh
conda activate llama-orig-bench-1
cd /home/mher/projects/llms/
git clone https://github.com/facebookresearch/llama-recipes.git
cd llama-recipes
pip install -r requirements.txt
pip install .
mkdir models

# training
    mkdir -p /dev/shm/PEFT/model
    # one GPU
        read this section well
            https://github.com/facebookresearch/llama-recipes#single-gpu


        7B
          python -m llama_recipes.finetuning  --use_peft --peft_method lora --quantization --model_name models/7B --output_dir /dev/shm/PEFT/model
          ~35 sec / it
          388 iteraction x 3 epochs to finish


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

There are a bunch of models that are available on ``octopus``. The models are

```
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
```

Email ``it.helpdesk@aub.edu.lb`` for models that you would like to be deployed.


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
