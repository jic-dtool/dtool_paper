Literature review
=================

The FAIR Guiding Principles for scientific data management and stewardship
--------------------------------------------------------------------------

https://www.nature.com/articles/sdata201618

- Findability
- Accessibility
- Interoperability
- Reusability

Focus on principles required for machines to be able to discover and consume
data.  Although the principles are sound there is little practical advice on
how make data fair and it is hard to see how it could be implemented by anyone
other than organisations dedicated to hosting scientific data such as the wwPDB
or UniProt.


10 aspects of highly effective research data
--------------------------------------------

https://www.elsevier.com/connect/10-aspects-of-highly-effective-research-data

- Trusted
- Shared
- Saved

An extension of the FAIR principles that is meant to function as a roadmap for
incremental and continual improvements of data management processes and
systems.

1. Stored
2. Preserved
3. Accessible
4. Discoverable
5. Citable
6. Comprehensible
7. Reviewed
8. Reproducible
9. Reusable
10. Integrated

Although the roadmap is sane it contains little practical advice and it is
unclear how anyone other than organisations dedicated to hosting scientific
data would have the resources to go beyond step 2.


Ten Simple Rules for Creating a Good Data Management Plan
---------------------------------------------------------

http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1004525

Article describes how to write a good data management plan and puts the
steps into the context of the data life cycle. Of particular relevance to
dtool are rules:

2. Identify the data to be collected; an equivalent step is required before
   creating a dtool dataset

3. Define how the data will be organised; dtool provides a means to organise
   data

4. Explain how the data will be documented; dtool provides a means to document
   a dataset with descriptive metadata in a README file

6. Present a sound data storage and preservation strategy; dtool make it easy
   to move datasets between different types of backends and the dataset API
   makes it possible to create custom tools for uploading data to domain
   specific databases such as the SRA

7. Define the project's data policies; when populating the readme the user is
   interactively asked to specify if the data is either confidential or if it
   contains personally identifiable information, further it is easy to customise
   for example if one wanted to add a field that specified the licence

Because these rules are aimed at researchers writing a data management plan
rather than an organisation dedicated to hosting scientific data we find that
there is more overlap with our thinking and tools.


Ten Simple Rules for Digital Data Storage
-----------------------------------------

http://journals.plos.org/ploscompbiol/article?id=10.1371/journal.pcbi.1005097

Article giving practical advice on how to store and organise actual files with
data. Again, because this article is aimed at scientists rather than organisations
hosting scientific data we find that there is a lot of overlap with our thinking
and tools. In particular:

3. Keep raw data raw; dtool leaves original files intact and uses mark up to
   add additional metadata

4. Store data in open format; the mark up used by dtool is plain text files
   using standard formats such as YAML and JSON

5. Data should be structured for analysis; dtool provides a CLI and an API for
   programmatic discovery and access to the items and item metadata in a
   dataset

6. Data should be uniquely identifiable; a dtool dataset is given a UUID and
   each item in a dataset has a unique identifier

7. Link relevant metadata; dtool goes even further by packing the data and the
   metadata into a self contained whole


Implementing a genomic data management system using iRODS in the Wellcome Trust Sanger Institute
------------------------------------------------------------------------------------------------

https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-12-361

Article illustrating the commitment required to setup a system where the
metadata is stored in a database.

TODO
----

- Similar to dtool? `Research Objects: Towards Exchange and Reuse of Digital Knowledge
  <http://precedings.nature.com/documents/4626/version/1/files/npre20104626-1.pdf>`_
- Like Galaxy? `openBIS: a flexible framework for managing and analyzing
  complex data in biology research
  <https://bmcbioinformatics.biomedcentral.com/articles/10.1186/1471-2105-12-468>`_
- Metadata in a triple store? `API-centric Linked Data integration: The Open
  PHACTS Discovery Platform case study
  <http://www.sciencedirect.com/science/article/pii/S1570826814000195>`_
