#BSUB -J jupyter_job
#BSUB -n 4
#BSUB -oo jupyter.o%J
#BSUB -eo jupyter.e%J

JUPYTER_PORT=38888

module load python/3
jupyter-lab  --no-browser --port=${JUPYTER_PORT} > jupyter.log 2>&1 &
ssh -R localhost:${JUPYTER_PORT}:localhost:${JUPYTER_PORT} hpc.aub.edu.lb -N
