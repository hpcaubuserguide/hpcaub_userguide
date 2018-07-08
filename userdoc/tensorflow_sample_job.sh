#!/usr/bin/env bash
#BSUB -J my_gpu_job
#BSUB -n 16
#BSUB -oo output.o%J
#BSUB -eo output.e%J
#BSUB -m node01

module load singularity/2.4

# copy the training and testing data to the /tmp dir where
# tensorflow expects to find it. Currently the compute nodes
# do not have access to the internet through port 80, and since
# the script would try to download the data if it is not in the /tmp
# dir, we short circuit that step by putting the data before hand.
cp -fvr /gpfs1/data_public/tensorflow/data /tmp

singularity exec \
    /gpfs1/apps/sw/singularity/containers/deep_learning/latest \
    python convolutional_network.py
