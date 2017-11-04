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
