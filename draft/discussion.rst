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
