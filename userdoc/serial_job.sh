#BSUB -J myjob
#BSUB -n 1
#BSUB -q 6-hours
#BSUB -oo myjob.o%J
#BSUB -eo myjob.e%J
#BSUB -m node10
#BSUB -N
#BSUB -u foo42@aub.edu.lb
#BSUB -R "span[ptile=16]"

echo $(hostname) "hello world"

