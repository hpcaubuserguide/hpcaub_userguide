#!/bin/bash

## specify the job and project name
#SBATCH --job-name=enzo
#SBATCH --account=9639717

## specify the required resources
#SBATCH --partition=normal
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=8
#SBATCH --cpus-per-task=1
#SBATCH --mem=32000
#SBATCH --time=0-01:00:00

module purge
module load enzo
srun --mpi=pmix enzo.exe SphericalInfall.enzo
