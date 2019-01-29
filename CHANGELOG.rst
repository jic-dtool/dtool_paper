CHANGELOG
=========

1.3.0
-----

Minor tweaks in response to reviewer comments.

- Removed Figure 1
- Removed Figure 2
- Removed Figure 5
- Removed Figure 6
- Added year to Kunze reference
- Removed 1 "easily" in Methodology section
- Replaced 3 "makes it easy to" with "enables researchers to" in Results section
- Replaced 2 "easy" with "possible" in Results section
- Removed 2 "easy" in Results section
- Replaced "some clear" with "several" in Results section
- Removed "clear" in Results section
- Replaced the word "powerful" with "can be used to" in Results section
- Changed TiB to TB
- Expanded paragraph relating to test coverage to give more details
- Added section explaining the choice of Python as an implementation language
- Added details about testing and documentation technologies
- Added another paragraph describing the main barriers to uptake to the "Uptake
  at JIC section"
- Added paragraph to state that we will be collecting information more
  systematically to improve dtool
- Added note to mention that we were not aware of BagIt when we started
  developing dtool
- Changed tone when talking about per-item metadata
- Added note that we would like to test the idea that dtool could make use of
  BagIt format for storing datasets on disk


1.2.0
-----

Changes in response to reviewers comments.

- Restructured sections using more traditional headings
- Removed the word "extreme" in relation to traditional lab notebooks
- Removed statements not backed up by references or data
- Remove extraneous "need"
- Change sentence from "The URL below represents a publically accessible
  dataset hosted in Amazon S3 object storage" to "The URL below represents a
  dataset hosted in Amazon S3 that can be accessed by anyone using dtool
  (the URL is not intended to be displayed using a web browser)"
  to make it clearer that the URL is meant for consumption by dtool
- Updated simple_processing.sh script to reflect output
- Introduced the ``dtool uuid`` command earlier in the making sense of data section
- Added more references Lynch 2008, Howe 2008, Cook 2018, Stephens 2015
- Qualified the selection of the examples of organisations hosting scientific
  data to be from our domain
- Added paragraph on sustainability
- Made discussion about FAIR more nuanced
- Added figure describing the structure of a dataset
- Added sequence diagram figure illustrating the creation of a dataset
- Added example illustrating how different storage technologies differ
- Clarified that it is easy to lose metadata when moving it around, rather than
  it being difficult to move data per say
- Added more detail and clarification to the verify section
- Added section to results about uptake at JIC
- Added section to discussions about challenges of uptake at JIC
- Updated format of ``dtool summary`` output in line with reviewer's suggestion
  https://github.com/jic-dtool/dtool-info/issues/14
- Replaced ``dtool_publish_dataset`` with ``dtool publish`` in line with
  reviewer's suggestion
  https://github.com/jic-dtool/dtool-create/issues/19
- Added design decisions section to the Methodology section
- Created Git repository with scripts from manuscript and the supplementary material
  https://github.com/jic-dtool/dtool_examples
- Added reference to BagIt to introduction
- Added comparison to BagIt to discussion


1.1.0
-----

Changes in response to editors comments.

- Added extended use cases
- Added supplementary material


1.0.0
-----

Initial submission.
