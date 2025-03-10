#!/bin/bash

#SBATCH --job-name=test-job
#SBATCH --account=abc123

#SBATCH --partition=gpu
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=128000
#SBATCH --gres=gpu:v100d32q:2
#SBATCH --time=0-03:00:00

#SBATCH --mail-type=ALL
#SBATCH --mail-user=abc123@mail.aub.edu

module load singularity

# list/check the available GPUs that are on the node
singularity exec --nv /apps/sw/apptainer/images/unsloth-2025-03.sif nvidia-smi

WORKDIR=~/scratch/llama_70B_unsloth_test1
#WORKDIR=/dev/shm/llama_70B_unsloth_test1

# create a directory and place all the needed files in there
mkdir -p ${WORKDIR}
cd ${WORKDIR}

TRAIN_SCRIPT_NAME=fine_tune_llama_70B_unsloth_job-2025-03.py
cp /home/shared/fine_tune_llama_70B_unsloth/${TRAIN_SCRIPT_NAME} .

singularity exec --nv \
  /apps/sw/apptainer/images/unsloth-2025-03.sif \
  --bind /scratch:/scratch \
  /bin/bash -c \
   ". /apps/miniconda/etc/profile.d/conda.sh && \
    conda activate unsloth && \
    python3 ${TRAIN_SCRIPT_NAME} 2>&1 | tee output.log"
