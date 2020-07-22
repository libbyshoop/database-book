Different Base A and B, M - 1 match over cols Aid(S),Bid(E)
------------------------------------------------------------

English Query:

    Find each Aspiration with its Creature data.

LDS database schema fragment pertaining to this query:

|

.. image:: ../img/MatchJoin/05/Asp_Cr_LDS.png
    :width: 420px
    :align: center
    :alt: Creature database Creature - Aspiration - Skill intersection shape

|

Columns of the three relations in the fragment:

|

.. image:: ../img/MatchJoin/05/Asp_Cr_cols.png

|

**Logic to use in decision-making process for chart formulation:**

The coloring of the columns is to indicate which columns from two of the three relations could be used as the 'works on' columns in the binary Match Join operator. For the above stated English query, we will use Aspiration and Creature as the two input relations. Since the query has no mention of anything like "same reside_townId as origin_towndId", we can decide that the matching will be on creatureId of Creature and its foreign key in Aspiration, also called creatureId. (The phrase 'with its' helps us decide this.) The creatureId column is exactly (E) Creature's identifier, and the creatureId column is some (S), but not all of the columns representing Aspiration's identifier.

The two relations are obviously different base, and the relationship between them, through the creatureId data, is M - 1 from Aspiration to Creature. This is also apparent from the DB schema fragment. This lets us decide to put Aspiration, the many end (A) , at the peak of the half-house non-symmetric Match Join symbol, and Creature at the lower side of the top of the half-house symbol (the B relation). 

The precedence Chart thus becomes:

|

.. image:: ../img/MatchJoin/05/Asp_Cr_MJ_S_E.png

|

Note how in this case, as in the previous few sections, the original English query led us easily to the name of the result relation. Knowing that can be the starting point of how you think about this and many of these charts- you can fill in the result relation name first and work backwards.




Other Queries to try:
~~~~~~~~~~~~~~~~~~~~~

Use the logic above to practice developing charts for the following queries.


    Find each Aspiration with its Skill Data.

    Find each Aspiration with its creature data where the creature resides in the same town that they desired/aspired to obtain the Skill.

    Find each Aspiration with its skill data where the aspiredProficiency is equal to the maxProficiency of that skill.

For these queries, let's branch out to other relations. Pull out your copy of :download:`the Small Creature Database Schema<smallCreatureDB_LDS.pdf>` to work on these. Practice the steps for decision making with these queries, as was used in the logic described above:

1. These are all different bases for the two input relations.
2. Is it a M-1 relationship, and if so, which relation is the many end?
3. What are the 'works on' columns and which letter (EMSOD) applies to each of the two relations.


    Find each AspiredContribution plus its creature data.

    Find each AspiredContribution plus its aspiration data.

    Find each contribution plus its achievement data.

    Find each contribution plus its creature data.






.. image:: https://upload.wikimedia.org/wikipedia/commons/2/2d/Wikidata_logo_under_construction_sign_square.svg
    :width: 100px
    :align: left
    :alt: Under construction
