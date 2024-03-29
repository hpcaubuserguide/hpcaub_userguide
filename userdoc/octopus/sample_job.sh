#!/bin/bash

## specify the job and project name
#SBATCH --job-name=my_job_name
#SBATCH --account=abc123

## specify the required resources
#SBATCH --partition=normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=1
#SBATCH --gres=gpu:v100d32q:1
#SBATCH --mem=12000
#SBATCH --time=0-01:00:00
#SBATCH --mail-type=ALL
#SBATCH --mail-user=abc123@mail.aub.edu

#
# add your command here, e.g
#
echo "hello world"