#BSUB -J myjob
#BSUB -n 1
#BSUB -oo myjob.o%J
#BSUB -eo myjob.e%J

export PATH=/gpfs1/apps/Matlab2017b/bin:$PATH

matlab -nodisplay -r my_matlab_script.m
