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
    blockMesh
    simpleFoam



