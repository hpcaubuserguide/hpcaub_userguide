#BSUB -J myjob
#BSUB -n 1
#BSUB -oo myjob.o%J
#BSUB -eo myjob.e%J

module load matlab/2017b

matlab -nodisplay -r "run('my_scirpt.m')"
