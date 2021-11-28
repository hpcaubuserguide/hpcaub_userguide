#!/usr/bin/env bash

## specify the job and project name
#SBATCH --job-name=abaqus
#SBATCH --account=ab123

## specify the required resources
#SBATCH --partition=large
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=64
#SBATCH --mem=64000
#SBATCH --time=1-00:00:00

source ~/.bashrc
module load abaqus/2020

##############################################################
# DO NOT MODIFY BEYOND THIS UNLESS YOU KNOW WHAT YOU ARE DOING
##############################################################

# dump the hosts to a text file
SLURM_HOSTS_FILE=slurm-hosts-${SLURM_JOBID}.out

#
# generate the mp_host_list environment variable
#
srun hostname > ${SLURM_HOSTS_FILE}

mp_host_list="["
for HOST in `sort ${SLURM_HOSTS_FILE} | uniq`; do
    echo ${HOST}
    mp_host_list="${mp_host_list}""['${HOST}',`grep ${HOST} ${SLURM_HOSTS_FILE} | wc -l`]" 
done

mp_host_list=`echo ${mp_host_list} | sed 's/\]\[/\]\,\[/g'`"]"

echo $mp_host_list

#
# write the abaqus environment file
#
ABAQUS_ENV_FILE="abaqus_v6.env"
cat > ${ABAQUS_ENV_FILE} << EOF
import os
os.environ['ABA_BATCH_OVERRIDE'] = '1'
verbose=3
mp_host_list=${mp_host_list}
if 'SLURM_PROCID' in os.environ:
    del os.environ['SLURM_PROCID']
EOF

abaqus cae -mesa


