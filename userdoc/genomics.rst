The Genomics environment
========================

Overview
^^^^^^^^

The genomics environment is composed of several libraries:

  - FASTQC: https://www.bioinformatics.babraham.ac.uk/projects/fastqc/
  - HISAT2: https://ccb.jhu.edu/software/hisat2/index.shtml
  - Samtools and HTSlib: http://www.htslib.org/
  - RSeQC: http://rseqc.sourceforge.net/
  - R: https://www.r-project.org/
  - python2 (with core scientific packages such as numpy, scipy..)

The genomics environment can be loaded via:

.. code-block:: bash

  $ module load genomics/py2

.. figure:: genomics_environment_screenshot.png
   :scale: 50 %
   :alt: genomics environment packages

   genomics environment packages

Submitting jobs
^^^^^^^^^^^^^^^

Genomics jobs can be submitted in the same manner as submitting serial smp or
parallel jobs.