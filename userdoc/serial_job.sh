#BSUB -J myjob
#BSUB -n 1
#BSUB -oo myjob.o%J
#BSUB -eo myjob.e%J
#BSUB -m node10
#BSUB -N
#BSUB -u foo42@aub.edu.lb

echo $(hostname) "hello world"

