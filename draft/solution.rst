Solution
========

Here we describe Dtool, a command line tool and a Python API for lightweight
data management.

The most important aspect of Dtool is that it packages data files with
accompanying metadata into a unified whole. The packaged data and metadata is
referred to as a dataset. Having the metadata associated with the data means
that datasets can easily be moved around and that the dataset contains all
the information to verify the integrity of the data contained within it.

To illustrate the benefits of packaging data and associated metadata into a
unified whole it is worth comparing it to other solutions. A common solution is
to store metadata in file names and directory structures. For example consider
the file ``./repl_2/col0_chitin_leaf_1.tif``. In this instance the fact that
this image is of leaf sample 1 (``leaf_1``) of the wild type variant of *A.
thaliana* (``col0``) treated with chitin (``chitin``) is all encoded in the
file name. Furthermore the fact that this is replicate 2 (``repl_2``) is
encoded in the directory structure. This makes it hard to move this data around
without loosing metadata. Another common solution is to store metadata in
a database, this is for example the solution used by iRODS. This is quite a
heavyweight solution for managing metadata and it has the disadvantage that
one needs access to the database to be able to work with the data. This makes
it difficult to work off site when the database is managed centrally within
an institute.

When using Dtool to create a dataset it generates both administrative metadata
and structural metadata. The administrative metadata conteins information that
helps manage the dataset and includes for example an automatically generated
UUID.  The structural metadata describes how the dataset is put together, for
example each data item in the dataset has associated information about its
size, hash and relative path recorded in a manifest, stored as part of the
dataset.

When creating a dataset the user is prompted to add descriptive metadata about
the dataset. The user is for example prompted to describe the dataset, state
the project name and whether or not the dataset contains any confidential or
personally identifiable information.

Per item metadata can also be stored in a dataset. These are stored as so
called overlays. These can be useful when processing datasets programatically.
For example, when aligning next generation sequencing data to a reference
genome one sometimes needs to supply both forward and associated reverse read
files. To make this easier programatically one can generate a boolean overlay
that sets all the forward read files to True and a second overlay that contains
the identifier of the associated reverse read. One can then use the first
overlay to iterate over all the forward reads and the second overlay to find
the associated reverse read. Normally one would create and consume per item
metadata programatically using the Python API.

The structure of a dataset depends on the "backend" used to store it.  In other
words a dataset is structured differently on a traditional file system to how
it is structured in Amazon S3 object storage. However, the details of how the
dataset is structured is abstracted away by the Python API. This is achieved by
all read and write calls being made through a so called "storage broker".  The
storage broker is responsible for being able to interact with the storage
backend. The dataset in itself has no knowledge of how to read and write data
and metadata it only makes such queries using the storage broker interface.
This architecture makes it possible to plug-in new backends to Dtool on an
ad-hoc basis.

Below is the structure of a fictional dataset containing three items from an
RNA sequencing experiment. The ``README.yml`` file is where the descriptive
metadata used to describe the whole dataset is stored. The items of the dataset
are stored in the directory named data. The administrative and structural
metadata is stored as as JSON files in a hidden directory named ``.dtool``.

.. code-block:: none

    $ tree ~/my_dataset
    /Users/olssont/my_dataset
    ├── README.yml
    └── data
        ├── rna_seq_reads_1.fq.gz
        ├── rna_seq_reads_2.fq.gz
        └── rna_seq_reads_3.fq.gz


Datasets are created in three stages. First one creates a so called "proto
dataset".  Secondly, one adds data and metadata to the proto dataset. Finally
one converts the proto dataset into a dataset by "freezing" it. Once a dataset
is "frozen" it can no longer be altered. In other words the dataset fails to
self-verify if an item has been removed or altered or if additional items have
been added to it.

A common use with Dtool is to package raw data and copy it to a remote storage
to back it up. The first step is to create a proto dataset. The command
to create a proto dataset takes as input the name of the dataset and it returns
instructions on how to finalise the dataset creation process.

.. code-block:: none

    $ dtool create aphid-rna-seq-data
    Created proto dataset file:///Users/olssont/my_datasets/aphid-rna-seq-data
    Next steps:
    1. Add descriptive metadata, e.g:
       dtool readme interactive file:///Users/olssont/my_datasets/aphid-rna-seq-data
    2. Add raw data, eg:
       dtool add item my_file.txt file:///Users/olssont/my_datasets/aphid-rna-seq-data
       Or use your system commands, e.g:
       mv my_data_directory /Users/olssont/my_datasets/aphid-rna-seq-data/data/
    3. Convert the proto dataset into a dataset:
       dtool freeze file:///Users/olssont/my_datasets/aphid-rna-seq-data

To add descriptive metadata one could edit the ``README.yml`` file directly.
However, the Dtool client comes with built-in functionality for prompting
for generic descriptive metadata.

.. code-block:: none

    $ dtool readme interactive aphid-rna-seq-data
    description [Dataset description]: Aphid RNA sequencing data
    project [Project name]: Xenobiotic stress investigation
    confidential [False]:
    personally_identifiable_information [False]:
    name [Your Name]: Tjelvar Olsson
    email [olssont@nbi.ac.uk]:
    username [olssont]:
    creation_date [2017-11-09]:
    Updated readme
    To edit the readme using your default editor:
    dtool readme edit aphid-rna-seq-data

The Dtool client has commands for adding data items. This can be useful when
creating a dataset on remote storage such as Amazon S3. However, when working
on traditional file system it is often easier to just move the data into the
data directory.

.. code-block:: none

    $ mv ~/Downloads/aphid-rna-seq-download/* aphid-rna-seq-data/data

To convert the proto dataset into a dataset one needs to freeze it.

.. code-block:: none

    $ dtool freeze aphid-rna-seq-data
    Generating manifest  [####################################]  100%  rna_seq_reads_3.fq.gz
    Dataset frozen aphid-rna-seq-data

In the example below we have an iRODS zone named ``/jic_archive`` to which we which to copy
the dataset.

.. code-block:: none

    $ dtool copy aphid-rna-seq-data irods:///jic_archive
    Generating manifest  [####################################]  100%  rna_seq_reads_1.fq.gz
    Dataset copied to:
    irods:///jic_archive/1f79d594-e57a-4baa-a33a-dd724ad92cd6


Scenario 2: discovering, understanding and verifying data...

Scenario 3: accessing and processing data...
