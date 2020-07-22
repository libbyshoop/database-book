

The Common Circumstances
----------------------------

The rest of the sections of this chapter on the following pages will contain seven common circumstances where Match Join is used on original relations in a database (those that correspond to the entities on the conceptual schema and had data inserted for them). You can and often do use Match Join with intermediate relations. In some of these cases the circumstance (which relations, Symmetry, works-on) is fairly straightforward, and in other cases it can be somewhat complex. We will present two of the straightforward cases.

The nine total examples we will present in detail are as follows in this table:


.. table:: **Circumstances For Match Joins In this Chapter**
    :align: left

    +-----------+-----------------------+----------------+---------------------+
    |Bases of   |A data to B data       |Symmetry        |Input relation       |
    |A, B       |through works-on cols  |for symbol      |columns being matched|
    +===========+=======================+================+=====================+
    |Different  |M-1                    |Non-Symmetric-A |   Aid(D),Bid(E)     |
    |Base,      |                       |                |                     |
    |Achievement|                       |                |                     |
    |Skill      |                       |                |                     |
    +-----------+-----------------------+----------------+---------------------+
    |Different  |M-1                    |Non-Symmetric-A |  Aid(D),Bid(M)      |
    |Base,      |                       |                |                     |
    |Achievement|                       |                |                     |
    |Skill      |                       |                |                     |
    +-----------+-----------------------+----------------+---------------------+
    |Different  |M-1                    |Non-Symmetric-A |  Aid(S),Bid(E)      |
    |Base,      |                       |                |                     |
    |Aspiration |                       |                |                     |
    |Creature   |                       |                |                     |
    +-----------+-----------------------+----------------+---------------------+
    |Different  |M-M                    |Symmetric-Pair  |  Aid(D),Bid(D)      |
    |Base,      |                       |                |                     |
    |Creature   |                       |                |                     |
    |Skill      |                       |                |                     |
    +-----------+-----------------------+----------------+---------------------+
    |Same       |1-1                    |Symmetric-Either|  Aid(M),Bid(M)      |
    |Base,      |                       |                |                     |
    |Aspiration |                       |                |                     |
    |Creature-  |                       |                |                     |
    |Skill Pair |                       |                |                     |
    +-----------+-----------------------+----------------+---------------------+
    |Same       |1-1                    |Symmetric-Either|  Aid(E),Bid(E)      |
    |Base,      |                       |                |                     |
    |TeamSkill  |                       |                |                     |
    |Skill      |                       |                |                     |
    +-----------+-----------------------+----------------+---------------------+
    |Same       |1-1                    |Symmetric-Either|  Aid(E),Bid(E)      |
    |Base,      |                       |                |                     |
    |Achievement|                       |                |                     |
    |Aspiration |                       |                |                     |
    +-----------+-----------------------+----------------+---------------------+
    |Same       |M-1                    |Non-Symmetric-A |  Aid(D),Bid(E)      |
    |Relation,  |                       |                |                     |
    |Creature   |                       |                |                     |
    |Creature   |                       |                |                     |
    +-----------+-----------------------+----------------+---------------------+
    |Same       |M-M                    |Symmetric-Pair  |  Aid(D),Bid(D)      |
    |Relation,  |                       |                |                     |
    |Creature   |                       |                |                     |
    |Creature   |                       |                |                     |
    +-----------+-----------------------+----------------+---------------------+


The first three are the Different Base, M -1, but the works-on columns are different. The other cases are other circumstances.

The following sections will proceed to the nine actual cases using the small creature database. You have already gotten a taste for two of them.  The Different Base, M - 1, Non-Symmetric-A example was what we used in the first section (creating Achievement with its Skill data). We just used the Different-Base, M - M, Symmetric Pair example (creating Creature-Skill Pair) to motivate how to think about symmetry in the previous section.
