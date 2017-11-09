Lightweight Data management
***************************

Introduction
============

Write this...

Problem statement
=================

Data management is a broad term and it means different things to different
people. At a very high level funders and the research community as a whole
cares about data being trusted, shared and reusable [`FAIR data REF
<https://www.nature.com/articles/sdata201618>`_, `Effective research data REF
<https://www.elsevier.com/connect/10-aspects-of-highly-effective-research-data>`_.
At an intermediate level research institutes and project leaders need to think
about the life cycle of data [`Data management plan REF
<http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1004525>`_].
Whereas at the ground level individual researchers need to think about how to
structure their data into files, how these data files are organised and how to
associate metadata with these data files [`Digital Data Storage REF
<http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1005097>`_,
`Tidy Data REF <http://vita.had.co.nz/papers/tidy-data.html>`_, `Leek data
sharing REF <http://vita.had.co.nz/papers/tidy-data.html>`_.

Although the high level goals of data management such as making data Findable,
Accessible, Interoperable and Rusable [`FAIR data REF
<https://www.nature.com/articles/sdata201618>`_] are admirable they are at this
point in time very difficult to reach for anyone other than organisations dedicated to
hosting scientific data [`Effective research data REF
<https://www.elsevier.com/connect/10-aspects-of-highly-effective-research-data>`_].
One reason for this is that there is a lack of tooling even for basic data management
at the level of research institutes, research groups and individual researchers.

Another reason data management is difficult at the ground level is that there
is little incentive for the people generating the data, most commonly PhD
students and post-docs, to care about data management.

Our strategy to data management at the JIC is therefore to provide light weight
tooling that solves problems of the people generating and analysing data that
results in better data management as a side-effect rather than as the primary goal.


Our Motivations
===============

The work described in this paper is the result of three driving forces.
Helping contracts implement a data management plan for the institute to fulfil
obligations towards funding bodies. Helping researchers manage their data
better to free up space on the expensive centralised storage system.  Helping
ourselves develop more standardised methods to process data coming into the
Informatics group so that we could expand more easily. About a year ago we got
involved in discussions with the institutes contracts department who were
worried about the funding bodies data management requirements and whether or
not the institute was doing enough to ensure that the research groups were
aware and abiding to them. At around the same time it was becoming apparent
that on-site storage was filling up and we needed to help (force) researchers
to start managing their data better. Thirdly our centralised Informatics group
was undergoing expansion and to enable this scaling we needed to develop more
standardised ways of being able to handle and process incoming data.

To put this into context it is worth describing the structure of the JIC at
a high level. It is a plant and microbe research institute employing about 400
researchers. Its research falls into four strategic programs whose aims are to

1. Develop a wider and deeper understanding of how the environment influences plant growth and development
2. Investigate the vast diversity of chemicals produced by plants and microbes
3. To understand the molecular dialogue between plants and microbes
4. To develop new wheat germplasm containing the next generation of key traits

Although the research field is focussed around plants and microbe the scope is
very broad.

The research is driven by the 40 research groups in the institute. The research
groups are largely autonomous as there is little central management of the
research. This means that the institute can be likened to an incubator with
lots of small startup companies in it. This is a great environment for
innovation and generating research discoveries. However, it is not a setup that
lends itself to developing centralised protocols and standard operating
procedures.

*The broad nature of the research at the institute meant that
one requirement was that our data management tool needed to be able to deal
with heterogeneous data. This meant that specialised systems that deal with
specific types of data did not fit our needs.*

*The innovative nature of the research at the institute meant that the tool
would be constantly challenged with new types of data. This meant that any
system that needed customisations to deal with new types of data did not
fit our needs.*

*The distributed and autonomous nature of the research in the institute meant
that the tool needed to be able to deal with heterogeneous working practises.*

The institute has centralised high-performance computing cluster and associated
storage. With an increasing number of groups doing more and more next
generation sequencing the storage system was filling up. This meant that some
research groups resorted to shuttling data in between the cluster storage and
external hard-drives. As external hard-drives are notoriously prone to failure
this was a non-ideal situation.

In an attempt to improve this situation we configured a centrally managed 
system with cheaper storage that could be accessed using iRODS. However, we
found that the uptake of this system was limited. Largely because working
with raw iRODS commands was difficult for end users. Trust was also an issue,
having transferred the data to the less convenient storage using iRODS the
users were worried that the data may have been lost or corrupted along the way.

*We therefore needed a tool that made it easier to interact with remote storage
systems such as iRODS and S3 object stores. Furthermore, this tool needed to
have the ability to verify that the data transfer had been successful.*

As more and more of the research groups at the institute require support from
the Informatics team the throughput of the data we recieved and processed was
increasing. We therefore wanted a means to standardise the way we organised and
processed the data we received, to make it easier to distribute the work
between individuals in the team.

*To write these tools we wanted to have programatic access to data. In
particular we wanted to abstract away the concepts of file paths that were
a constant source of frustration in writing processing scritps.*

*We also realised that for some processing we needed to be able to annotate
individual data items with metadata.*

*Furthermore, to help us navigate the data that we received we needed to be able
to be able to annotate data with metadata on a per dataset level.*


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
This is an explicit design decision aimed at making all files human readable,
in order to future proof the dataset.

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


Example use cases
-----------------

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

All of the commands above have been working on the dataset stored on local file
system.  It is worth noting that in all instances the commands would have
worked the same if the URI for the input dataset had been changed from
``~/my_datasets/aphid-rna-seq-data`` to the URI of the dataset copied to iRODS
``irods:///jic_archive/1f79d594-e57a-4baa-a33a-dd724ad92cd6``.

A third common scenario is to want to access to data in order to be able to process it.
It is possible to simply copy a whole dataset from one location to another.

.. code-block:: none

    $ dtool copy irods:///jic_archive/1f79d594-e57a-4baa-a33a-dd724ad92cd6 /tmp
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

    DS_URI=irods:///jic_archive/1f79d594-e57a-4baa-a33a-dd724ad92cd6
    for ITEM_ID in `dtool identifiers $DS_URI`;
    do
      ITEM_FPATH=`dtool item fetch $DS_URI $ITEM_ID`;
      echo $ITEM_FPATH;
    done


Discussion
==========

One of the reasons data management is difficult is that there is little
incentive for the people generating the data, most commonly PhD students and
post-docs, to care about it. 

However, the people generating data do care about being able to process it to
generate results.  They also care about not loosing the data they have
generated.

As the convenient storage accessible from the HPC cluster fills up the
researchers generating data become more and more amenable to the idea of
pushing raw data to a remote location to free up space on the convenient
storage required for processing. Particularly if that remote location is
backed up.

However, managing data as a collection of individual files is hard. Analysing
that data will require that certain sets of files are present, understanding it
requires suitable metadata, and copying or moving it while keeping its
integrity is difficult.

Dtool solves this problem by packaging a collection of files and accompanying
metadata into a self contained and unified whole: a dataset. By encapsulating
both the data files and associated metadata in a dataset one is free to move
the dataset around at will. The high level organisation of datasets can
therefore evolve over time as data management processes change.

Dtool also solves an issue of trust. By including file hashes as metadata it is
possible to verify the integrity of a dataset after it has been moved to a new
location or when coming back to a dataset after a period of time.

With some training we have been able to get our users that generate high
volumes of data to start using Dtool to package their raw data and push it into
capacious (but less convenient) storage managed using iRODS. This means that
data is annotated with descriptive metadata and that it gets stored in a
canonical location.

In order to be able to process data it needs to be accessible from the
convenient storage. Dtool enables this in two fashions. At the most
basic level the whole dataset can be copied from the capacious (iRODS)
storage to the convenient (file system) storage. Alternatively it is
possible to fetch specific data items from the capacious storage.

Many bioinformatics pipelines produce large intermediate files that take a long
time to generate. Although these are intermediate files that can be regenerated
people like to keep them until work has been published because they take a long
time to regenerate.

In order to be able to get these files off the convenient storage we have
created a separate capacious location for storing long term intermediate data.
The main incentive for people to move their large intermediate files into this
capacious location is because they need to free up space on the convenient
storage.

Because it is possible to programatically create datasets both using the
Dtool client and the Python API we have started developing batch processing
script for our HPC cluster that follow the steps below:

1. Pull in raw and/or intermediate data from the capacious storage to the
   convenient storage
2. Process the data on the convenient storage
3. Package the resulting files into a long term intermediate and/or final dataset(s)
4. Push the resulting datasets into the capacious storage
5. Clean up working directory in the convenient storage

For the end user this means more working space in the convenient storage as files
are only stored there temporarily. From a data management perspective it means
that long term intermediate and final results are also stored in canonical locations.

Because the raw/intermediate data accessed in (1) are stored in a canonical
location with and are accessible via persistent URIs the batch scripts become
more reproducible. Although this is not an aim in data management itself,
reproducibility is a key feature of science.

Using this workflow  we fulfil the first six steps of
`Effective research data REF <https://www.elsevier.com/connect/10-aspects-of-highly-effective-research-data>`_,
at least within the institute.

1. Stored
2. Preserved
3. Accessible
4. Discoverable
5. Citable
6. Comprehensible

It is also worth noting that the Dtool datasets have been designed with
accordance to the principles in
[`Digital Data Storage REF
<http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1005097>`_.
In particular:

3. Keep raw data raw; Dtool leaves original files intact and uses mark up to
   add additional metadata

4. Store data in open format; the mark up used by Dtool is plain text files
   using standard formats such as YAML and JSON

5. Data should be structured for analysis; Dtool provides a CLI and an API for
   programmatic discovery and access to the items and item metadata in a
   dataset

6. Data should be uniquely identifiable; a Dtool dataset is given a UUID and
   each item in a dataset has a unique identifier

7. Link relevant metadata; Dtool goes even further by packing the data and the
   metadata into a self contained whole

It also fits in well with the ideas about the life cycle of data
[`Data management plan REF
<http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1004525>`_].
In particular:

2. Identify the data to be collected; an equivalent step is required before
   creating a Dtool dataset

3. Define how the data will be organised; Dtool provides a means to organise
   data

4. Explain how the data will be documented; Dtool provides a means to document
   a dataset with descriptive metadata in a README file

6. Present a sound data storage and preservation strategy; Dtool make it easy
   to move datasets between different types of backends and the dataset API
   makes it possible to create custom tools for uploading data to domain
   specific databases such as the SRA

7. Define the project's data policies; when populating the readme the user is
   interactively asked to specify if the data is either confidential or if it
   contains personally identifiable information, further it is easy to customise
   for example if one wanted to add a field that specified the licence


Conclusion
==========

Write this...
