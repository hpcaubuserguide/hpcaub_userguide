#BSUB -J jupyter_job
#BSUB -n 4
#BSUB -oo jupyter.o%J
#BSUB -eo jupyter.e%J

module load python/3
jupyter-lab  --no-browser --port=38888 > jupyter.log 2>&1 &
ssh -R localhost:38888:localhost:38888 head2 -N
