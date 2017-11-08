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
and structural metadata. The administrative metadata is information that helps
manage the dataset and includes for example an automatically generated UUID.
The structural metadata is information on how the dataset is put together, for
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

The structure of a dataset...

The dataset creation process...

The storage broker interface...

Scenario 1: packing and moving data...

Scenario 2: discovering, understanding and verifying data...

Scenario 3: accessing and processing data...
