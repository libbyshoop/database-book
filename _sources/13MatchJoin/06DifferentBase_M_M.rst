Different Base A and B, M - M match over cols Aid(D),Bid(D)
------------------------------------------------------------

English Query:

    Find each Creature - Skill pair where the Skill originated in
    the same town that the creature resides in.

LDS fragment pertaining to this query:

|

.. image:: ../img/MatchJoin/06/Cr_TownSkill_LDS.png
    :width: 480px
    :align: center
    :alt: Creature database Creature - Aspiration - Skill intersection shape

|

We have previously motivated that this is a M - M case because there can be a Creature whose reside town is the origin town of more that one Skill, and there can be a Skill whose origin town is the reside town for more than one creature.

.. important:: The decision that this is a M - M situation stems from the conceptual model's shape: **the chicken feet out shape with Town at the center tells us that the matching of Creature to Skill on a townId is a potential M - M situation.**

Columns of the three relations in the fragment:

|

.. image:: ../img/MatchJoin/06/Cr_Town_Skill_cols.png

|

Note that the columns highlighted in yellow are the ones that potentially can be matched between any two of these three entities using a Match Join.

Precedence Chart for the above English Query:

|

.. image:: ../img/MatchJoin/06/Cr_Skill_Pair_MJ_D_D.png

|

Note that the M-M nature led us to the symmetric-pair case, needing the full house. By examining the column we were matching over, we see that it is different than the identifier for each of the two input relations, so we have Aid(D) and Bid(D) in the Match Join house operator. 

**Naming the result relation:** this example shows a new choice we have to make for determining the base of this result. The M-M symmetry between the two inputs means that we will always name it A-B pair, so in this case it became Creature-Skill pair. Note also that because of this, the new identifier is the combination of the identifiers of the two input relations (in this case creatureId, skillCode).

Now here is the SQL implementation for this query.

.. tabbed:: DifferentBase3_MJ_M_M

    .. tab:: SQL Times-Filter-Reduce MJ query

      .. activecode:: same_town_cr_sk_pair
        :language: sql
        :include: all_creature_create
        :showlastsql:

        -- same reside_townId as origin_townId Creature-Skill Pair
                    -- reduce by removing B.townId
        SELECT A.*, B.skillCode, B.skillDescription, 
                    B.maxProficiency, B.minProficiency
        FROM Creature A, Skill B       -- times
        WHERE A.reside_townId = B.origin_townId   -- equality match filter
        ;

    .. tab:: SQL Inner Join MJ  query

      .. activecode:: same_town_cr_sk_pair_inner
        :language: sql
        :include: all_creature_create
        :showlastsql:

        -- same reside_townId as origin_townId Creature-Skill Pair
                    -- reduce by removing B.townId
        SELECT A.*, B.skillCode, B.skillDescription, 
                    B.maxProficiency, B.minProficiency
        FROM Creature A 
        INNER JOIN Skill B       -- like MJ operator symbol
        ON A.reside_townId = B.origin_townId   -- equality match filter
        ;
    


.. note::
    This example is different in that we are not matching on a foreign key column. Because of this, this is not the prevalent "natural join" that applied for the previous example. Yet we can use the INNER JOIN keywords as shown in the second tab.
 



Other Queries to try:
~~~~~~~~~~~~~~~~~~~~~~~

Try creating the precedence charts for these queries. As suggested before, pay attention to the circumstances : 

a. What are the bases of the two input relations. (different or same?)
b. Is it a M-M relationship like the example in this section?
c. What are the 'works on' columns and which letter (EMSOD) applies to each of the two relations.

**English Query:**

    1. Find each Skill - Creature pair where the creature *aspires* to obtain the skill in the same town that the Skill originated in.

    2. Find each same-creatureId Contribution - AspiredContribution pair where the Achievement tested in the same town that the creature resided in.

    3. Find each same-creatureId and same test town as desired town Achievement-Aspiration pair.
