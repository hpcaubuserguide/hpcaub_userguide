#!/bin/bash

#SBATCH --job-name=test-job
#SBATCH --account=abc123

#SBATCH --partition=large   # normal, arza, medium ...
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=4
#SBATCH --cpus-per-task=16
#SBATCH --mem=256000
#SBATCH --time=0-03:00:00

#SBATCH --mail-type=ALL
#SBATCH --mail-user=abc123@mail.aub.edu

echo "Hello World!"
