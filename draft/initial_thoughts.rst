Lightweight data management
===========================


Abstract
--------

Good science requires careful data management. This has been true thoughout the history of the subject, but advances in data capture technology, particularly the explosion of genomic and imaging data has made data management a much more difficult challenge. As the difficulty of managing data has grown, so too has the drive to make that data openly accessible and searchable, to aid future scientific discovery.

However, most existing scientific data management systems are heavyweight. Providing the key computational infrastructure (particularly large scale databases) requires both investment of considerable time, expertise and compute/storage resources. They also require a considerable adaptation of existing user ways of thinking, as well as making it harder to easily extract data or work with data directly with other tools.

Driven by internal need, we developed a tool to allow the lightweight annotation of existing on-disk data with dataset-wide descriptive metadata, individual file level metadata, and structural metadata sufficient to ensure the integrity of files. The tool is developed primarily as an API, with a simple command line interface. The API includes backend storage for local disk, iRODS and various cloud storage options, allowing the easy backup and retrieval of data.

Annotating our data with appropriate metadata, and ensuring STUFF.

1. Easier to understand for the scientists that generate it, their groups that need to work with it, funders that want to see it shared, and the scientific community as a whole.
2. Verifiable against corruption, with the added benefit of being easy to move
3. Machine readable and so pluggable into pipelines

Our tool is not intended to supplant large, fully featured data management systems, but instead to provide a fast, flexible way to improve the management of existing data, as well as new data. (REVISE)

The problem
-----------

Science is intrinsically a data driven discipline.

Understanding how to manipulate data

While effective management of data has always been a key challenge in science, the scale of the problem has grown rapidly over recent years. Breakthoughs in sequencing technology, particularly short read or next generation (NGS) sequencing have led to an explosion in data volumes. Microscopy data SOMETHING SOMETHING. Beyond the sheer scale of the data, the rapidly changing ecosystem of tools and pipelines for processing data means that THING.


Open access to data is increasingly viewed as a public good, and funding organisations are enforcing this through requirements to provide plans for sharing data generated through research projects (REFERENCES).


Despite all of these things, researchers are still bad at managing data. This is partly time and training, but also tools. Any tool that requires either substantial centrally managed infrastucture, extensive training to use, or both

Metadata provides 

Another reason to manage data is that funders require it.

Copying data is hard!

In particular, we want to be able to:

1. Take data organised in a filesystem on disk and easily annotate it with metadata so that we can index and search it.
2. Make backups of that data, while checking the integrity of the backup processes and the backups themselves.
3. Feed our data into processing pipelines that can act on both the data and metadata.

State of the art
----------------

Historically, laboratory notebooks were (ARE) used to record scientific observations. These are typically series of individual observations, or potentially transcriptions of automatic readings. 

Laboratory Information Management systems, or LIMS for short provide ways to manage and categorise certain types of data (sequencing data for example). However, these are typically oriented towards particular types of data and rely strongly on central databases.

Specialised management systems
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Examples include the OMERO system for bioimage data (REF), 

Metadata in a database (e.g. iRODS)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

These solutions typically THING. This has a number of problems:

1. A considerable amount of computational infrastructure is required to even begin to use them. For example, iRODS requires several servers (DETAILS), including a database. Each of these components must be managed, including monitoring, resilience, backups, updates and so on.

2. These systems provide what is effectively an all or nothing solution

3. These systems require a considerable commitment to use - in particular it can be difficult to extract data from them

4. They provide a barrier to immediate use. For example, to make use of iRODS, users must be familiar with the iRODS commands

Everything in the processing system (e.g. Galaxy)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Another approach to data management is to use an integrated workflow system or platform. These systems provide a way to manage a whole data analysis pipeline, from import of data through processing and analysis of results. Examples include Galazy or Taverna for Genomics

1. Many of the problems above

2. Plus tend to be specialised for particular kinds of data.


An ideal world
--------------

Ideally, we would like a way to get the benefits of organisation and categorisation of data, along with the associated possibilities for automated analysis, without a dependency on a central database. The ability to use centralised resources to discover and track data is very useful, but it can too easily become a limitation or point of failure.

Standard computer filesystems provide a simple way to store files, but have limited capacity to provide metadata accompanying those files.

The benefits of data markup
---------------------------

1. We can understand the data in future, preserving key information such as who owns the data, how it was generated and so on.

2. We can collectively understand what data we have.

3. We can process the data automatically

4. We can more easily compare data against other data.

How data mangement should work
------------------------------

1. We receieve data.

2. We annotate the data with the information necessary to process it. For example, NGS sequence data comprising RNA-Seq reads from a particular species can be annotated with the identity of the species, details of which are forward and reverse reads and so on.

3. We make a copy-of-record (PHRASING?) of the data, ensuring that we have a write protect version.

4. We feed the data into processing pipelines. These produce intermediate data (for example, raw sequencing reads produce alignment (BAM) files, or image analysis produces annotated output images).


What we are looking for in a a solution
---------------------------------------

* It should be backend agnostic - i.e. it can store data in 
* It should allow centralised registration of datasets, but without requiring it.
* It should allow critical structural properties of files (particularly checksums and sizes) to be recorded, so that the data can be moved around and have its integrity checked.

Any solution needs to meet the needs of the various groups that are interested in data management, in particular:

* Funders
* Individual researchers
* Research groups
* System administrators

Thinking in data
~~~~~~~~~~~~~~~~

Being able to think about, and operate on structured collections of individual files is very powerful. In particular it allows us to RAISE OURSELVES TO AWESOMEHOOD. Often we need to be able to work with our data as a whole - for example, a set of alignments (THINGS) for different individuals within a population need to be analysed together. 

Our tool
--------

To overcome these problems, we developed a lightweight tool for data management, designed to provide scientists at the John Innes Centre with a fast and easy option for improving their data management practices. Our design goals were to:

* Provide a simple way to annotate existing on-disk data with information that would 
* Avoid dependence on centralised infrastructure, so that datasets were portable
* Provide a flexible API, such that other tools, processes and pipelines could work with the data

In particular, dtool allows annotation of on-disk data with:

1. Free-form descriptive metadata (e.g. who owns the data, when it was created etc.). 

2. File-level administrative metadata, used by the tool to ensure veracity (?) of the data. This includes last modification times, file checksums/hashes and file sizes.

3. Structured file-level metadata annotation. These can be generated either manually (BY THING), or programmatically


The core tool is implemented as a clean Pythonic API, along with a command line tool and various supporting tool.

CLI
~~~

The CLI enables the user to:

1. Quickly markup existing data as a DataSet. This process involves proviving descriptive metadata for the whole dataset in the form of a README file, as well as autmatically generating individual file level property information (such as size, last modified time and checksum) so that the integrity of the data can be confirmed a a later point.

2. Further annotate individual files with STUFF. We provide some tools for automatic overlay generation for common data formats (such as the generation of Illumina metadata)

2. Verify that the data

Drivers
~~~~~~~

We provide backend drivers to allow DataSets to be stored on local disk, in our iRODS system and in public cloud storage (via the S3 or Microsoft Azure protocols). These provide an easy way to backup data, and ensure the veracity of the backups.

Support tools
~~~~~~~~~~~~~

Developing our tool primarily as an API has allowed us to quickly implement other tools and processes to take advantage of the API.

1. Dserve - serve the data over a REST API. Used by clicky things, galleries and so on.

2. Uploading raw sequence reads to the SRA (REF), is a key part of many data management approaches for sequence data. The upload process requires the user to provide key metadata about what they are uploading (such as the organism's species, the type of sequencer and so on). Our tool THINGY.

3. Processing tools. These transform DataSets into other DataSets. For example, our alignment pipeline converts a DataSet annotated as raw read data into alignment files (BAM + BAI). Our cell image analysis tool tranforms 2D images of cells into segmentations along with cell level data about widths and heights.

4. Automatic annotation tools. These extract metadata embedded in files and use this metadata to annotate the data, such that it can be easily retrieved via our API. One example is the extraction of Illumina metadata (such as flow cell identifier, lane number, read pair etc.) from fastq files. Another is the extraction of camera and GPS metadata from images. 

Implementation
~~~~~~~~~~~~~~

How the tool solves the problem
-------------------------------

We have adapted our internal processes and pipelines to work with our tooling. When we receive data, from internal systems or collaborators, we annotate it with metadata, and register a copy of the raw data with an EXTERNAL source.

Conclusions
-----------

Data management is critical to science, and as such we need good tools to aid the process. The annotation of raw and processed data with appropriate metadata to enable categorisation, processing and discovery is a critical component of data management. Systems exist to allow this annotation, but implementing them requires considerable computational infrastructural resources, as well as investment in time and training. Beyond this, scientists can be reluctant to adopt these tools if it requires too much change to their existing ways of working.

We have developed a set of related tools, designed around a core API, to allow the lightweight annotation of disk files with descriptive and structural metadata. This turns the data into a 'DataSet' which can then be registered, for automatic discovery and categorisation, pushed to external hosting locations (such as FigShare or DataDryad), and processed by automated tools and pipelines. The tool is simple to use, both through its command line interface, but also through its well documented and SANE API.
