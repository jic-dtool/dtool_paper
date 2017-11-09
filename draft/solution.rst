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


Another common scenario is to want to discover, understand and verify data. To list the
dataset in a particular location one can use the ``dtool ls`` command.

.. code-block:: none

    $ dtool ls ~/my_datasets
    53e006ee-ac6b-47bb-9020-7464dbd77cf4 - another-demo-for-adam - file:///Users/olssont/my_datasets/another-demo-for-adam
    1f79d594-e57a-4baa-a33a-dd724ad92cd6 - aphid-rna-seq-data    - file:///Users/olssont/my_datasets/aphid-rna-seq-data
    469ca967-4239-4eb8-880b-4741a882b2c4 - bgi-sequencing-12345  - file:///Users/olssont/my_datasets/bgi-sequencing-12345
    c2542c2b-d149-4f73-84bc-741bf9af918f - drone-images          - file:///Users/olssont/my_datasets/drone-images
    f416ded6-2f9a-4909-ab43-2447d0d1a0d4 - fishers-iris-data     - file:///Users/olssont/my_datasets/fishers-iris-data
    6847e637-a61c-4043-a9e2-bbf4ff6f6baa - my_rnaseq_data        - file:///Users/olssont/my_datasets/my_rnaseq_data
    96d82bb5-ac9a-4c00-ba0a-7a2d078a64da - swissprot             - file:///Users/olssont/my_datasets/swissprot

To list the item in the ``aphid-rna-seq-data`` one can use the same ``dtool ls`` command.

.. code-block:: none

    dtool ls ~/my_datasets/aphid-rna-seq-data
    6ee35e352bebf61537bfd6d7875d4d9de995e413 - rna_seq_reads_1.fq.gz
    5a76ffc3622534acc7bde558c3256d4811210398 - rna_seq_reads_3.fq.gz
    5de26adb6fd52023ba48c554e4d1e6d4bfed119d - rna_seq_reads_2.fq.gz

Summary information about the dataset can be retrieved using the ``dtool summary`` command.

.. code-block:: none

    $ dtool summary ~/my_datasets/aphid-rna-seq-data
    {
      "name": "aphid-rna-seq-data",
      "uuid": "1f79d594-e57a-4baa-a33a-dd724ad92cd6",
      "creator_username": "olssont",
      "number_of_items": 3,
      "size_in_bytes": 6,
      "frozen_at": 1510225974.0
    }

The descriptive metadata can be displayed using the ``dtool readme show`` command.

.. code-block:: none

    $ dtool readme show ~/my_datasets/aphid-rna-seq-data
    ---
    description: Aphid RNA sequencing data
    project: Xenobiotic stress investigation
    confidential: false
    personally_identifiable_information: false
    owners:
    - name: Tjelvar Olsson
      email: olssont@nbi.ac.uk
      username: olssont
    creation_date: 2017-11-09

To verify that the dataset has not been corrupted one can use the ``dtool verify`` command.

.. code-block:: none

    $ dtool verify ~/my_datasets/aphid-rna-seq-data
    All good :)

A third common scenario is to want to access to data in order to be able to process it.
It is possible to simply copy a whole dataset from one location to another.

.. code-block:: none

    $ dtool copy ~/my_datasets/aphid-rna-seq-data /tmp
    Generating manifest  [####################################]  100%  rna_seq_reads_3.fq.gz
    Dataset copied to:
    file:///tmp/aphid-rna-seq-data

The data will then be available in the ``data`` subdirectory.

Alternatively, one can gain access to a data item on local file system using
the ``dtool item fetch`` command which returns the absolute path to a file with
the content of the data once it is available. By combining this command with
``dtool identifiers``, which list the data item identifiers in a dataset one
can create a Bash script to process all the items in a dataset.

.. code-block:: bash

    DS_URI=~/my_datasets/aphid-rna-seq-data
    for ITEM_ID in `dtool identifiers $DS_URI`;
    do
      ITEM_FPATH=`dtool item fetch $DS_URI $ITEM_ID`;
      echo $ITEM_FPATH;
    done

All of the commands above have been working on the dataset stored on local file
system.  It is worth noting that in all instances the commands would have
worked the same if the URI for the input dataset had been changed from
``~/my_datasets/aphid-rna-seq-data`` to the URI of the dataset copied to iRODS
``irods:///jic_archive/1f79d594-e57a-4baa-a33a-dd724ad92cd6``.
