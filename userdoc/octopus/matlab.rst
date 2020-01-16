The Matlab environment
======================

Overview
^^^^^^^^

Matlab can be used on the cluster in several configurations.

  - run jobs directly on the compute nodes of the cluster (recommended)
        + out of the box parallelism up to 64 cores (a full max size node)
        + full parallelism on the cluster (guide not available yet)
  - run jobs on a client and use the cluster as a backend (requires setup).
        + supports windows clients 
        + supports linux and mac clients

Matlab as a client on Windows
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This configuration allows the user to use ``MATLAB`` on a local machine e.g. a
laptop or a terminal on the AUB network and run the heavy computations sections
of a ``Matlab`` program/script on the HPC cluster. After the execution on the
HPC cluster is complete the results are transparently retrieved by ``MATLAB``
and shown in the matlab workspace on the client. For this use case, the user
does not have to login (or interact) with the HPC cluster.

.. note:: this section of the guide has been tested with Matlab 2019b
		  make sure you have the same version on the client machine.

.. note:: Multiple such parallel configuration can co-exist and can be selected
 at runtime.
 
Setting up a Matlab 2019b client
++++++++++++++++++++++++++++++++

Pre-requisites:

  - Matlab 2019b installed on the client.
  - `slurm.zip <https://mailaub.sharepoint.com/sites/vLab/Shared%20Documents/Forms/AllItems.aspx?originalPath=aHR0cHM6Ly9tYWlsYXViLnNoYXJlcG9pbnQuY29tLzpmOi9zL3ZMYWIvRXY4dm9XOEtyNXhIdW9ZeGNxVDE0SGdCWjNvb1B4d0txaVpuTk00SWdrZjN5dz9ydGltZT12WW5DcElDSTEwZw&viewid=a1808845%2D9f75%2D46cf%2D96dd%2De7999f36fca0&id=%2Fsites%2FvLab%2FShared%20Documents%2FShares%2FMatlab%20Slurm%2Fslurm>`_ folder to be installed in the integration folder
  - :download:`Octopus Matlab 2019b client settings <matlab/2019b/octopus.mlsettings>`
  - A working directory (folder) on your “C” or “D” drive.
  - Have your Matlab code modified to exploit parallelism.


- Once ``slurm.zip`` is downloaded, extract it to this path (or to the
  corresponding directory of your non-default Matlab installation directory):

  .. code-block:: bash

     C:\ProgramData\MathWorks\R2019b

 .. note:: You may need to create the necessary folders of the path.

 
   .. figure:: matlab/2019b/screenshots/matlab_screenshot_dir_structure.png
     :scale: 100 %
     :alt:

- Open Matlab R2019b on the client machine (e.g your laptop)
- Select ``Set Path``, click on ``Add Folder`` and browse to the following folder and click save:

  .. code-block:: bash

      C:\ProgramData\MATLAB\SupportPackages\R2019b\parallel\slurm\nonshared

  .. figure:: matlab/2019b/screenshots/matlab_screenshot_set_path.png
     :scale: 25 %
     :alt:

- To import the ``octopus.mlsettings`` profile:

    + click on ``Parallel``
    + click on ``Manage Cluster Profiles``

      .. figure:: matlab/2019b/screenshots/matlab_screenshot_2.png
         :scale: 100 %
         :alt:

    + Choose ``Import`` then browse to ``octopus.mlsettings`` file
      (downloaded in step 3 in the Pre-requisites section above)

      .. figure:: matlab/2019b/screenshots/matlab_screenshot_3.png
         :scale: 100 %
         :alt:

    + Once the ``octopus.mlsettings`` profile gets loaded, select it click on
      ``Edit``, and modify the ``RemoteJobStorageLocation`` and use a path on your
      HPC account. You can also choose which queue to work on through modifying ``AdditionalSubmitArgs``:

      .. figure:: matlab/2019b/screenshots/matlab_screenshot_remote_job_storage_location.png
         :scale: 100 %
         :alt:

      + ``NumWokers``: Modify the number of cores to be used on HPC cluster
        (e.g. 4,6,8,10,12)

- When finished, press done and make sure to set the HPC profile as ``Default``.

- Press ``validate`` to validate the parallel configuratin.

  .. figure:: matlab/2019b/screenshots/matlab_screenshot_validation.png
     :scale: 100 %
     :alt:

Client batch job example
++++++++++++++++++++++++

:download:`Below <matlab/test_batch_jobs.m>` is a sample Matlab program for
submitting independent jobs on the cluster. In this script four functions are
exectued on the cluster and the results are collected back one job a time back
to back in blocking mode (this can be improved on but that is beyond the scope
of this guide).

.. code-block:: matlab

    clc; clear;

    % run a function locally
    output_local = my_linalg_function(80, 300);

    % run 4 jobs on the cluster, wait for the remote jobs to finish
    % and fetch the results.
    cluster = parcluster('Octopus');

    % run the jobs (asyncroneously)
    for i=1:4
        jobs(i) = batch(cluster, @my_linalg_function, 1, {80, 600});
    end

    % wait for the jobs to finish
    for i=1:4
        status = wait(jobs(i));
        outputs(i) = fetchOutputs(jobs(i));
    end

    % define a function that does some linaer algebra
    function results = my_linalg_function(n_iters, mat_sz)
        results = zeros(n_iters, 1);
        for i = 1:n_iters
            results(i) = max(abs(eig(rand(mat_sz))));
        end
    end

.. note:: Fetching outputs will fail if more than one instance of Matlab is 
 connecting to the cluster for that user. So two Matlab on the same client 
 or two Matlab on two different clients will cause the synchronization of 
 job results with SLURM to fail.
 to correct this, you must change the JobStorageLocation in the cluster profile 
 (the local folder to which jobs are synched)
   
.. note:: For communicating jobs using shared memory or MPI the jobs should be
 submitted on the cluster directly and it is not possible to submit such jobs
 through the client in the configuration described above.

	  

Matlab on the compute nodes of the cluster
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This configuration allows the user to run MATLAB scripts on the HPC cluster
directly through the scheduler. Once the jobs are complete the user can
choose to transfer the results to a local machine and analyze them or analyze
everything on the cluster as well and e.g retrieve a final product that could
be a plot or some data files. This setup does not require the user to have
matlab installed on their local machine.

Serial jobs
+++++++++++

No setup is required to run a serial job on the cluster.

The following job script (``matlab_serial.sh``) can be used to submit a serial job
running the matlab script ``my_serial_script.m``.

.. code-block:: bash

     #!/bin/bash

     #SBATCH --job-name=matlab-smp
     #SBATCH --partition normal

     #SBATCH --nodes=1
     #SBATCH --ntasks-per-node=1
     #SBATCH --cpus-per-task=1
     #SBATCH --mem=16000
     #SBATCH --time=0-01:00:00

     module load matlab/2018b

     matlab -nodisplay -r "run('my_smp_script.m')"


.. code-block:: matlab

    tic
    values = zeros(200);
    for i = 1:size(values, 2)
        values(i) = sum(abs(eig(rand(800))));
    end
    toc

    disp(sum(sum(values)));

The following should be present in the output

.. code-block:: text

    Elapsed time is 113.542701 seconds.
    checksum = 9.492791e+05

.. note:: the ``Elapsed time`` could vary slightly since the execution time
 depends on the load of the compute node (if it is not the only running process)
 and the ``checksum`` could vary slightly since it is based on randon numbers.

Single node (shared memory - SMP) parallel jobs
+++++++++++++++++++++++++++++++++++++++++++++++

No setup is required to run a shared memory job on the cluster. Whenever
parallelism is required, Matlab will spawn the needed workers on the local
compute node.

The following job script (``matlab_smp.sh``) can be used to submit a serial job
running the matlab script ``my_smp_script.m``.


.. note:: the only differences with a serial job are:

   - the names of the script.
   - ``--nodes=1`` must be specified otherwise the resources would be allocated
     on other nodes and would not be accessible by matlab.
   - specify the parallel profile in the ``.m`` script e.g ``parpool('local', 64)``
   - ``for`` is replaced with ``parfor`` in the ``.m`` matlab script.

.. code-block:: bash

     #!/bin/bash

     #SBATCH --job-name=matlab-smp
     #SBATCH --partition normal

     #SBATCH --nodes=1
     #SBATCH --ntasks-per-node=1
     #SBATCH --cpus-per-task=64
     #SBATCH --mem=16000
     #SBATCH --time=0-01:00:00

     module load matlab/2018b

     matlab -nodisplay -r "run('my_smp_script.m')"

for example, the content of ``my_smp_script.m`` could be:

.. code-block:: matlab

    parpool('local', 64)
    tic
    values = zeros(200);
    parfor i = 1:size(values, 2)
        values(i) = min(eig(rand(800)));
    end
    toc

The following should be present in the output

.. code-block:: text

   Elapsed time is 10.660034 seconds.
   checksum = 9.492312e+05

.. note:: the ``Elapsed time`` could vary slightly since the execution time
 depends on the load of the compute node (if it is not the only running process)
 and the ``checksum`` could vary slightly since it is based on randon numbers.
