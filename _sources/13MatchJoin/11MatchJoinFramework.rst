Match Join Framework
----------------------

.. image:: https://upload.wikimedia.org/wikipedia/commons/2/2d/Wikidata_logo_under_construction_sign_square.svg
    :width: 100px
    :align: left
    :alt: Under construction

    
The eight total examples we presented in detail are as follows in this table:


.. table:: **Circumstances For Match Joins In this Chapter**
    :align: left

    +-----------+-----------------------+---------------+----------------------+
    |Bases of   |A data to B data       |Symmetry       | Input relation       |
    |A, B       |through works-on cols  |for symbol     | columns being matched|
    +===========+=======================+===============+======================+
    |Different  |M-1                    |Non-Symmetric-A|    Aid(D),Bid(E)     |
    |Base,      |                       |               |                      |
    |Achievement|                       |               |                      |
    |Skill      |                       |               |                      |
    +-----------+-----------------------+---------------+----------------------+
    |Different  |M-1                    |Non-Symmetric-A|   Aid(D),Bid(M)      |
    |Base,      |                       |               |                      |
    |Achievement|                       |               |                      |
    |Skill      |                       |               |                      |
    +-----------+-----------------------+---------------+----------------------+
    |Different  |M-1                    |Non-Symmetric-A|   Aid(O),Bid(E)      |
    |Base,      |                       |               |                      |
    |Aspiration |                       |               |                      |
    |Creature   |                       |               |                      |
    +-----------+-----------------------+---------------+----------------------+
    |Different  |M-M                    |Symmetric-Pair |   Aid(D),Bid(D)      |
    |Base,      |                       |               |                      |
    |Creature   |                       |               |                      |
    |Skill      |                       |               |                      |
    +-----------+-----------------------+---------------+----------------------+
    |Same       |M-M                    |Symmetric-Pair |   Aid(M),Bid(M)      |
    |Base,      |                       |               |                      |
    |Aspiration |                       |               |                      |
    |Creature-  |                       |               |                      |
    |Skill Pair |                       |               |                      |
    +-----------+-----------------------+---------------+----------------------+
    |Same       |1-1                    |Symmetric-Pair |   Aid(E),Bid(E)      |
    |Base,      |                       |               |                      |
    |TeamSkill  |                       |               |                      |
    |Skill      |                       |               |                      |
    +-----------+-----------------------+---------------+----------------------+
    |Same       |M-1                    |Non-Symmetric-A|   Aid(D),Bid(E)      |
    |Relation,  |                       |               |                      |
    |Creature   |                       |               |                      |
    |Creature   |                       |               |                      |
    +-----------+-----------------------+---------------+----------------------+
    |Same       |M-M                    |Symmetric-Pair |   Aid(D),Bid(D)      |
    |Relation,  |                       |               |                      |
    |Creature   |                       |               |                      |
    |Creature   |                       |               |                      |
    +-----------+-----------------------+---------------+----------------------+

The first three are the Different Base, M -1, but the works-on columns are different. The generic conceptual schema fragment and precedence charts for these 3 cases looks the same. So 6 generic circumstances are shown next, as a means to orient you to these common cases and be able to apply them to other situations.

M - 1 match over cols between Different Base A and B

M - M match over cols between A, B (Different Base)

M - M match over cols between A, B (Same Base)

1 - 1 match over cols between A and B (Same Base)

M - 1 match over cols between A and itself (Same Relation)

M - M match over cols between A and itself (Same Relation)
