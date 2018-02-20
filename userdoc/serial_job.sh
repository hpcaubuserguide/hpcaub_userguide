#BSUB -J myjob
#BSUB -n 1
#BSUB -oo myjob.o%J
#BSUB -eo myjob.e%J

echo $(hostname) "hello world"

