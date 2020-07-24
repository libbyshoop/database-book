Same Base A and B, 1 - 1 match over cols Aid(M),Bid(M)
------------------------------------------------------------

Now let's start with the previous result relation as one of the input relations:

*Same reside_townId as origin_townId Creature - Skill Pair*

Let's match join this relation as our A relation (identified by creatureId, SkillCode) with Aspiration as our B relation. Aspiration's columns are:

|

.. image:: ../img/MatchJoin/07/Aspiration_cols.png
    :width: 480px
    :align: center
    :alt: Aspiration columns

|

There are two key points to understanding this circumstance:

1. Aspiration is also a Creature - Skill Pair, because it is identified by creatureId and skillCode. A and B are therefore the same base.

2. Since each of these are identified by creatureId and skillCode, there is a 1 - 1 correspondence between a row in A and a row in B *if we match over these two columns and any others.* This makes this a 1-1 symmetric-either case, so we will use the half house and each relation will point to the peak.

Here is the English Query:

    Find each Creature - Skill pair where the Creature aspired to a Skill in the same town that the Skill originated in and is the same town that the creature resides in.

**Why this query?**

In other words, we're looking for creatures who aspire to a skill that originates in the same town that they live in. Creatures may have these aspirations because the skill is well known in their town, such as water skiing in Bemidji, Minnesota or perfecting the football (soccer) penalty kick in London, England. A step towards mastery is to realize that you can do such queries. Being able to do them will make you a star in any organization. For this example, knowing this is in this contrived situation of this database can further lead you to recommend to some creatures that they may want to aspire to achieve a skill from their home town.


The precedence chart:

|

.. image:: ../img/MatchJoin/07/SameBase_1_1_M_M.png
    :height: 450px
    :align: center
    :alt: SameBase, 1-1, over Aid(M),Bid(M)

|


The identifier of the result relation is still creatureId, skillCode. Thus the base of the result relation remains Creature-Skill Pair. This is always the case with any 1-1, same base, symmetric-either case like this.


Now here is the SQL implementation for this query. Note that we create an intermediate relation for the result from the query in the previous section. *This is a concept that was seen in the previous chapter.*

.. tabbed:: SameBase_1_1_M_M

    .. tab:: SQL Times-Filter-Reduce MJ query

      .. activecode:: same_aspired_town_cr_sk_pair
        :language: sql
        :include: all_creature_create

        DROP TABLE IF EXISTS sameTownCreatureSkillPair;

        -- same reside_townId as origin_townId Creature-Skill Pair
                    -- reduce by removing B.townId
        CREATE TABLE sameTownCreatureSkillPair AS
        SELECT A.*, B.skillCode, B.skillDescription, 
                    B.maxProficiency, B.minProficiency
        FROM Creature A, Skill B       -- times
        WHERE A.reside_townId = B.origin_townId   -- equality match filter
        ;

        SELECT A.*, B.aspiredProficiency
        FROM sameTownCreatureSkillPair A, Aspiration B
        WHERE A.creatureId = B.creatureId
        AND   A. skillCode = B.skillCode
        AND A.reside_townId = B.desired_townId
        ;

    .. tab:: SQL Inner Join MJ  query

      .. activecode:: same_aspired_town_cr_sk_pair_inner
        :language: sql
        :include: all_creature_create

        DROP TABLE IF EXISTS sameTownCreatureSkillPair;

        -- same reside_townId as origin_townId Creature-Skill Pair
                    -- reduce by removing B.townId
        CREATE TABLE sameTownCreatureSkillPair AS
        SELECT A.*, B.skillCode, B.skillDescription, 
                    B.maxProficiency, B.minProficiency
        FROM Creature A 
        INNER JOIN Skill B       -- like MJ operator symbol
        ON A.reside_townId = B.origin_townId   -- equality match filter
        ;

        SELECT A.*, B.aspiredProficiency
        FROM sameTownCreatureSkillPair A
        INNER JOIN Aspiration B
        ON A.creatureId = B.creatureId
        AND   A. skillCode = B.skillCode
        AND A.reside_townId = B.desired_townId
        ;
    
Exercise
~~~~~~~~

This exercise is a bit trickier and is trying to help you develop further mastery. It is understandable and reasonable if it seems harder and takes a bit more time to think it through. Pull out your copy of :download:`the Small Creature Database Schema<smallCreatureDB_LDS.pdf>` to inspire you. 

I always am referring to a database's schema to look for the shapes that lead to particular types of queries. Note how the query example on this page is related to the chicken-feet in shape from Creature to Aspiration to Skill on the schema, and the result from the previous page was about the Creature-Skill pair that can be made from the chicken feet in shape between Creature, Town, and Skill. With this in mind, try this:

There are other 1-1, same base queries with different types of 'works on' column circumstances that can be devised from this database. Using the notion that there are several relations in addition to Aspiration that represent Creature-Skill pairs or can be used as input relations to other queries that result in Creature-Skill pairs, see if you can come up with English queries and the precedence charts for them.
