Computation Fluid Dynamics - OpenFoam
=====================================

OpenFaom is an opensource computational fluid dynamics application. More
information can be found on the official website https://www.openfoam.com

OpenFoam 6
^^^^^^^^^^

OpenFoam version 6 has been compiled natively with GCC 9.1 and can be used to
run in parallel across several hosts using MPI. The sample script below can
be used as a template to run a ``simpleFoam`` example described on the installation
website https://openfoam.org/download/6-source/

.. note:: paraview has not been compiled and is not available. For post-processing
 and visualizing the simulation outpus the data can be transfer to a local machine.

**serial job**

The following LSF job script can be use dto run the ``simpleFoam/pitzDaily``. The
run should complete within ~ 10 seconds.

.. code-block:: bash

    #BSUB -J openfoam-serial
    #BSUB -n 1
    #BSUB -q 6-hours
    #BSUB -oo ofoam.o%J
    #BSUB -eo ofoam.e%J

    module load openfoam/6.0-gcc-9.1
    source $FOAMBASHRC

    # remove the example directory to have clean test run (if it exists)
    rm -fvr $FOAM_RUN/pitzDaily

    # create the dir where the fresh example will be copied
    mkdir -p $FOAM_RUN
    cd $FOAM_RUN
    cp -r $FOAM_TUTORIALS/incompressible/simpleFoam/pitzDaily .
    cd pitzDaily

    # generate the mesh and run the simulation
    blockMesh
    simpleFoam

**sample parallel run**

In this example a parallel example for the OpenFoam tutorial suite will be run.
The job script below can be used as a template to run such parallel simulations.

.. code-block:: bash

    #BSUB -J openfoam-parallel
    #BSUB -n 16
    #BSUB -R "span[ptile=16]"
    #BSUB -q 6-hours
    #BSUB -oo ofoam.o%J
    #BSUB -eo ofoam.e%J

    module load openfoam/6.0-gcc-9.1
    source $FOAMBASHRC

    # remove the example directory to have clean test run (if it exists)
    rm -fvr $FOAM_RUN/depthCharge3D

    # create the dir where the fresh example will be copied
    mkdir -p $FOAM_RUN
    cd $FOAM_RUN
    cp -r $FOAM_TUTORIALS/multiphase/compressibleInterFoam/laminar/depthCharge3D .
    cd depthCharge3D

    # generate the mesh, partition the domains, and run the simulation
    blockMesh
    decomposePar
    mpirun refineMesh -overwrite -case /path/to/your/case/dir -parallel
    mpirun refineMesh -overwrite -case /path/to/your/case/dir -parallel
    setFields
    mpirun compressibleInterFoam -case /path/to/your/case/dir -parallel

OpenFoam 2.4
^^^^^^^^^^^^

OpenFoam version 2.4 can be used in serial or parallel mode using ``singularity``
containers. The workflow is slightly different from running OpenFoam 6. A
simulation requires two scripts:

  - the job script (without the OpenFoam specific commands)
  - the OpenFoam simulation script

The following two scripts can be used to run such a simulation.

.. code-block:: bash

    ##### job.sh #####

    #BSUB -J openfoam-2.4
    #BSUB -n 1
    #BSUB -q 6-hours
    #BSUB -oo ofoam.o%J
    #BSUB -eo ofoam.e%J

    module load singularity/2.4

    singularity exec \
       /gpfs1/apps/sw/singularity/containers/openfoam/openfoam2.4 \
       bash run.sh


.. code-block:: bash

    ##### run.sh #####

    source /opt/OpenFOAM/OpenFOAM-2.4.0/etc/bashrc

    # remove the example directory to have clean test run (if it exists)
    rm -fvr $FOAM_RUN/pitzDaily

    # create the dir where the fresh example will be copied
    mkdir -p $FOAM_RUN
    cd $FOAM_RUN
    cp -r $FOAM_TUTORIALS/incompressible/simpleFoam/pitzDaily .
    cd pitzDaily

    # generate the mesh and run the simulation
    blockMesh
    simpleFoam

make sure to convert ``run.sh`` to an executable script by using ``chown +x run.sh``
before submitting the job.
