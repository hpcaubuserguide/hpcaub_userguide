Apptainer
^^^^^^^^^

To request access to build apptainer images on octopus please email it.helpdesk@aub.edu.lb and
mention your research computing project ID.

Building Apptainer Images
-------------------------

In-order to build apptainer images a dedicated partition is available on Octopus named
``builder`` (nodes ``onode07`` and ``onode27``, 4-hour time limit). This partition allows
users to build apptainer images with the necessary privileges. Note that once an apptainer
image is built it can run on any of the compute nodes.

.. warning:: do not build apptainer images on the head node

Apptainer will allow you to develop environments where you as a user will be able to run commands
as root (e.g using sudo) inside the container while building it. The ``--fakeroot`` option of the
``apptainer build`` command allows you to do that.  Once the image is built you will not need to use
``--fakeroot`` to run the container. It is recommended that as you develop your workflow make sure
that at runtime, i.e when running the container, you do not need root privileges. If that is necessary
then you will not be able to run the ``.sif`` image on octopus compute nodes but you will need to
run a writable sandbox image instead (which is ok, but a bit less efficient).

Developing Apptainer Images
---------------------------

To build an apptainer image you need to create a definition file (usually with a ``.def``
extension)

.. todo:: add some references to good youtube videos or other tutorials for building apptainer images

Below is a sample minimal definition file that users can use to build a basic apptainer images
and customize it as needed.

.. code-block:: bash

    bootstrap: docker
    from: ubuntu:24.04

    %post
       apt-get update

       export DEBIAN_FRONTEND=noninteractive
       ln -fs /usr/share/zoneinfo/Asia/Beirut /etc/localtime
       apt-get install -y tzdata
       dpkg-reconfigure --frontend noninteractive tzdata
       apt-get install -y locales
       locale-gen en_US.UTF-8

       apt-get clean

    %runscript
       echo "i will execute when singularity run is executed"


Make a copy of this script and put it in your (e.g) home directory and call it myapptainer.def

.. code-block:: bash

    ls -l ~/myapptainer.def

.. note::

   if you are confident about your .def file, you can build a .sif image directly. If you want to
   develop your .def file we recommend building a writable sandbox image first.

The ``builder`` partition has a 4-hour maximum time limit; if you don't pass ``--time`` you get a
2-hour job/session by default, so set ``--time`` explicitly (up to 4 hours) if a build is likely
to take a while.

**Iterating on your .def file (interactive):**

While you're still developing the ``.def`` file, build a **sandbox** (a plain directory, not a
single file) in ``/dev/shm`` and shell into it to check the result, repeating as you edit the
file. Since both the rebuild and the shell session need to land on the *same* node, and you're
going round the edit/rebuild/check loop repeatedly, do this in one interactive session rather
than separate batch jobs:

.. code-block:: bash

   srun --partition=builder --time=02:00:00 --pty /bin/bash
   module load apptainer

   mkdir -p /dev/shm/${USER}/
   apptainer build --fakeroot --sandbox /dev/shm/${USER}/myapptainer-sandbox ~/myapptainer.def
   apptainer shell /dev/shm/${USER}/myapptainer-sandbox

``/dev/shm`` is node-local RAM-backed storage, so builds land there much faster (~4 GB/s) than on
shared storage - and since you're going to rebuild it again after the next edit anyway, it not
surviving past the end of the session doesn't cost you anything. Once you're done, remove it:

.. code-block:: bash

   rm -rvf /dev/shm/${USER}/myapptainer-sandbox

**Building the final image (batch):**

Once the ``.def`` file is finalized and you no longer need to interactively poke at the result,
build the ``.sif`` as a batch job instead - nothing about running ``apptainer build`` itself needs
a terminal. Build it straight to somewhere **persistent**, your home directory or ``/scratch``,
since that's the artifact you actually want to keep and reuse - not ``/dev/shm``, which disappears
the moment the job ends.

.. code-block:: bash

    #!/bin/bash
    #SBATCH --job-name=apptainer-build
    #SBATCH --partition=builder
    #SBATCH --time=02:00:00

    module load apptainer
    apptainer build --fakeroot ~/myapptainer.sif ~/myapptainer.def

Submit it with:

.. code-block:: bash

    sbatch build_image.sh

.. note:: you can also build the image on your computer or somewhere else and copy the .sif file
    to octopus and run it.

Running Apptainer Containers
----------------------------

Once you have a ``.sif`` file, use it in an interactive job to check it runs as expected before
using it in production - the image itself can run on any compute node, not just ``builder``.
This needs ``--pty`` too - ``apptainer shell`` gives you an interactive shell prompt inside the
container, so it genuinely needs a terminal, unlike the batch build above:

.. code-block:: bash

   srun --partition=interactive --time=00:30:00 --pty /bin/bash
   module load apptainer
   apptainer shell ~/myapptainer.sif                    # expected to work
   apptainer shell --fakeroot ~/myapptainer.sif         # not expected to work


Running Apptainer containers via Slurm
--------------------------------------

Documentation for running Apptainer containers via Slurm is not yet available. If
you need help running Apptainer containers via Slurm, please contact the HPC
support team.