The Matlab environment
======================

Overview
^^^^^^^^

Matlab can be used on the cluster in several configurations.

  - run jobs directly on the compute nodes of the cluster (recommended)
        + out of the box parallelizm up to 16 cores (a full node)
        + full parallelizm on the cluster (requires setup)
  - run jobs on a client and use the cluster as a backend (requires setup).
        + supports windows clients
        + supports linux and mac clients

Matlab as a client on Windows
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This configuration allows the user to use MATLAB on a local machine e.g. a
laptop or a terminal on the AUB network and run heavy computations on the HPC
cluster. After the execution on the HPC cluster is complete the results are
transparently retrieved by MATLAB and shown in the matlab workspace on the
client.

.. note:: this section of the guide has been tested with:

        - Matlab 2017b

   make sure you have the same version on the client machine.

Pre-requisites:

  - Matlab R2017b installed on your Laptop/Workstation.
  - `LSF.zip <https://mailaub-my.sharepoint.com/:u:/g/personal/sitani_aub_edu_lb/EbYcUpFEUZ5FrMQQgVNw4JUBeDjoWqBnmwLqcCzco7Aogg?e=lZeCJH>`_ folder to be installed in integration folder
  - :download:`Arza Matlab client settings <matlab/Arza.settings>`
  - A working directory (folder) on your “C” or “D” drive.
  - Have your Matlab code modified to exploit parallelism.
  - One of the Matlab versions that are available on the cluster. Preferably
    Matlab 2017b.

Setting up
++++++++++

- Once ``LSF.zip`` is downloaded, extract it to this path:

  .. code-block:: bash

     C:\Program Files\MATLAB\R2017b\toolbox\distcomp\examples\integration\

- Open Matlab R2017b on the client machine (e.g your laptop)
- Select ``Set Path``, click on ``Add Folder`` and browse to the following folder and click save:

.. code-block:: bash

    C:\Program Files\MATLAB\R2017b\toolbox\distcomp\examples\integration\lsf\nonshared

.. figure:: matlab/screenshots/matlab_Screenshot_1.png
   :scale: 100 %
   :alt:

- To import the ``Arza.settings`` profile:

    + click on ``Parallel``
    + click on ``Manage Cluster Profiles``

      .. figure:: matlab/screenshots/matlab_Screenshot_2.png
         :scale: 100 %
         :alt:

    + Choose ``Import`` then browse to ``Arza.settings`` file
      (downloaded in step 3 in the Pre-requisites section above)

      .. figure:: matlab/screenshots/matlab_Screenshot_3.png
         :scale: 100 %
         :alt:

    + Once the ``Arza`` profile gets loaded, click on ``Edit``, and modify 3 options:

      .. figure:: matlab/screenshots/matlab_Screenshot_4.png
         :scale: 100 %
         :alt:

      + ``JobStorageLocation``: Modify the path to the folder you created for
        storing data (the workdir), see the screenshot is an example below.

          .. figure:: matlab/screenshots/matlab_Screenshot_5.png
             :scale: 100 %
             :alt:

      + ``NumWokers``: Modify the number of cores to be used on HPC cluster
        (e.g. 4,6,8,10,12)

      + ``Submit Functions``: Change the username, in the below example my
        username is ``john``, change it to your HPC account username.

          .. figure:: matlab/screenshots/matlab_Screenshot_6.png
             :scale: 100 %
             :alt:

      +  Files and Folders: You may add files for submission to the HPC by selecting folder path:

          .. figure:: matlab/screenshots/matlab_Screenshot_7.png
             :scale: 100 %
             :alt:

- When finished, press done and make sure to set the HPC profile as ``Default``.

- Press ``validate`` to validate the parallel configuratin. It is expected for
 the last validation step (``parallel pool test``) to fail when using a remote
 client with a ``non-shared`` configuration.

.. note:: Multiple such parallel configuration can co-exist and can be selected
 at runtime.

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
    cluster = parcluster('Arza');

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

.. note:: For communicating jobs using shared memory or MPI the jobs should be
 submitted on the cluster directly and it is not possible to submit such jobs
 through the client in the configuration described above.

Matlab as a client on Linux or Mac OS
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. note:: guide under development

Matlab on the compute nodes of the cluster
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

This configuration allows the user to run MATLAB scripts on the HPC cluster
directly through the scheduler. Once the jobs are complete the user can
chose to transfer the results to a local machine and analyze them or analyze
everything on the cluster as well and e.g retrieve a final product that could
be a plot or a some data files. This setup does not require the user to have
matlab installed on their local machine.

Serial jobs
+++++++++++

No setup is required to run a serial job on the cluster.

The following job script (``matlab_serial.sh``) can be used to submit a serial job
running the matlab script ``my_serial_script.m``.

.. code-block:: bash

    #BSUB -J myjob
    #BSUB -n 1
    #BSUB -oo myjob.o%J
    #BSUB -eo myjob.e%J

    module load matlab/2017b

    matlab -nodisplay -r "run('my_serial_script.m')"

for example, the content of ``my_serial_script.m`` could be:


.. code-block:: matlab

    tic
    values = zeros(200);
    for i = 1:size(values, 2)
        values(i) = min(eig(rand(800)));
    end
    toc

Single node (shared memory - SMP) parallel jobs
+++++++++++++++++++++++++++++++++++++++++++++++++++++++

No setup is required to run a shared memory job on the cluster. Whenever
parallelism is required, Matlab will spawn the needed workers on the local
compute node.

The following job script (``matlab_smp.sh``) can be used to submit a serial job
running the matlab script ``my_smp_script.m``.


.. note:: the only differences with a serial job are:

   - the names of the script.
   - ``-n 1`` is replaced with ``-n 16`` in the job script.
   - specify the parallel profile in the ``.m`` script e.g ``parpool('local', 16)``
   - ``for`` is replced with ``parfor`` in the ``.m`` matlab script.

.. code-block:: bash

    #BSUB -J myjob
    #BSUB -n 16
    #BSUB -oo myjob.o%J
    #BSUB -eo myjob.e%J
    #BSUB -R "span[ptile=16]"

    module load matlab/2017b

    matlab -nodisplay -r "run('my_smp_script.m')"

for example, the content of ``my_smp_script.m`` could be:

.. code-block:: matlab

    parpool('local', 16)
    tic
    values = zeros(200);
    parfor i = 1:size(values, 2)
        values(i) = min(eig(rand(800)));
    end
    toc

.. note:: The ``#BSUB -R "span[ptile=16]"`` forces the scheduler to place all
 the 16 cores specified with the ``-n 16`` flag on the same host. This is
 cruicial since matlab's ``parpool`` can no parallelize across multiple
 nodes when the ``local`` configuration is specified.

Cluster wide parallelism
^^^^^^^^^^^^^^^^^^^^^^^^

.. note:: guide under development

Parallelize your code
^^^^^^^^^^^^^^^^^^^^^

Typically replacing ``for`` with ``parfor`` is enough for parallelizing simple
programs that involve loops.

For more details see:

  - http://www.mathworks.com/products/parallel-computing
  - https://nl.mathworks.com/videos/parallel-computing-tutorial-batch-processing-5-of-9-91567.html?s_tid=srchtitle