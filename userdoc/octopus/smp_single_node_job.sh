#!/bin/bash

#SBATCH --job-name=test-job
#SBATCH --account=abc123

#SBATCH --partition=normal
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32000
#SBATCH --time=0-03:00:00

#SBATCH --mail-type=ALL
#SBATCH --mail-user=abc123@mail.aub.edu

echo "Hello World!"
