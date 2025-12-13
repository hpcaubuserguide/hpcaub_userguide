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



Running Apptainer Containers
----------------------------

Running Apptainer containers via Slurm
--------------------------------------