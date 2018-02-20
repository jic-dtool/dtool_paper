Lightweight Data management
***************************

Abstract
========


The explosion in data types and volumes has led to substantial challenges in
data management. These challenges are often faced by front-line researchers who
are already dealing with rapidly changing technologies and approaches and have
limited time and patience to devote to data management.

There are good high level guidelines for managing and processing scientific
data. However, there are a lack of simple, practical tools to implement these
guidelines. This is a particularly problem in a highly distributed research
environment where needs differ substantially from group to group, centralised
solutions are difficult to implement and storage technologies change rapidly.

We have developed Dtool, a Python package with a command line tool and scripting
interface to meet these challenges. The tool packages data and metadata into a
unified whole, which we call a dataset. The dataset provides consistency
checking and the ability to access metadata for both the whole dataset and
individual files. The tool can store these datasets on several  different
storage systems, particularly filesystem, object store (S3 and Azure) and iRODS.

The tool has provided substantial process, cost, and peace-of-mind benefits to
our data management practices and we hope to share these benefits.

Introduction
============

Science is a data driven discipline and therefore requires careful data
management. Particularly in biology, advances in our ability to capture and
store data have resulted in a "big data explosion".

Another recent trend highlighting the importance of data and data
management is the movement towards open access to data. Open access to data is
increasingly viewed as a public good [`Open Data and the Social Contract of
Scientific Publishing
<http://www.bioone.org/doi/full/10.1525/bio.2010.60.5.2>`_], and funding
organisations are enforcing this through requirements to provide plans for
sharing data through research projects [`Data management plan REF
<http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1004525>`_].

Despite this need for scientific data management it remains a challenge and
many different approaches to meeting this need have emerged.

At one extreme scientific data management consists of researchers recording
observations in laboratory notebooks. And at another extreme there are
organisations dedicated to curating and hosting scientific data, examples
include `The UniProt Consortium
<https://academic.oup.com/nar/article-lookup/doi/10.1093/nar/gkw1099>`_, `The
CCDC <http://scripts.iucr.org/cgi-bin/paper?S2052520616003954>`_, `The SRA
<https://www.ncbi.nlm.nih.gov/pmc/articles/PMC3013647/>`_.

In-between these two extreme solutions there is a variety of systems aimed at
making data management easier for particular types of data. Laboratory
Information Management Systems, or LIMS for short, provide ways to manage and
categorise certain types of data.  Traditionally these were oriented towards
sample management and they often rely on central databases. More specialised
systems for managing data produced by certain types of instruments also exist.
[`OMERO <https://www.ncbi.nlm.nih.gov/pubmed/22373911>`_], for example, is a
system aimed at managing microscopy data. These systems also tend to rely on
central databases.

More generic solutions for managing data also exist. One example is [`iRODS
<https://irods.org/uploads/2015/01/irods4-microservices-book-web.pdf>`_], which
focuses on the ability to build up capacious storage solutions by allowing
access to distributed storage assets, associating data items with metadata
stored in a central database and the ability to create rules to
automatically perform data management task when data items are added to the
system.  Another example is [`openBIS
<Https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-12-468>`_],
which has some interesting ideas on how to manage data. openBIS considers datasets
to be immutable. It also has concepts for "container datasets" that can provide
different views of the data and "child datasets" that can be created from one
or more parents. openBIS is similar to iRODS in that it is a hybrid data
repository with metadata stored in a database for fast querying and data as
flat files.  Bare bones systems such as these are flexible, but require effort
to customise [`iRODS at Sanger
<https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-12-361>`_].

Here we describe an alternative, more lightweight approach to managing data. It
centres around the concept of packing metadata with the data, and working with
the two as a unified whole.

This article contains high-level concepts about data management relevant to
both project leaders interested in ensuring that their data is understandable
to all members of their research group as well as the larger research
community. The article also contains practical solutions for researchers, such
as bioinformaticians, that are challenged with managing high volumes of
scientific data. The latter assumes that the reader has some familiarity with
the command line. Apart from this section this article should be accessible to
all.

The Data Management Problem
===========================

Data management is a broad term and means different things to different
people. At a high level, funders and the research community as a whole
care about data being trusted, shared and reusable [`FAIR data REF
<https://www.nature.com/articles/sdata201618>`_, `Effective research data REF
<https://www.elsevier.com/connect/10-aspects-of-highly-effective-research-data>`_.
At an intermediate level, research institutes and project leaders need to think
about the life cycle of data [`Data management plan REF
<http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1004525>`_],
and how to get the resources they need for their data.
At the ground level individual researchers need to think about how to
structure their data into files, how these data files are organised and how to
associate metadata with these data files [`Digital Data Storage REF
<http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1005097>`_,
`Tidy Data REF <http://vita.had.co.nz/papers/tidy-data.html>`_, `Leek data
sharing REF <http://vita.had.co.nz/papers/tidy-data.html>`_.

Although the broad and general goals of data management such as making data Findable,
Accessible, Interoperable and Reusable [`FAIR data REF
<https://www.nature.com/articles/sdata201618>`_] are admirable, they are at this
point in time very difficult to achieve for anyone other than organisations dedicated to
hosting scientific data [`Effective research data REF
<https://www.elsevier.com/connect/10-aspects-of-highly-effective-research-data>`_].
One reason for this is that there is a lack of tools even for basic data management
at the level of research institutes, research groups and individual researchers.

Another reason data management is difficult at the ground level is that there
is little incentive for the people generating the data, most commonly PhD
students and post-docs, to care about data management. This is understandable
as their career relies on them generating research outputs such as
publications, not managing data.


Our Motivations
===============

Our data management challenges occur at the John Innes Centre (JIC), an
independent research institute in plant and microbial sciences. Like many
academic or research institutions, the JIC has a strongly decentralised
structure and culture. Each of the 40+ research groups acts mostly as
independent units.

This poses a significant challenge to any data management process, and renders
many existing solutions, which rely on enforced compliance with centralised
systems, difficult to use.

This tends to lead to situations where key metadata are encoded in file names
and paths, which can easily be lost when files are moved around. Coupled with
concern about losing data when moving files, this leads to storage systems
becoming full and data accumulating endlessly.

The academic research funding environment is unpredictable. As a result, we have
a mixture of different storage technologies bought at different times. Each
technolgy has its own quirks that the end user needs to gain familiarity with.
Having to juggle different storage systems is not a productive use of
researcher's time.

Within this context, we need to:

1. Ensure that we can meet our obligations towards our funding bodies regarding
   data management and sharing.
2. Help our researchers to manage their data, particularly to make cost
   effective use of our storage systems. This means providing appropriate
   solutions for different use cases; fast read access storage for processing
   data and capacious storage for long term archival of data.

We needed a solution that would:

* Provide clear, immediate benefit to the front line data managers (either core
  facility staff or bioinformaticians embedded in research groups).
* Allow group leaders and institute management to get an overview of the data they have.
* Enable use of different storage systems and technologies, without changing
  tools and pipelines.

The solution needed to be light-weight enough to get users started without a
long learning process (or long copy times in moving data to centralised
platforms).

These are all common requirements for those managing data in heterogeneous
research environments. Therefore any solution that meets these needs is likely
to be valuable to a wide range of researchers and support groups, particularly
those without existing centralised data management systems.

Our Solution
============

Our solution to our data management problem is Dtool.
It is lightweight in that it has no requirements for a (central) database. It simply
consists of a command line tool for packing and interacting with data and an
application programming interface (API) giving programmatic access to the data.

The most important aspect of Dtool is that it packages data files with
accompanying metadata into a unified whole. The packaged data and metadata is
referred to as a dataset. Having the metadata associated with the data means
that datasets can easily be moved around and that the dataset contains all
the information required to verify the integrity of the data within it.

To illustrate the benefits of packaging data and associated metadata into a
unified whole, it is worth comparing it to other solutions. A common solution
is to store metadata in file names and directory structures. For example
consider a file named ``col0_chitin_leaf_1.tif`` stored in a directory named
``repl_2``. The file name contains several pieces of metadata, namely that the
image is of leaf sample 1 (``leaf_1``), of the wild type variant of *A.
thaliana* (``col0``), treated with chitin (``chitin``). Furthermore the information
that this is replicate 2 (``repl_2``) is encoded in the directory structure.
This makes it hard to move this data around without losing metadata.

Another common approach is to store metadata in a database, this is the
solution used by systems such as iRODS and openBIS. A database is quite a heavyweight
solution for managing metadata and it has the disadvantage that one needs
access to the database to be able to work with the data. It makes it
difficult to work off-site when the database is managed centrally within an
institute. It also makes it difficult to move data into other systems.

When using Dtool to create a dataset it generates both administrative metadata
and structural metadata. The administrative metadata contains information that
helps manage the dataset and includes for example an automatically generated
universally unique identifier (UUID). The structural metadata describes how the
dataset is put together, for example each data item in the dataset has
associated information about its size, hash (a string that can be used to
verify the integrity of the file) and relative path recorded in a manifest,
stored as part of the dataset.

When creating a dataset the user is prompted to add descriptive metadata about
the dataset. The user is, for example, prompted to describe the dataset, state
the project name and whether or not the dataset contains any confidential or
personally identifiable information.


Technical details and example use cases
---------------------------------------

The structure of a dataset depends on the "backend" used to store it. In other
words a dataset is structured differently on a traditional file system to how
it is structured in Amazon S3 object storage. However, the details of how the
dataset is structured is abstracted away. The dataset in itself has no
knowledge of how to read and write (meta) data, it delegates that responsibility
to the backend.  This architecture makes it easy to plug-in new backends to
Dtool to suit local storage options.

Dtool makes use of Unique Resource Identifiers (URIs) to refer to datasets.
This is useful as datasets can be stored in different types of backends.
Below are examples of two URIs, the first is to a dataset stored on local
disk, the second is to a dataset stored in an Amazon Web Service S3 bucket
named ``dtool-demo``.

.. code-block:: none

    file:///Users/olssont/my_datasets/simulated-lambda-phage-reads
    s3://dtool-demo/af6727bf-29c7-43dd-b42f-a5d7ede28337

Below is the on disk structure of a fictional dataset containing two items
from an RNA sequencing experiment. The ``README.yml`` file is where the
descriptive metadata used to describe the whole dataset is stored. The items of
the dataset are stored in the directory named data. The administrative and
structural metadata is stored as JSON files in a hidden directory named
``.dtool``.  This was an explicit design decision aimed at making all files
human readable, in order to future proof the dataset.

.. code-block:: none

    $ tree my_datasets/simulated-lambda-phage-reads
    my_datasets/simulated-lambda-phage-reads
    ├── README.yml
    └── data
        ├── reads_1.fq.gz
        └── reads_2.fq.gz


Datasets are created in three stages. First one creates a so called "proto
dataset". Secondly, one adds data and metadata to the proto dataset. Finally
one converts the proto dataset into a dataset by "freezing" it.

A common use case with Dtool is to package raw data and copy it to remote
storage to back it up. The first step is to create a proto dataset. The command
to create a proto dataset takes as input the name of the dataset and it returns
instructions on how to finalise the dataset creation.

.. code-block:: none

    $ dtool create simulated-lambda-phage-reads
    Created proto dataset file:///Users/olssont/simulated-lambda-phage-reads
    Next steps:
    1. Add raw data, eg:
       dtool add item my_file.txt file:///Users/olssont/simulated-lambda-phage-reads
       Or use your system commands, e.g:
       mv my_data_directory /Users/olssont/simulated-lambda-phage-reads/data/
    2. Add descriptive metadata, e.g:
       dtool readme interactive file:///Users/olssont/simulated-lambda-phage-reads
    3. Convert the proto dataset into a dataset:
       dtool freeze file:///Users/olssont/simulated-lambda-phage-reads

The Dtool client has commands for adding data items. However, when working on
traditional file system it is often easier to just move the data into the data
directory.

.. code-block:: none

    $ mv ~/Downloads/simulated-reads/* simulated-lambda-phage-reads/data

To add descriptive metadata one could edit the ``README.yml`` file directly.
However, the Dtool client comes with built-in functionality for prompting
for generic descriptive metadata.

.. code-block:: none

    $ dtool readme interactive simulated-lambda-phage-reads
    description [Dataset description]: Simulated lambda phage reads
    project [Project name]: Dtool demo
    confidential [False]:
    personally_identifiable_information [False]:
    name [Tjelvar Olsson]:
    email [tjelvar.olsson@jic.ac.uk]:
    username [olssont]:
    creation_date [2018-02-06]:
    Updated readme
    To edit the readme using your default editor:
    dtool readme edit simulated-lambda-phage-reads

To convert the proto dataset into a dataset one needs to freeze it.

.. code-block:: none

    $ dtool freeze simulated-lambda-phage-reads
    Generating manifest  [####################################]  100%  reads_2.fq.gz
    Dataset frozen simulated-lambda-phage-reads

This generates a manifest with per item metadata such as the file sizes and
hashes.

To back up a dataset one may want to copy it to a different location, which can
be in a different backend.  In the example below we have an iRODS zone named
``/jic_archive`` to which we want to copy the local dataset.

.. code-block:: none

    $ dtool copy simulated-lambda-phage-reads s3://dtool-demo
    Generating manifest  [####################################]  100%  reads_1.fq.gz
    Dataset copied to:
    s3://dtool-demo/af6727bf-29c7-43dd-b42f-a5d7ede28337

The command above did several things. It created a proto dataset in the iRODS
backend and copied across all the data and metadata from the local dataset.
Then it converted the proto dataset to a dataset in iRODS by freezing it.
Finally it returned the URI of the dataset in iRODS.

Another common scenario is to want to discover, understand and verify data. To list the
dataset in a particular location one can use the ``dtool ls`` command.

.. code-block:: none

    $ dtool ls ~/my_datasets
    lamda-phage-genome
      file:///Users/olssont/my_datasets/lamda-phage-genome
    simulated-lambda-phage-reads
      file:///Users/olssont/my_datasets/simulated-lambda-phage-reads

The listed dataset names can then be used to identify datasets that one would
like to query for more information.

For example to list the items in the ``simulated-lambda-phage-reads`` one can
use the ``dtool ls`` command again.

.. code-block:: none

    $ dtool ls ~/my_datasets/simulated-lambda-phage-reads
    3b70c2af09ad2fc979680a5a3c31c32ec1d2559a  reads_2.fq.gz
    5fbf98674019f357014ed5bae073b5ac8c75862a  reads_1.fq.gz

In the above each item identifier and relative path is listed. This information
gives an impression of what is contained in a dataset.

To get more information about a dataset one can view the descriptive
metadata. In the example below the ``dtool readme show`` command is used to
show the descriptive metadata packed into the ``lambda-phage-genome`` dataset.

.. code-block:: none

    $ dtool readme show my_datasets/lamda-phage-genome
    ---
    description: Enterobacteria phage lambda, complete genome
    creation_date: 2018-02-06
    accession: NC_001416.1
    link: https://www.ncbi.nlm.nih.gov/nuccore/NC_001416.1
    reference: |
      Nucleotide [Internet]. Bethesda (MD):
      National Library of Medicine (US),
      National Center for Biotechnology Information; [1988] - .
      Accession No. NC_001416.1, Enterobacteria phage lambda, complete genome
      [cited 2018 Feb 06]
      Available from: https://www.ncbi.nlm.nih.gov/nuccore/NC_001416.1

For a more structural overview of the dataset on can run the ``dtool summary``
command, which gives information about who created the dataset, the number of
items it contains and the total size of all the items in the dataset.

.. code-block:: none

    $ dtool summary ~/my_datasets/simulated-lambda-phage-reads
    {
      "name": "simulated-lambda-phage-reads",
      "uuid": "af6727bf-29c7-43dd-b42f-a5d7ede28337",
      "creator_username": "olssont",
      "number_of_items": 2,
      "size_in_bytes": 2441356,
      "frozen_at": 1517925148.82
    }

Sometimes one wants to ensure that data has not become corrupted, for example
one may be worried that a file may have been accidentally removed or altered.
To verify that the dataset has not been corrupted one can use the ``dtool
verify`` command.

.. code-block:: none

    $ dtool verify ~/my_datasets/simulated-lambda-phage-reads
    All good :)

The default behaviour of ``dtool verify`` is to check that the correct item
identifiers are present in the dataset and that the items have the correct
size. It is also possible to verify the content of each item by supplying
the ``-f/--full`` option, which forces the content of the items to be checked
against the hashes stored in the dataset's manifest.

All of the commands above have been working on the dataset stored on local file
system.  It is worth noting that in all instances the commands would have
worked the same if the URI had pointed at a dataset in S3 object storage. This
is powerful as the end user can use the same commands to interact with datasets
stored in different backends, making knowledge about the Dtool command line
interface transferable between different storage systems.

A third common scenario is to want to access to data in order to be able to process it.
It is possible to simply copy a whole dataset from one location to another.

.. code-block:: none

    $ dtool copy s3://dtool-demo/af6727bf-29c7-43dd-b42f-a5d7ede28337
    Generating manifest  [####################################]  100%  reads_2.fq.gz
    Dataset copied to:
    file:///tmp/simulated-lambda-phage-reads

When the command above finishes the data will be available in the
``/tmp/simulated-lambda-phage-reads/data`` directory.

Alternatively, one can gain access to a data item on local file system using
the ``dtool item fetch`` command which returns the absolute path to a file with
the content of the data once it is available. By combining this command with
``dtool identifiers``, which list the data item identifiers in a dataset one
can create a Bash script to process all the items in a dataset.

.. code-block:: bash

    DS_URI=s3://dtool-demo/af6727bf-29c7-43dd-b42f-a5d7ede28337
    for ITEM_ID in `dtool identifiers $DS_URI`;
    do
      ITEM_FPATH=`dtool item fetch $DS_URI $ITEM_ID`;
      echo $ITEM_FPATH;
    done

This programmatic access to data, available both from the Dtool command line
tool and the API, makes it easy to incorporate Dtool datasets in scripts and
automated pipelines.

Dtool datasets have been designed in accordance with the principles in
[`Digital Data Storage REF
<http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1005097>`_].
Dtool leaves original files intact and uses mark up to add additional metadata,
thus adhering to the principle of keeping raw data raw.  The mark up used by
Dtool is plain text files using standard formats such as YAML and JSON, thus
adhering to the principle of storing data in open formats. Dtool provides a
CLI and an API for programmatic discovery and access to the items and item
metadata in a dataset, thus adhering to the principle that data should be
structured for analsyis. A Dtool dataset is given a UUID and each item in a
dataset has a unique identifier, thus adhering to the principle that data
should be uniquely identifiable. There is also a principle of providing links
to relevant metadata, which is possible with Dtool. However, Dtool goes even
further by packing the data and the metadata into a self contained whole



Discussion
==========

Data management provides a set of difficult problems. Technological developments
in scientific instruments (high throughput sequencers or super resolution
microscopes, for example) have led to an explosion of data that must be stored,
processed and shared. This requires both recording of appropriate metadata and
ensuring consistency of data.

These problems are compounded by the issue that those directly generating and
handling data (often junior researchers) have different immediate incentives
from funders and institutions. These front-line researchers need to be able to
quickly receive and process their data to generate scientific insights, without
investing substantial time learning to use complex data management systems.

Long term maintenance and sharing of data is, however, critical for the long
term success of science. This translates into requirements from research funders
and the institutions that host research groups on how data are stored and
shared.

While there are good theoretical guidelines for data management best practices
and protocols, there is a lack of direct tooling to support these protocols,
particularly in the decentralised environment in which much research takes
place.

Our attempts to solve these challenges led us to the development of Dtool. This
tool provides a quick and straightforward way to package a collection of related
files together with key metadata, which we term a dataset. This dataset provides
both consistency checking and access to both dataset and file level metadata,
while being portable.

The tool has provided substantial benefits for our internal data management
practices. Dataset consistency checking has given our researchers peace of mind
that the key data underpinning their scientific results are safe and secure.

Encouraging capture of appropriate metadata when datasets are created has led to
better organisation of data and ability to retrieve and understand data long
after capture and storage.

Giving the tool the ability to store data on the many different storage systems
to which we have access has substantially reduced our storage costs, translating
into increased capacity to store and process data with the same resources.

Providing these benefits through a tool which can be used independently of
centralised systems has improved uptake, particularly by being able to
demonstrate immediate benefit to the researchers using the tool without concern
for lock-in.

On a higher level Dtool datasets are also a good fit with many of the ideas
regarding the life cycle of data [`Data management plan REF
<http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1004525>`_].
An early step in the life cycle of data is to identify the data to be
collected. An equivalent step is required before creating a Dtool dataset.  The
life-cycle of data requires one to define how the data will be organised. Dtool
provides means to organise data. The life-cycle of data requires one to explain
how the data will be documented. Dtool provides a means to document a dataset
with descriptive metadata in a README file.  The life cycle of data requires
one to present a sound data storage and preservation strategy. Dtool make it
easy to move datasets between different types of storage solutions and the
dataset API makes it possible to create custom tools for uploading data to
domain specific databases. The life-cycle of data requires one to define the
project's data policies. When populating the readme the user is interactively
asked to specify if the data is either confidential or if it contains
personally identifiable information, further it is easy to customise for
example if one wanted to add a field that specified the licence


Conclusion
==========

Without good data mangement, reproducible science is impossible. Our rapidly
expanding ability to collect and process data has the potential to generate
important insights, but presents a range of problems in handling those data.

In particular, capturing and storing metadata together with data, ensuring
consistency of data that is comprised of multiple individual files and being
able to use heterogeneous storage systems with different capabilities and access
methods are subtantial challenges, particularly in the highly decentralised
environment in which much scientific research takes place.

Dtool provides a lightweight and flexible way to package individual files and
metadata into a portable whole, which we term a dataset. This dataset provides
consistency checking, giving reseachers confidence that their data maintains
integrity while moving it between storage systems. Storing key file- and
dataset-level  metadata together allows the data to be understood in future. The
ability to use different storage backends such as filesystem, iRODS, S3 or Azure
storage allows data to be moved to the most appropriate location to balance cost
and accessibility.

The tool has provided substantial benefits to our internal data management
practices, giving researchers peace of mind, allowing better retrieval and
accessibility of data to comply with funder requirements, and saving
substantially on storage costs. Our tool is available as free open source
software under the MIT  license, and we hope that it will provide benefit to
others.
