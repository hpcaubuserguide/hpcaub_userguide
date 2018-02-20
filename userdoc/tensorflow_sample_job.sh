#BSUB -J my_tensorflow_job
#BSUB -n 1
#BSUB -oo my_tensorflow_job.o%J
#BSUB -eo my_tensorflow_job.e%J
#BSUB -a gpushared
#BSUB -m node01

module load tensorflow/1.1-py3

# copy the training and testing data to the /tmp dir where
# tensorflow expects to find it. Currently the compute nodes
# do not have access to the internet through port 80, and since
# the script would try to download the data if it is not in the /tmp
# dir, we short circuit that step by putting the data before hand.
cp -fvr /gpfs1/data_public/tensorflow/data /tmp

python convolutional_network.py
