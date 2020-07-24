A Variation: Compare Join
==========================

The Match Join binary operator chapter was the largest in this book because there are some many different circumstances when it can be used. Thus, it takes some practice to master its use. Hopefully you have been doing some practice with it outside of this book, using another RDBMS. When you are comfortable with exactly matching columns after doing a times, you can now start thinking about cases in which we might use non-exact matching instead.

What can we do after a Times?
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Recall that the basis of the Match Join operator was to first complete a Times, then follow it with an exact match filter, and a Reduce or Project. One of the Match Join cases that was slightly unsettling and not particularly satisfying is the circumstance of same relation. Here was the example we had from the Match Join chapter:

|

.. image:: ../img/MatchJoin/11/Same_town_creature_pair.png
    :align: center
    :alt: Creature database same-town ordered creature pair

|

The slightly unsatisfactory aspect of this example is that the result relation contains an ordered pair of creatures, and even contains the same creature paired with itself. This is a result of the underlying Times operation. To see this more clearly, let's use a slightly smaller example, by starting with non-person creature as the input relation, then complete a times. Run the following:

.. activecode:: cr1_cr2_times
   :language: sql
   :include: all_creature_create

   DROP TABLE IF EXISTS non_person_creature;
   CREATE TABLE non_person_creature AS
   SELECT * from creature
   WHERE creatureType != 'person';

   SELECT C1.creatureId C1_creatureId,
          C1.creatureName C1_creatureName,
          C1.reside_townId C1_reside_townId,
          C2.creatureId C2_creatureId,
          C2.creatureName C2_creatureName,
          C2.reside_townId C2_reside_townId
   FROM non_person_creature C1, non_person_creature C2
   ;

In this example, we left out the exact match of the reside_townId for now. Notice how the non-person creatures are each paired with themselves and the pairs of creatures without the same creatureId appear twice, with the creatureId values in both possible orders. What we truly may want is unordered pairs of creatures where the creatureId is not the same.

To see this in a different way, let's try to visualize each of the entries in the result of the above times operation, looking only at the creatureId values. There are four non-person creatures, and their creatureId values are 7, 8, 9, and 10 respectively. There are three groups of pairs of these creatureId values that result from the times, which are shown in the following matrix:

|

.. image:: ../img/CompareJoin/CompareVisual.png
    :align: center
    :alt: Visualize unordered non-person creature pair

|

Here is some SQL where we are projecting to get simply the pairs of creatureId values, as depicted above.

.. activecode:: cr1_cr2_times_2
   :language: sql
   :include: all_creature_create

   DROP TABLE IF EXISTS non_person_creature;
   CREATE TABLE non_person_creature AS
   SELECT * from creature
   WHERE creatureType != 'person'
   ;

   SELECT C1.creatureId C1_creatureId,
          C2.creatureId C2_creatureId
   FROM non_person_creature C1, non_person_creature C2
   ;

When you run this, note all of the pairs an where they fall in the matrix visualization of them. Now here is that code again below. What where clause can you add to the second SELECT statement to get the yellow boxes only, which depict an **unordered pair** that does not include a non-person creature paired with itself?

.. activecode:: cr1_cr2_times_3
   :language: sql
   :include: all_creature_create

   DROP TABLE IF EXISTS non_person_creature;
   CREATE TABLE non_person_creature AS
   SELECT * from creature
   WHERE creatureType != 'person'
   ;

   SELECT C1.creatureId C1_creatureId,
          C2.creatureId C2_creatureId
   FROM non_person_creature C1, non_person_creature C2
   -- add WHERE clause here
   ;

If you get stuck, then:

.. reveal:: compare_1
   :showtitle: Show answer

   WHERE C1.creatureId < C2.creatureId

You can also try getting the lower half of the matrix (the green boxes) as an equally valid unordered pair.

Now let's return to the original Match Join example of each ordered pair of creatures (including person creatures) that live in the same town. Except now let's use what we have just visualized with the smaller set on non-person creatures to get the following:

    Find each unordered pair of creatures who reside in the same town.

Here is the SQL for this query:

.. activecode:: cr1_cr2_unordered
   :language: sql
   :include: all_creature_create

   SELECT C1.creatureId C1_creatureId,
          C1.creatureName C1_creatureName,
          C1.reside_townId C1_reside_townId,
          C2.creatureId C2_creatureId,
          C2.creatureName C2_creatureName,
          C2.reside_townId C2_reside_townId
   FROM creature C1, creature C2
   WHERE C1_reside_townId = C2_reside_townId
   AND C1_creatureId < C2_creatureId   -- this is the 'compare'
   ;

This particular result is so much more useful and satisfying when your goal is to try to find potential training partners or mentors for a mentee who live in the same town. This is the power of realizing what you can perform after a times operation.

Here is a long precedence chart for this, where there is an extra Project to eliminate the duplicated same reside_townId.

|

.. image:: ../img/CompareJoin/unordered_cr_pair_same_town.png
    :align: center
    :height: 800px
    :alt: chart for unordered person creature pair

|

Because we can have almost any clauses that we want in the filter and we may or may not have the last project/reduce, each of which does change the result, we typically draw out Compare Join in this way, rather than using an operator symbol to compact it. Note that in the following example, we would want to keep each reside_townId and eliminate the Project.


You can change the above SQL slightly (and chart a bit more to remove the Project) to also answer this question:

    Find each unordered pair of creatures that do not live in the same town.

Other Circumstances also Apply
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

We showed a same-relation example, but other circumstances also can be used in a similar way. Here are a couple of example result queries that are reasonably precise. Try to devise the chart for them.

1. Find each same-SkillCode, but not same test_townId as origin_townId, (achievement with its skill data)

2. Find each creature who aspires to contribute and contributed the same skillCode to a team where their contributed roleName is not the same as their aspired roleName.

The first query is a different base example, following from the straightforward Match Join, or natural join.

The second query is a same base example, because each is in essence a creature-skill pair, in this case referring to contributing to a team contribution as special case of achievement and aspiration to achieve a team contribution. Here is the current data for these two relations:

.. csv-table:: **Contribution**
   :file: ../creatureData/contribution.csv
   :widths: 20, 20, 30, 30
   :header-rows: 1

.. csv-table:: **AspiredContribution**
  :file: ../creatureData/aspiredContribution.csv
  :widths: 20, 40, 40
  :header-rows: 1

Here is some SQL code for the second query:

.. activecode:: asp_contrib_not_same_role
   :language: sql
   :include: all_creature_create

   -- Find each creature who aspires to contribute and
   -- contributed the same skillCode to a team where
   -- their contributed roleName is not the same as their aspired roleName.
   --
   SELECT C.*, A.skillCode aspContrib_skillCode, A.roleName aspContrib_roleName
   FROM contribution C, aspiredContribution A
   WHERE C.creatureId = A.creatureId
   AND   C.skillCode = A.skillCode
   AND C.roleName != A.roleName   -- this is the 'compare'
   ;

Note that you would not need to include the skillCode twice in this case, but I did it so that you could see that a contribution is for the same skill as aspired, but that the roleName is different.

Here is a place for you to try the first query above for practice.

.. activecode:: ach_skill_not_same_town
   :language: sql
   :include: all_creature_create

   -- Find each same-SkillCode, but not same test_townId as origin_townId,
   --  (achievement with its skill data)
   SELECT

   ;


Queries to try
~~~~~~~~~~~~~~

Try creating the precedence charts for these queries. Use a drawing tool such as draw.io.

**English Query:**

   1. Find each unordered pair of skills that originates in the same town.
   2. Find each unordered pair of achievements that were tested in the same town.
