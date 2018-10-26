Scientific computing with Spark
-------------------------------

The currently ``spark`` configuration should be set up by users. The
instructions can be used to have a spark server running through the scheduler.
In this guide the following will be done:

  - deploy spark in your home directory
  - setup the environment file
  - launch a job through the scheduler that spawns the spark master and slaves
     + a tunnel is created to the login node that can be used to interact with
       the spark master. This tunnel allows the user to check the web UI of
       the spark master. Alternatively users can modify the job script to do
       other tasks, such as launching a jupyter notebook to interact with
       spark, or set up other tunnels.

.. warning:: Users are discouraged to login to the compute nodes directly with
  SSH.

.. note:: make sure the spark master and server are killed after the job
 execution completes to free up resources. Also it might be a good idea to
 remove the log files too.

1) Obtain a copy of spark and extract it

   .. code-block:: bash

     $ cp /gpfs1/shared/spark-2.3.2-bin-hadoop2.7.tgz ~/
     $ tar -xzvf spark-2.3.2-bin-hadoop2.7.tgz

2) Create the ``spark-env.sh`` file and customize it to your configuration. The
 following template can be used.

 .. code-block:: bash

    #!/usr/bin/env bash
    export SPARK_HOME=${HOME}/spark-2.3.2-bin-hadoop2.7
    export PATH=${SPARK_HOME}/bin:${SPARK_HOME}/sbin:${PATH}
    export LD_LIBRARY_PATH=${SPARK_HOME}/lib:${LD_LIBRARY_PATH}

    module load java/java8
    module load scala/2.12.7

    module load python/3
    export PYSPARK_DRIVER_PYTHON="jupyter"
    export PYSPARK_DRIVER_PYTHON_OPTS="notebook"
    export PYSPARK_PYTHON=`which python`

 Make the script executable using:

 .. code-block:: bash

    $ chmod +x spark-env.sh

  and copy it to the ``spark`` configuration directory

 .. code-block:: bash

    $ cp spark-env.sh ~/spark-2.3.2-bin-hadoop2.7/conf

3) Create the job script ``job.sh`` and if needed adjust some of the parameters

 .. code-block:: bash

    #BSUB -J spark
    #BSUB -n 12
    #BSUB -oo lsf_spark.o%J
    #BSUB -eo lsf_spark.e%J
    #BSUB -N
    #BSUB -u js00@aub.edu.lb
    #BSUB -R "span[ptile=1]"

    source ~/spark-2.3.2-bin-hadoop2.7/conf/spark-env.sh

    export SPARK_MASTER_PORT=7077
    export SPARK_MASTER_WEBUI_PORT=8089
    export SPARK_MASTER_HOST=${HOSTNAME}
    export SPARK_SLAVES=${LSB_DJOB_RANKFILE}

    echo "LSB job rankfile: "${LSB_DJOB_RANKFILE}
    cat ${LSB_DJOB_RANKFILE}

    echo "spark_job_userspace.sh: launch the master"
    start-master.sh --host ${SPARK_MASTER_HOST}
    echo "spark_job_userspace.sh: launch the slaves"
    start-slaves.sh

    echo "create the reverse tunnel for the master web ui"
    ssh -R localhost:${SPARK_MASTER_WEBUI_PORT}:localhost:${SPARK_MASTER_WEBUI_PORT} head2 -N -f

    sleep infinity

4) submit the job

   .. code-block:: bash

       $ bsub < job.sh

   Have a look at the files in ``~/spark-2.3.2-bin-hadoop2.7/logs`` for
   details on the master and the slaves output. This could be very useful to
   troubleshoot in case something un-exepected happens.

5) After the job execution is complete, make sure that the master and slaves
   are stopped.

