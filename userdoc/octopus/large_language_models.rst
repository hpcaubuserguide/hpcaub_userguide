Large language models
---------------------

**Author: Mher Kazandjian**

Environments
^^^^^^^^^^^^

In addition to the ``python/ai-4`` environment the ``python/ai/transformers-r1``
environment can be used to run the models that are already available on
``octopus``.


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

The model directory is in ``/scratch/ai/llms``.

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

    cd /home/mher/scratch/llms/mistral
    rsyncf mistral-7b-v0.1.Q4_K_M /dev/shm/
    cd home/mher/scratch/llms/llama/llama.cpp/models
    ln -s /dev/shm/mistral-7b-v0.1.Q4_K_M 7B
    cd ..
    ./main -t 8 -ngl 32 -m models/7B/mistral-7b-v0.1.Q4_K_M.gguf --color -c 4096 --temp 0.7 --repeat_penalty 1.1 -n -1 -p "give me a hello world script in python."
    ./main -t 8 -ngl 24  --color --temp 0.7 -n -1 -m models/mistral-7b-v0.1.Q4_K_M.gguf -p "Building a website can be done in 10 simple steps:\nStep 1:" -n 400 -e

Evaluate the quantized model on a CPU (optimized)
#################################################

.. code-block:: bash

    cd /home/mher/scratch/llms/mistral
    rsyncf mistral-7b-v0.1.Q4_K_M /dev/shm/
    cd home/mher/scratch/llms/llama/llama.cpp/models
    ln -s /dev/shm/mistral-7b-v0.1.Q4_K_M 7B
    cd ..
    ./main -t 8 -ngl 32 -m models/7B/mistral-7b-v0.1.Q4_K_M.gguf --color -c 4096 --temp 0.7 --repeat_penalty 1.1 -n -1 -p "give me a hello world script in python."
    ./main -t 8 -ngl 24  --color --temp 0.7 -n -1 -m models/mistral-7b-v0.1.Q4_K_M.gguf -p "Building a website can be done in 10 simple steps:\nStep 1:" -n 400 -e

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

Farm the evaluation of quantized models
#######################################

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


.. Training large language models
.. ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
