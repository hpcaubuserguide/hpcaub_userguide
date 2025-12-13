Apptainer
^^^^^^^^^

To request access to build apptainer images on octopus please email it.helpdesk@aub.edu.lb and
mention your research computing project ID.

Building Apprainer Images
-------------------------

In-order to build apptainer images a dedicated partitions is available on Octopus named
``container-build``. This partition allows users to build apptainer images with the necessary
privileges. Note that once an apptainer image is built it can run on any of the compute nodes.

.. warning:: do not build apptainer images on the head node

Apptainer will allow you to develop environments where you as a user will be able to run commands
as root (e.g using sudo) insider the container while building it. The ``--fakeroot`` option of the
``apptainer build`` command allows you to do that.  Once the image is built you will not need to use
``--fakeroot`` to run the container. It is recommended that as you develop your workflow make sure
that at runtime, i.e when running the container, you do not need root privileges. If that is necessary
then you will not be able to run the ``.sif`` image on octopus compute nodes but you will need to
run a writable sandbox image instead (which is ok, but a bit less efficient).

Developing Apptainer Images
---------------------------

To build an appatainer image you need to create a definition file (usually with a ``.def``
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
       ln -fs /usr/share/zoneinfo/america/new_york /etc/localtime
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
   develop your .def file we recommend building a writnable sandbox image first and put that
   sandbox in /dev/shm.

To create a sandbox image in /dev/shm do the following:

.. code-block:: bash

   mkdir -p /dev/shm/${USER}/
   ls -l /dev/shm/${USER}/

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
   apptainer shell /dev/shm/${USER}/myapptainer-sandbox                # expected to work
   apptainer shell --fakeroot /dev/shm/${USER}/myapptainer-sandbox     # expected to work
   apptainer shell /dev/shm/${USER}/myapptainer.sif                    # expected to work
   apptainer shell --fakeroot /dev/shm/${USER}/myapptainer.sif         # not expected to work


Running Apptainer containers via Slurm
--------------------------------------