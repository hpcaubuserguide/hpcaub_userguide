#BSUB -J my_keras_job
#BSUB -n 1
#BSUB -oo my_keras_job.o%J
#BSUB -eo my_keras_job.e%J
#BSUB -a gpushared
#BSUB -m node01

module load singularity/2.4

echo "runing on node " $HOSTNAME

singularity exec \
   /gpfs1/apps/sw/singularity/containers/deep_learning/latest \
   python conv_lstm.py
