#!/bin/bash

## specify the job and project name
#SBATCH --job-name=my_job_name
#SBATCH -A foo_project

## specify the required resources
#SBATCH --partition normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=2
#SBATCH --gres=gpu:v100d32q:1
#SBATCH --mem=12000
#SBATCH --time=0-01:00:00

#
# add your command here, e.g
#
echo "hello world"