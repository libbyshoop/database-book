Combination Queries to Consider After Unary Operators
------------------------------------------------------

In this chapter we will review some of the important points about the unary operators while presenting some more queries, including slightly more complex ones that combine the operators in common ways. In this section we present the English queries in categories. We suggest that you draw the charts yourself for them, using the category heading as a guide. In some cases we show either the chart or the SQL (or both) so that you can see how these operators can be used together.


Filter followed by Reduce
~~~~~~~~~~~~~~~~~~~~~~~~~~

**Queries:**

  Find each skillCode of Skill achieved by creature whose creatureId is 1.

  Find each skillCode of Skill achieved in town whose test_townId is 'le'.

As you begin to draw these, make sure that you understand which relation should be input at the top of the chart. Make sure your chart has an intermediate relation and 2 operators in it.

Check your understanding of where to start:

.. mchoice:: mc_unary_combo1
   :answer_a: Skill
   :answer_b: Creature
   :answer_c: Town
   :answer_d: Achievement
   :correct: d
   :feedback_a: When you first look at this, it is understandable that you would think to start with Skill. However, look more closely at not only the nouns in this query, but the active verb, which is achieved in this case.
   :feedback_b: A first glance might make you guess Creature, but try to look more closely at not only the nouns in this query, but the active verb, which is achieved in this case.
   :feedback_c: A first glance might make you guess Town, but try to look more closely at not only the nouns in this query, but the active verb, which is achieved in this case.
   :feedback_d: Good! You are starting to look at both verbs (achieved) and nouns to consider what the input relation might be.

   Which relation will be the input relation for these two above queries?


.. warning::
  The scope of filter is one row. Therefore the following is not possible to do using the operators we have seen so far. We will soon see how this can be done.


    Find each creatureId of Creature who achieved Float but not Swim.


For these next few queries, we will use the Skill relation as the input:

.. csv-table:: **Skill**
   :file: ../creatureData/skill.csv
   :widths: 10, 30, 20, 20, 20
   :header-rows: 1

|

**Query:**

    Find each skillDescription of Skill whose origin_townId is 'le'

Let's examine the SQL for this one, so that you can see that we can combine the non-identifying column list in the SELECT clause with the filter condition in the WHERE clause in the same SQL statement.

.. tabbed:: combo1

    .. tab:: SQL query

        .. activecode:: london_skill
           :language: sql
           :include: skill_create_group

           SELECT distinct skillDescription
           FROM Skill
           WHERE origin_townId = 'le'



Filter followed by Project
~~~~~~~~~~~~~~~~~~~~~~~~~~

**Query:**

  Find the skillCode of of any skill whose maxProficiency is greater than or equal to 10.


Filter before a Group
~~~~~~~~~~~~~~~~~~~~~

.. tip::
  You can avoid a bad group by doing a filter before group, as in the following example.

**Query:**

Find the count of Skills per each non-null origin_townId.

To realize why doing a filter to find Skills whose origin_townId is not null, recall what the Skill relation above looks like again by scrolling back up.


We would do a bad group if we simply grouped over origin_townId and counted skillCodes, because there is a NULL origin_townId, which needs to be the identifying column of the result relation.


.. tabbed:: combo2

    .. tab:: SQL query

        .. activecode:: skill_count_per_town
           :language: sql
           :include: skill_create_group

           SELECT origin_townId,
                  count(skillCode) AS SkillCount
           FROM Skill
           WHERE origin_townId is not null
           GROUP BY origin_townId;



.. tip:: Notice here how the SQL code can combine the Filter using a WHERE clause with the Group over a column using the GROUP BY clause. Also note the new phrase *is not null* as the means to filter out the non-null values.

Reduce first, then Group
~~~~~~~~~~~~~~~~~~~~~~~~~

**Queries:**

  How many Creatures achieve?

  How many Skills have been achieved?


Group followed by Group
~~~~~~~~~~~~~~~~~~~~~~~

**Queries:**

  Find the count of achieved skills by the creatures who have achieved the most skills.

  Find the count of achieved skills by the creatures who have achieved the least skills.

.. warning:: A count of 1 is the minimum number of possible achieved  skills. So even though the un-achieving Carlis creature number 6 has a count of zero skills, he will not appear in the result of the group that you do first over creatureId on achievement (see chart below).

Let's look at the chart for the first one so that you see how it works. The second follows easily from the first.

|

.. image:: ../img/UnaryExamples/GroupThenGroup.png

|

Corresponding SQL:

.. tabbed:: combo3

    .. tab:: SQL query

        .. activecode:: creature_count_most_skills
           :language: sql
           :include: achievement_create_filter

           DROP TABLE IF EXISTS creatureAchievedSkillCount;

           CREATE TABLE creatureAchievedSkillCount AS
           SELECT creatureId,
                  count(distinct skillCode) AS achievedSkillCount
           FROM achievement
           GROUP BY creatureId;

           SELECT max(achievedSkillCount)
           FROM creatureAchievedSkillCount;

    
    .. tab:: Achievement data values

        .. csv-table:: **Achievement**
            :file: ../creatureData/achievement.csv
            :widths: 10, 10, 10, 20, 30, 20
            :header-rows: 1



In the achievement relation data, there are 2 creatures that have achieved 3 skills, which is the maximum number that have been achieved. Run the above query and you will see that result.

.. tip:: Note in this case that we needed two SQL queries: first we must save the result from the first group in a new relation, then use it as input to the second SQL group query in the FROM clause. Note the use of *distinct* in the first of the 2 SQL queries- be sure you see why this is necessary.

Group then Filter
~~~~~~~~~~~~~~~~~

Earlier we filtered first to avoid a problem with NULL values. Here is an example of Filter after Group.

**Query:**

  Find the creatureId and skillCodeCount where the creature has achieved 2 or more skills.

.. tabbed:: combo4

    .. tab:: SQL query

        .. activecode:: creature_count_skills_ge_2
           :language: sql
           :include: achievement_create_filter

           DROP TABLE IF EXISTS creatureAchievedSkillCount;

           CREATE TABLE creatureAchievedSkillCount AS
           SELECT creatureId,
                  count(distinct skillCode) AS achievedSkillCount
           FROM achievement
           GROUP BY creatureId;

           SELECT *
           FROM creatureAchievedSkillCount
           WHERE achievedSkillCount >= 2;

Avoid non-useful work
~~~~~~~~~~~~~~~~~~~~~~

**Poor Queries:**

  Count the reside_townId per each creatureId.

  Count the non-null origin_townId per each skillCode of Skill.

.. tip:: **Group over identifier** doesn't do anything useful. If you do it, it is likely because you made a mistake. Consider these:


For two reasons you cannot Group over the input relation’s identifying columns. First, it is a misuse of Reduce. Remember, a Reduce to the same identifier as the input relation is bad because it really is a Project. Second, an aggregate function cannot yield anything of value. There is exactly one Creature with each creatureId. Of course! Aggregate functions aggregate values contained in rows (plural), but Grouping over the identifier means that functions must aggregate a (single) value contained in one row. That is, such a Group can never yield anything new – the 'aggregate' function doesn't mean anything. In the above cases the count is 1.

Exercises
~~~~~~~~~~

Try creating the precedence charts for queries in Exercises 1-9. Exercise 10 is like those in the previous section. In case you've lost track of the schema for the database, here it is again, followed by the English query exercises.

|

.. image:: ../img/smallCreatureDB_LDS.png
    :width: 600px
    :align: center
    :alt: Creature database conceptual schema

|

And to make things easier, you can use `this drawio operator template <https://drive.google.com/file/d/1AduoHhvr7ve4gVrcl-9nnoHR1Yne4WQH/view?usp=sharing>`_  on diagrams.net, if you have not done so yet.

Remember that for each relationship, the one end has a foreign key in the *opposite* entity's relation in the database. For example, Creature has columns called reside_townId and idol_creatureId, and Contribution has columns named creatureId, achId, skillCode, and roleName, all of which are foreign keys. Also note that identifier, and thus the primary key of Contribution is creatureId, achId.

While you work on these, notice the similar shapes in the precedence charts that you used to answer these queries. Another key to mastery is to look at the schema, envision the relations, and then be able to easily create the precedence chart from the query narrative like those given, because it is similar to one you have seen before (different relations and conditions, but same combination of operations).

Another step towards mastery is to know what the original input relation should be. Be thoughtful as you consider this for each of these.

.. note:: Depending on how you interpret the query, one or more of these queries requires a combination of three operators and two intermediate relations. Can you spot them?

**English Queries:**

  1. Find each non-null achDate of Achievements whose skillCode = 'PK'.
     (Note that the result relation base is achDate or AchievementDate, and has one column.)

  2. How many Creatures achieve skill(s) in the town whose test_townId = 'mv'?

  3. Find the skillDescription of of any skill whose minProficiency is 2.

  4. How many Towns have non-person Creatures residing in them?

  5. Find each creatureId of Creature who has achieved in the Town whose test_townId is ‘t’.

  6. How many Roles are there in which Creatures contributed?

  7. Find the count of Creatures who have Aspirations.

  8. Find the count the creatures who have achieved the least skills.

  9. Find the creatureId of each creature who aspires to achieve 2 or more skills.

  10. Consider this precedence chart:

  |

  .. image:: ../img/UnaryExercises/UnaryComb.png

  |


.. fillintheblank:: c-ex1
  :casei:

  Please fill in the blanks in the following sentence:

  The identifier of the intermediate result relation, Achievement whose skillCode = 'TR4', is  ``|blank|``.

  The base of the intermediate result relation, Achievement whose skillCode = 'TR4', is ``|blank|``.
  

  -   :creatureId, SkillCode: Correct.
      :SkillCode, creatureId: Correct.
      :creatureId and SkillCode: Correct.
      :SkillCode and creatureId: Correct.
      :x: Incorrect. Should be 'creatureId, SkillCode'.
  -   :Achievement: Correct.
      :x: Incorrect. Should be 'Achievement'.


.. shortanswer:: c-ex2

  If you are quite familiar with your data and recall that the skill whose skillCode is 'TR4' is described as '4x100 meter track relay', how would you use this to determine a name for result relation A?


The correct answer:
  .. reveal:: c-ex6

      We could accurately describe the result as this:
      
      CreatureId of creature achieving skill whose skillCode = 'TR4'

      But knowing what we know about the data, it would help our clients if we named it this:

      CreatureId of creature achieving the '4x100 meter track relay' skill.


.. fillintheblank:: c-ex5
   :casei:

   Please fill in the blanks in the following sentence:

   The identifier of the result relation is  ``|blank|``.
   The base of the result relation is ``|blank|``.

   -   :creatureId: Correct.
       :x: Incorrect. Should be 'creatureId'.
   -   :creature: Correct.
       :x: Incorrect. Should be 'creature'.


SQL Practice for Combination Queries
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Once you have the charts for the above exercises (and **NOT bEFORE**), you can try writing up the SQL for them. Keep the charts nearby as you work on the SQL. The first two are completed, and the English query is included for all of them as a comment using --. Notice below how you should comment out all but the query that you want to practice- I have done this by using an alternative commenting method: putting a /\* and a \*/ around any others. So have only one uncommented, and the result of that will appear when you choose 'Run'. If you don't do this, only the first query that is uncommented will run.

.. tabbed:: group_practice

  .. tab:: SQL query

      .. activecode:: combo_exercises
          :language: sql
          :include: all_creature_create
          :enabledownload: 

          -- 1. Find each non-null achDate of Achievements 
          --    whose skillCode = 'PK'.
          /*
          SELECT distinct achDate
          FROM achievement
          WHERE achDate is not NULL and skillCode = 'PK';
          */


          -- 2. How many Creatures achieve skill(s) 
          --    in the town whose test_townId = 'mv'?
          SELECT count(creatureId)
          FROM achievement
          WHERE test_townId = 'mv';

          -- 3. Find the skillDescription of of any skill 
          --    whose minProficiency is 2.

          -- 4. How many Towns have non-person Creatures 
          --    residing in them?

          -- 5. Find each creatureId of Creature who has 
          --    achieved in the Town whose test_townId is ‘t’.

          -- 6. How many Roles are there in which 
          --    Creatures contributed?

          -- 7. Find the count of Creatures 
          --    who have Aspirations.

          -- 8. Find the count the creatures who have 
          --    achieved the least skills.

          -- 9. Find the creatureId of each creature 
          --    who aspires to achieve 2 or more skills.

  


.. important:: 

  **Draw the precedence charts! It's for your own good.**

  Novices who have done some coding will be tempted to jump straight to the SQL and skip the precedence charts. The queries that you have seen so far are simple enough that this temptation might even work fairly well. However, as we progress through this book, starting with the chart will be the best way to ensure that you get the query correct. I will argue that even the first exercise here:

  "Find each non-null achDate of Achievements whose skillCode = 'PK'"

  requires you to realize that you will need to use a Reduce. Making the chart, even if it is simply chicken scratching on paper or electronic pad, enables you to then much more easily remember that you will need the distinct keyword as shown. 

  My next observation, coming from my experience of doing many, many of these queries, is that working through the chart helps you figure out the input relation. You cannot get the SQL right if you haven't started at the right place, and you will spin your wheels on senseless work. Take this query from above as an example:

  "Find each creatureId of Creature who has achieved in the Town whose test_townId is ‘t’."

  Without considering your data schema and the base relations of your database, your first reaction should be "do I start from Creature, Town, or Achievement?" As you practice and move towards mastery, you will more quickly know that you can begin at Achievement. Drawing the chart helps you get there.