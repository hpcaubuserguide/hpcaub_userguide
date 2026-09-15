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
   develop your .def file we recommend building a writable sandbox image first and put that
   sandbox in /dev/shm.

Before running the commands below, get an interactive session on the ``builder`` partition
(see :ref:`interactive jobs <interactive_job_octopus_anchor>` for background on interactive
jobs in general):

.. code-block:: bash

   srun --partition=builder --account=test02 --time=02:00:00 --pty /bin/bash

The ``builder`` partition has a 4-hour maximum time limit; if you don't pass ``--time`` you
get a 2-hour session by default. Set ``--time`` explicitly (up to 4 hours) if your build is
likely to take a while.

To create a sandbox image in /dev/shm do the following:

.. code-block:: bash

   mkdir -p /dev/shm/${USER}/
   ls -l /dev/shm/${USER}/

.. warning:: ``/dev/shm`` is RAM (node-local memory-backed storage, not disk) and is
    cleared when your job ends, so anything built there is lost once the allocation
    finishes - this is still the right place to build for the speed it gives you (it is
    RAM, after all), just make sure to either finish the build within a single
    interactive session or copy the result (sandbox or ``.sif``) to your home directory
    or ``/scratch`` before the session ends.

Load the apptainer module

.. code-block:: bash

   module load apptainer
   apptainer --version

To build the image as a sandbox in /dev/shm do the following:

.. code-block:: bash

    apptainer build --fakeroot --sandbox /dev/shm/${USER}/myapptainer-sandbox myapptainer.def


To build the image as a .sif file in /dev/shm do the following:

.. code-block:: bash

    apptainer build --fakeroot /dev/shm/${USER}/myapptainer.sif myapptainer.def

.. note:: you can also build the image on your computer or somewhere else and copy the .sif file
    to octopus and run it.

Running Apptainer Containers
----------------------------

Once you are happy with the image that you developed you can test running it first on a build node
or an interactive job session.

To run the apptainer image in an interactive job session do the following:

.. code-block:: bash

   module load apptainer
   apptainer shell /dev/shm/${USER}/myapptainer-sandbox                           # expected to work
   apptainer shell --fakeroot --writable /dev/shm/${USER}/myapptainer-sandbox     # expected to work
   apptainer shell /dev/shm/${USER}/myapptainer.sif                               # expected to work
   apptainer shell --fakeroot /dev/shm/${USER}/myapptainer.sif                    # not expected to work

.. todo:: the ``--fakeroot`` limitations above are a configuration gap on the build
    nodes rather than something inherent to apptainer, and they should be revisited
    once the nodes are fixed. Two things are missing (checked on ``onode27``):

    - the ``fuse3`` package is not installed, so there is no ``fusermount3`` binary
      (only ``fuse3-libs`` is present). This is what makes ``--fakeroot`` on a
      *sandbox* fail with ``failed to exec fusermount3``.
    - no user accounts have ranges in ``/etc/subuid`` and ``/etc/subgid``, so
      apptainer reports ``User not listed in /etc/subuid, trying root-mapped
      namespace`` and falls back to a weaker mode instead of real fakeroot. That
      fallback is the likely reason the ``.sif`` mount then fails with
      ``Operation not permitted``.

    Unprivileged user namespaces are already enabled and ``/dev/fuse`` is readable
    by the ``users`` group, so nothing else is in the way. Once ``fuse3`` is
    installed and subuid/subgid ranges are added, re-test all four commands: the
    ``--fakeroot`` forms are expected to start working, the last line will no longer
    be accurate, and the ``--writable`` flag on the second line may no longer be
    needed.


Running Apptainer containers via Slurm
--------------------------------------

Documentation for running Apptainer containers via Slurm is not yet available. If
you need help running Apptainer containers via Slurm, please contact the HPC
support team.

.. todo:: write this section.