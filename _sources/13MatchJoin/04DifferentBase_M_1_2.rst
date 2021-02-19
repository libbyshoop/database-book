Different Base A and B, M - 1 match over cols Aid(D),Bid(M)
--------------------------------------------------------------

In this example, we still consider this part of the database represented by this fragment of the conceptual schema, but now we take note that there is one other pair of columns that could be matched: test_townID of Achievement and origin_townId of Skill.

|

.. image:: ../img/MatchJoin/Ach_Skill_LDS_frag.png
    :width: 220px
    :align: center
    :alt: Creature database Achievement - Skill many to one shape

|

We can ask an English query that will give us a slightly fewer number of rows (as you might expect it to in most shapes like this).

    Find each Achievement with its Skill data where the Skill was achieved in the same town that it originated in.

Or rephrased to more closely match what will be in the result relation:

    Find each Achievement with its same skillCode, same test_townId as origin_townId Skill data.

**Logic to use in decision-making process for chart formulation:**

The above stated English query uses Achievement and Skill as the two input relations and they still have different bases.

Indeed, the relationship circumstance is also the same: M-1, non-symmetric, implying the half-house symbol with Achievement as the A (M,peak) relation and Skill as the B (1, lower end) relation. 

The  difference is  the 'works on' columns are different, because along with matching on skillCode, we are adding an exact match on the test_townId of Achievement to the origin_townId of Skill. This makes the works-on situation in the Match Join symbol different, as shown below. The skillCode, test_townID columns are different than Achievement's identifier, and since skillCode identifies Skill, the skillCode, origin_townID columns comprise of more than Skill's identifier. So the Match Join symbol contains Aid(D): skillCode, origin_townID and Bid(E): skillCode, origin_townID.

|

.. image:: ../img/MatchJoin/04/Ach_Skill_MJ_D_M.png
    :width: 400px
    :align: center
    :alt: Match Join example

|

**Result relation name and base:** note that as with the previous example, the base of the result relation is the same as the A relation (Achievement in this case). When we use more columns to match over, we now add a new phrase "same skillCode, same test_townId as origin_townId" after the words "with its".

.. tip:: 
  This pattern of naming the result and determining its base can be used in all of these M-1 A-B situations:

  A with its same-col (or same col-in-A as col-in-B) B data.

The SQL query examples change in two ways: we eliminate one more column in the reduce, since we are matching over 2 columns, and we add another equality check to the filter portion in the WHERE clause. The traditional and the inner join examples in the first and second tabs are the alternatives (we cannot use natural join syntax any more).

.. tabbed:: DifferentBase3_MJ_M_1_2

    .. tab:: SQL Times-Filter-Reduce MJ query

      .. activecode:: ach_skill_MJ_D_M
        :language: sql
        :include: all_creature_create
        :showlastsql:

        -- same test town as origin town Achievement with its Skill data
                    -- reduce by removing B.skillCode, B.origin_townId
        SELECT A.*, B.skillDescription,
                    B.maxProficiency, B.minProficiency
        FROM achievement A, skill B       -- times
        WHERE A.skillCode = B.skillCode   -- equality match filters
        AND   A.test_townId = B.origin_townId
        ;
  
    .. tab:: SQL Inner Join MJ query

      .. activecode:: ach_skill_MJ_D_M_inner
        :language: sql
        :include: all_creature_create
        :showlastsql:

        -- same test town as origin town Achievement with its Skill data
                    -- reduce by removing B.skillCode, B.origin_townId
        SELECT A.*, B.skillDescription,
                    B.maxProficiency, B.minProficiency
        FROM achievement A
        INNER JOIN skill B       -- like MJ operator symbol
        ON A.skillCode = B.skillCode   -- equality match filters
        AND   A.test_townId = B.origin_townId
        ;


    .. tab:: Achievement, skill data values

        .. csv-table:: **Achievement**
           :file: ../creatureData/achievement.csv
           :widths: 10, 10, 10, 20, 30, 20
           :header-rows: 1

        .. csv-table:: **Skill**
          :file: ../creatureData/skill.csv
          :widths: 10, 30, 20, 20, 20
          :header-rows: 1



Considering NULL values
~~~~~~~~~~~~~~~~~~~~~~~

Let's look at the Skill data again:

.. csv-table:: **Skill**
  :file: ../creatureData/skill.csv
  :widths: 10, 30, 20, 20, 20
  :header-rows: 1


Notice that in one row, the origin_townId in Skill is a pesky NULL value. In databases, NULL cannot be matched to anything. It is important to understand that the Skill whose SkillCode is D3, Australasia debating, will never be able to appear in the result relation for this query.  There are not any NULL test_townId values in Achievement in this data, but if there were, those rows would not appear in the result relation either.

|

Exercise
~~~~~~~~~~~~~~~~~~~~~~~

Try creating the precedence chart for this query.

**English Query:**

  Find each Achievement with its same creatureId, same test_townId as reside_townId Creature data.
