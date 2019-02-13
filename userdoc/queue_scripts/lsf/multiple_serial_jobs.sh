#BSUB -q 6-hours                    
#BSUB -n 16                         
#BSUB -oo test1.o%J                 
#BSUB -eo test1.e%J                 
#BSUB -N                            
#BSUB -u foo11@mail.aub.edu         
#BSUB -R "span[ptile=16]"           


for i in `seq 1 16`;
do
   ./my_executable $i
done


