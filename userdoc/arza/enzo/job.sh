#BSUB -J enzo-hydro-collapse
#BSUB -q medium_priority
#BSUB -n 32
#BSUB -oo enzo-hydro-collapse.o%J
#BSUB -eo enzo-hydro-collapse.e%J
#BSUB -R "span[ptile=8]"

module purge
module load enzo/2.5

mpirun enzo CollapseTestNonCosmological.enzo

