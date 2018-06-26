FAQ
---

Obtaining an account
====================

To get an account, an email should be sent to ``it.helpdesk@aub.edu.lb`` with a
short description about the project and needed software.

   - students should have the approval of their supervisors.
   - researchers and faculty are entitled to have an account without further action.
   - external users should be sponsored by a faculty member. The form for a
     sponsored account can be found `here <http://website.aub.edu.lb/it/policies/Documents/Sponsored-AUBnet-Account-old.pdf>`_

How do I change my password
===========================

After the account is created, a random password is set by the admins. This password
should be changed as soon as possible (i.e after the first login). The passwrod
can be changed using the command:

.. code-block:: bash

      passwd

enter the new password, and confirm it.

I dont want to keep typing my pasword, can I login witout a password?
=====================================================================

Yes, use a ssh key for authentication.

To ssh to the head node without typing in a password

  - A: your machine - the client
  - B: the cluster (where you want to ssh to without a password using the ssh public key)

.. code-block:: bash

   # first generate an ssh key private/public key pair on A
   ~A> ssh-keygen -t rsa -b 4096

   # copy the generated public key to the cluster (type in your password)
   ~A> ssh $HOME/.ssh/id_rsa.pub B:~/

   # append the public key to authorized_keys on B
   ~B> cat ~/id_rsa.pub >> ~/.ssh/authorized_keys

   # change persmission of .ssh folder to 700
   ~B> chmod 700 ~/.ssh
   ~B> chmod 600 ~/.ssh/authorized_keys

To test the configuration, ssh'ing to ``B`` should log you in to a terminal
without prompting for a passwrod.

How do I log in to the HPC cluster?
===================================

http://hpc-aub-users-guide.readthedocs.io/en/latest/getting_connected.html#getting-connected

How do I run jobs on the cluster?
=================================

http://hpc-aub-users-guide.readthedocs.io/en/latest/lsf_cheatsheet.html#submitting-a-job
http://hpc-aub-users-guide.readthedocs.io/en/latest/smp_parallel_jobs.html
http://hpc-aub-users-guide.readthedocs.io/en/latest/mpi_parallel_jobs.html

See also other the rest of the user guide for GPU jobs..etc.

How do I report a problem with a job submission?
================================================

For any problems, issues and requests, please send an email to ``it.helpdesk@aub.edu.lb`

How can I find out what software is available on the HPC cluster?
=================================================================

The list of software on the cluster is available at:

     http://website.aub.edu.lb/it/hpc/applications/Pages/default.aspx

The full list can be found by logging in to the cluster and executing the command:

.. code-block:: bash

     module avail

When will my job start and why is it waiting?
=============================================

The scheduler uses sophisticated algorithms to determine which job should run
when and one which compute node(s), depending on factors such as what quality of
service the job has requested, how long the job has been waiting, whether the
project to which the user belongs is achieving its "fair share" of resources,
and whether the job can "backfill" resources reserved by a larger job already
scheduled to start.

If there are available slots on the cluster and there are enough resources
for your job, then your job should be dispatched for execution immediately.

If the cluster is busy / very busy, the job will be in the pending status.
In such scenarios, a waiting time of one day is normal.

Unless specified, jobs are submitted to the default queue ``32-hours``. If this
queue is full, you can specifiy other queues for your jobs

Use the commands:

   - "bhosts"        to see available nodes and slots
   - "bjobs -u all"  for the list of running jobs
   - "bqueues"       for details of each queue

Can I log in from home or elsewhere?
====================================

Currently the HPC access is restricted from on campus however if you have a VPN
access to AUB you can login to the HPC head nodes via ssh.

see also http://hpc-aub-users-guide.readthedocs.io/en/latest/getting_connected.html#connecting-to-a-terminal

Can I run jobs on the login nodes?
==================================

When running a program on the cluster, make sure that you are running the program
through ``bsub`` and not standalone (e.g. ./programname). ``bsub`` is the only
guarantee that your program will run on a node without annoying other users and
admins. This is important as you do not want to run your program on the management
or the head node(s). Logging in to the compute nodes with ssh is not allowed.
The admins monitor such activities and login attempts are logged and traced.

How can I montior my submitted jobs?
====================================

The command ``bjobs`` lists your jobs in the scheduler. To see the list of all
running jobs, use the command ``bjobs -u all``.


Can I run windows applications on the HPC cluster?
==================================================

Short answer is no.

Long answer: It depends on you application. If it works under ``wine``, yes.
We have limited support for this and it is handeled on a per user basis.

Is my data backed up?
=====================

Currently all the data is stored in the shared paritions ``/gpfs1``. This is not
backed up. ``/gpfs1`` can be thought of a large scrach drive and should not be
treated as a long term storage solution.


