Technical details and example use cases
---------------------------------------

This section describes how dtool can be used to manage data. It can be
skipped by people only interested in high level concepts of data
management.

### Creating and storing a dataset

A common use case with dtool is to package raw data and copy it to
remote storage to back it up.

Datasets are created in three stages. Firstly one creates an editable
"proto dataset". Secondly, one adds data and metadata to the proto
dataset. Finally one converts the proto dataset into a dataset by
"freezing" it, this generates verification information. 

The first step is to create a proto
dataset. The command to create a proto dataset takes as input the name
of the dataset and it returns instructions on how to finalise the
dataset creation.

``` {.sourceCode .none}
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
```

The dtool client has commands for adding data items. However, when working on
local file system it is often easier to just move or download the data into the
data directory. In the example below two simulated lambda phage next generation
sequencing reads are downloaded from the Bowtie2[@Langmead2012] code repository
as plain text files using ``wget``. After download the plain text files are
compressed using ``gzip``.

``` {.sourceCode .none}
$ COMMIT="80edefea19084d5b027a46f2e4feaae949d6a11c"
$ BASE_URL="https://github.com/BenLangmead/bowtie2/tree/$COMMIT/example/reads"
$ wget -P simulated-lambda-phage-reads/data $BASE_URL/reads_1.fq
$ wget -P simulated-lambda-phage-reads/data $BASE_URL/reads_2.fq
$ gzip simulated-lambda-phage-reads/data/reads_1.fq
$ gzip simulated-lambda-phage-reads/data/reads_2.fq
```

The dtool client comes with built-in functionality for prompting for generic
descriptive metadata.

``` {.sourceCode .none}
$ dtool readme interactive simulated-lambda-phage-reads
description [Dataset description]: Simulated lambda phage reads
project [Project name]: dtool demo
confidential [False]:
personally_identifiable_information [False]:
name [Tjelvar Olsson]:
email [tjelvar.olsson@jic.ac.uk]:
username [olssont]:
creation_date [2018-02-06]:
Updated readme
To edit the readme using your default editor:
dtool readme edit simulated-lambda-phage-reads
```

It is also possible to edit the descriptive metadata in the `README.yml` file
directly.  This can be achieved using the ``dtool readme edit`` command, which
opens the ``README.yml`` file using the default text editor.  In this case the
descriptive metadata was updated to contain the YAML formatted text below.

``` {.sourceCode .yaml}
---
description: "Simulated Lambda phage reads from Bowtie2 getting started example"
creation_date: "2018-02-06"
notes: "The raw reads have been compressed using gzip"
license: "Raw data from code repository under GNU General Public License v3.0"
links:
  - raw_data: "https://bit.ly/2GGadPL"
  - bowtie2_paper: "https://dx.doi.org/10.1038/nmeth.1923"
```

To convert the proto dataset into a dataset one needs to freeze it.

``` {.sourceCode .none}
$ dtool freeze simulated-lambda-phage-reads
Generating manifest  [####################################]  100%
Dataset frozen simulated-lambda-phage-reads
```

This generates a manifest with per item metadata such as the file sizes
and hashes.

To back up a dataset, one may want to copy it to a different location,
which can be in a different storage backend. In the example below we have an
Amazon S3 bucket named `dtool-demo` to which we want to copy the local
dataset.

``` {.sourceCode .none}
$ dtool copy simulated-lambda-phage-reads s3://dtool-demo
Generating manifest  [####################################]  100%
Dataset copied to:
s3://dtool-demo/af6727bf-29c7-43dd-b42f-a5d7ede28337
```

The command above copied the local dataset to remote storage and
returned a reference to the dataset in the remote storage.


### Structure of datasets

The structure of a dataset depends on the "backend" used to store it. In
other words a dataset is structured differently on a traditional file
system to how it is structured in Amazon S3 object storage. However, the
details of how the dataset is structured are abstracted away. The dataset
itself has no knowledge of how to read and write (meta) data, it
delegates that responsibility to the backend. This architecture makes it
easy to plug-in new backends to dtool to suit new storage options.
There are currently backend implementations for traditional file system,
Amazon S3 object store, Microsoft Azure Storage and iRODS.


Below is the on-disk structure of a dataset containing two
items from an RNA sequencing experiment. The `README.yml` file is where
the descriptive metadata used to describe the whole dataset is stored.
The items of the dataset are stored in the directory named `data`. The
administrative and structural metadata is stored as JSON files in a
hidden directory named `.dtool`. The use of human readable and open file
formats such as YAML and JSON was a design decision aimed at
future proofing the dataset, i.e. to make the dataset self-explanatory
even without access to dtool.

``` {.sourceCode .none}
$ tree my_datasets/simulated-lambda-phage-reads
my_datasets/simulated-lambda-phage-reads
├── README.yml
└── data
    ├── reads_1.fq.gz
    └── reads_2.fq.gz
```

### Referring to datasets

dtool makes use of Unique Resource Identifiers (URIs) to refer to
datasets. This is useful as datasets can be stored in different types of
backends. Below are examples of two URIs, the first is to a dataset
stored on local disk, the second is to a dataset stored in an Amazon Web
Service S3 bucket named `dtool-demo`.

``` {.sourceCode .none}
file:///Users/olssont/my_datasets/simulated-lambda-phage-reads
s3://dtool-demo/af6727bf-29c7-43dd-b42f-a5d7ede28337
```

### Finding and verifying datasets

Another common scenario is to want to discover, understand and verify
data. To list the dataset in a particular location one can use the
`dtool ls` command.

``` {.sourceCode .none}
$ dtool ls ~/my_datasets
lambda-phage-genome
  file:///Users/olssont/my_datasets/lambda-phage-genome
simulated-lambda-phage-reads
  file:///Users/olssont/my_datasets/simulated-lambda-phage-reads
```

The listed dataset names can then be used to identify datasets that one
would like to query for more information.

For example to list the items in the `simulated-lambda-phage-reads` one
can use the `dtool ls` command again.

``` {.sourceCode .none}
$ dtool ls ~/my_datasets/simulated-lambda-phage-reads
3b70c2af09ad2fc979680a5a3c31c32ec1d2559a  reads_2.fq.gz
5fbf98674019f357014ed5bae073b5ac8c75862a  reads_1.fq.gz
```

In the above, each item identifier and relative path is listed. This
information gives an overview of what is contained in a dataset.

To get more information about a dataset one can view the descriptive
metadata. In the example below the `dtool readme show` command is used
to show the descriptive metadata packed into the `lambda-phage-genome`
dataset.

``` {.sourceCode .none}
$ dtool readme show my_datasets/lambda-phage-genome
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
```

For a more structural overview of the dataset on can run the
`dtool summary` command, which gives information about who created the
dataset, the number of items it contains and the total size of all the
items in the dataset.

``` {.sourceCode .none}
$ dtool summary ~/my_datasets/simulated-lambda-phage-reads
{
  "name": "simulated-lambda-phage-reads",
  "uuid": "af6727bf-29c7-43dd-b42f-a5d7ede28337",
  "creator_username": "olssont",
  "number_of_items": 2,
  "size_in_bytes": 2441356,
  "frozen_at": 1517925148.82
}
```

Sometimes one wants to ensure that data has not become corrupted, for
example one may be worried that a file has been accidentally removed or
altered. To verify the integrity of a dataset one can use the
`dtool verify` command.

``` {.sourceCode .none}
$ dtool verify ~/my_datasets/simulated-lambda-phage-reads
All good :)
```

The default behaviour of `dtool verify` is to check that the expected
item identifiers are present in the dataset and that the items have the
correct size. It is also possible to verify the content of each item by
supplying the `-f/--full` option, which forces the content of the items
to be checked against the hashes stored in the dataset's manifest (Fig 3.).

![
The packaged metadata can be used to verify the integrity of the data items in
the box giving researchers peace of mind that the data underpinning their
scientific results are safe and secure.
](verify_items_in_box.png)


All of the commands above have been working on a dataset stored on
local file system. It is worth noting that in all instances the commands
would have worked the same if the URI had pointed at a dataset in S3
object storage. This is powerful as the end user can use the same
commands to interact with datasets stored in different backends, making
knowledge about the dtool command line interface transferable between
different storage systems.


### Accessing the contents of a dataset

When needing access to data stored on a remote system one can either
get the entire dataset or specific items from within it.

The command below copies an entire dataset from the ``dtool-demo`` bucket
in Amazon S3 object storage to the ``/tmp`` directory on the local computer.

``` {.sourceCode .none}
$ dtool copy s3://dtool-demo/af6727bf-29c7-43dd-b42f-a5d7ede28337 /tmp
Generating manifest  [####################################]  100%
Dataset copied to:
file:///tmp/simulated-lambda-phage-reads
```

When the command above finishes the data will be available in the
`/tmp/simulated-lambda-phage-reads/data` directory.

Alternatively, one can gain access to a data item on local file system
using the `dtool item fetch` command which returns the absolute path to
a file with the content of the data once it is available. By combining
this command with `dtool identifiers`, which lists the data item
identifiers in a dataset, one can create a Bash script to process all the
items in a dataset.

``` {.sourceCode .bash}
DS_URI=s3://dtool-demo/af6727bf-29c7-43dd-b42f-a5d7ede28337
for ITEM_ID in `dtool identifiers $DS_URI`;
do
  ITEM_FPATH=`dtool item fetch $DS_URI $ITEM_ID`;
  echo $ITEM_FPATH;
done
```

This programmatic access to data, available both from the dtool command
line tool and the Python API, makes it easy to incorporate dtool
datasets in scripts and automated pipelines. In the Python code example below
we apply the function ``process_reads_file()`` to each item in the dataset
that is pulled in from Amazon S3 object store to local disk.

``` {.sourceCode .python}
from dtoolcore import DataSet
dataset = DataSet.from_uri(
	"s3://dtool-demo/af6727bf-29c7-43dd-b42f-a5d7ede28337"
)

for i in dataset.identifiers:
    process_reads_file(dataset.item_content_abspath(i))
```
