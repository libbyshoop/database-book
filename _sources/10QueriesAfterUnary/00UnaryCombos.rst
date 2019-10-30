Combination Queries to Consider After Unary Operators
------------------------------------------------------

In this chapter we will review some of the important points about the unary operators while presenting some more queries, including slightly more complex ones that combine the operators in common ways. In this section we present the English queries in categories. We suggest that you draw the charts yourself for them, using the category heading as a guide. In some cases we show either the chart or the SQL (or both) so that you can see how these operators can be used together.


Filter followed by Reduce
~~~~~~~~~~~~~~~~~~~~~~~~~~



  Find each skillCode of Skill achieved by creature whose creatureId is 1.

  Find each skillCode of Skill achieved in town whose test_townId is 'le'.

As you begin to draw these, make sure that you understand which relation should be input at the top of the chart. Make sure your chart has an intermediate relation and 2 operators in it.


.. warning::
  The scope of filter is one row. Therefore the following is not possible to do using the operators we have seen so far. We will soon see how this can be done.


    Find each creatureId of Creature who achieved Float but not Swim.

For these next few queries, we will use the Skill relation as the input:

.. csv-table:: **Skill**
   :file: ../creatureData/skill.csv
   :widths: 10, 30, 20, 20, 20
   :header-rows: 1

|

    Find each skillDescription of Skill whose origin_townId is 'le'

Let's examine the SQL for this one, so that you can see that we can combine the non-identifying column list in the SELECT clause with the filter condition in the WHERE clause in the same SQL statement.

.. tabbed:: combo1

    .. tab:: SQL query

        .. activecode:: london_skill
           :language: sql
           :include: skill_combo_create

           SELECT distinct skillDescription
           FROM Skill
           WHERE origin_townId = 'le'



Filter followed by Project
~~~~~~~~~~~~~~~~~~~~~~~~~~

  Find the skillCode of of any skill whose maxProficiency is greater than or equal to 10.


Filter before a Group
~~~~~~~~~~~~~~~~~~~~~

.. tip::
  Avoid bad group by filter before group.

    Find the count of Skills per each non-null origin_townId.

To realize why doing a filter to find Skills whose origin_townId is not null, recall what the Skill relation above looks like again by scrolling back up.


We would do a bad group if we simply grouped over origin_townId and counted skillCodes, because there is a NULL origin_townId, which needs to be the identifying column of the result relation.


.. tabbed:: combo2

    .. tab:: SQL query

        .. activecode:: skill_count_per_town
           :language: sql
           :include: skill_filter_group_create

           SELECT origin_townId,
                  count(skillCode) AS SkillCount
           FROM Skill
           WHERE origin_townId is not null
           GROUP BY origin_townId;

    .. tab:: SQL data

       .. activecode:: skill_combo_create
          :language: sql

          CREATE TABLE skill (
          skillCode          VARCHAR(3)      NOT NUll PRIMARY KEY,
          skillDescription   VARCHAR(40),
          maxProficiency     INTEGER,     -- max score that can be achieved for this skill
          minProficiency     INTEGER,     -- min score that can be achieved for this skill
          origin_townId      VARCHAR(3)     REFERENCES town(townId)     -- foreign key
          );

          INSERT INTO skill VALUES ('A', 'float', 10, -1,'b');
          INSERT INTO skill VALUES ('E', 'swim', 5, 0,'b');
          INSERT INTO skill VALUES ('O', 'sink', 10, -1,'b');
          INSERT INTO skill VALUES ('U', 'walk on water', 5, 1,'d');
          INSERT INTO skill VALUES ('Z', 'gargle', 5, 1,'a');
          INSERT INTO skill VALUES ('B2', '2-crew bobsledding', 25, 0,'d');
          INSERT INTO skill VALUES ('TR4', '4x100 meter track relay', 100, 0,'be');
          INSERT INTO skill VALUES ('C2', '2-person canoeing', 12, 1,'t');
          INSERT INTO skill VALUES ('THR', 'three-legged race', 10, 0,'g');
          INSERT INTO skill VALUES ('D3', 'Australasia debating', 10, 1,NULL);
          INSERT INTO skill VALUES ('PK', 'soccer penalty kick', 10, 1, 'le');

.. tip:: Notice here how the SQL code can combine the Filter using a WHERE clause with the Group over a column using the GROUP BY clause. Also note the new phrase *is not null* as the means to filter out the non-null values.

Reduce first, then Group
~~~~~~~~~~~~~~~~~~~~~~~~~

  How many Creatures achieve?

  How many Skills have been achieved?


Group followed by Group
~~~~~~~~~~~~~~~~~~~~~~~

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
           :include: achievement_create_combo

           DROP TABLE IF EXISTS creatureAchievedSkillCount;

           CREATE TABLE creatureAchievedSkillCount AS
           SELECT creatureId,
                  count(distinct skillCode) AS achievedSkillCount
           FROM achievement
           GROUP BY creatureId;

           SELECT max(achievedSkillCount)
           FROM creatureAchievedSkillCount;

    .. tab:: SQL data

       .. activecode:: achievement_create_combo
          :language: sql

          DROP TABLE IF EXISTS achievement;
          CREATE TABLE achievement (
          achId              INTEGER NOT NUll PRIMARY KEY AUTOINCREMENT,
          creatureId         INTEGER,
          skillCode          VARCHAR(3),
          proficiency        INTEGER,
          achDate            TEXT,
          test_townId VARCHAR(3) REFERENCES town(townId),     -- foreign key
          FOREIGN KEY (creatureId) REFERENCES creature (creatureId),
          FOREIGN KEY (skillCode) REFERENCES skill (skillCode)
          );

          -- Bannon floats in Anoka (where he aspired)
          INSERT INTO achievement (creatureId, skillCode, proficiency,
                                   achDate, test_townId)
                          VALUES (1, 'A', 3, datetime('now'), 'a');

          -- Bannon swims in Duluth (he aspired in Bemidji)
          INSERT INTO achievement (creatureId, skillCode, proficiency,
                                   achDate, test_townId)
                          VALUES (1, 'E', 3, datetime('2017-09-15 15:35'), 'd');
          -- Bannon floats in Anoka (where he aspired)
          INSERT INTO achievement (creatureId, skillCode, proficiency,
                                   achDate, test_townId)
                          VALUES (1, 'A', 3, datetime('2018-07-14 14:00'), 'a');

          -- Bannon swims in Duluth (he aspired in Bemidji)
          INSERT INTO achievement (creatureId, skillCode, proficiency,
                                   achDate, test_townId)
                          VALUES (1, 'E', 3, datetime('now'), 'd');

          -- Bannon doesn't gargle
          -- Mieska gargles in Tokyo (had no aspiration to)
          INSERT INTO achievement (creatureId, skillCode, proficiency,
                                   achDate, test_townId)
                          VALUES (5, 'Z', 6, datetime('2016-04-12 15:42:30'), 't');

          -- Neff #3 gargles in Blue Earth (but not to his aspired proficiency)
          INSERT INTO achievement (creatureId, skillCode, proficiency,
                                   achDate, test_townId)
                          VALUES (3, 'Z', 4, datetime('2018-07-15'), 'be');
          -- Neff #3 gargles in Blue Earth (but not to his aspired proficiency)
          -- on same day at same proficiency, signifying need for arbitrary id
          INSERT INTO achievement (creatureId, skillCode, proficiency,
                                   achDate, test_townId)
                          VALUES (3, 'Z', 4, datetime('2018-07-15'), 'be');

          -- Beckham achieves PK in London
          INSERT INTO achievement (creatureId, skillCode, proficiency,
                                   achDate, test_townId)
                          VALUES (11, 'PK', 10, datetime('1998-08-15'), 'le');
          -- Kane achieves PK in London
          INSERT INTO achievement (creatureId, skillCode, proficiency,
                                   achDate, test_townId)
                          VALUES (12, 'PK', 10, datetime('2016-05-24'), 'le');
          -- Rapinoe achieves PK in London
          INSERT INTO achievement (creatureId, skillCode, proficiency,
                                   achDate, test_townId)
                          VALUES (13, 'PK', 10, datetime('2012-08-06'), 'le');
          -- Godizilla achieves PK in Tokyo poorly with no date
          -- had not aspiration to do so- did it on a dare ;)
          INSERT INTO achievement (creatureId, skillCode, proficiency,
                                   achDate, test_townId)
                          VALUES (8, 'PK', 1, NULL, 't');


          -- -------------------- -------------------- -------------------
          -- Thor achieves three-legged race in Metroville (with Elastigirl)
          INSERT INTO achievement (creatureId, skillCode, proficiency,
                                   achDate, test_townId)
                          VALUES (9, 'THR', 10, datetime('2018-08-12 14:30'), 'mv');
          -- Elastigirl achieves three-legged race in Metroville (with Thor)
          INSERT INTO achievement (creatureId, skillCode, proficiency,
                                   achDate, test_townId)
                          VALUES (10, 'THR', 10, datetime('2018-08-12 14:30'), 'mv');

          -- Kermit 'pilots' 2-person bobsledding  (pilot goes into contribution)
          --       with Thor as brakeman (brakeman goes into contribution) in Duluth,
          --    achieve at 76% of maxProficiency
          INSERT INTO achievement (creatureId, skillCode, proficiency,
                                   achDate, test_townId)
                          VALUES (7, 'B2', 19, datetime('2017-01-10 16:30'), 'd');
          INSERT INTO achievement (creatureId, skillCode, proficiency,
                                   achDate, test_townId)
                          VALUES (9, 'B2', 19, datetime('2017-01-10 16:30'), 'd');

          -- 4 people form track realy team in London:
          --   Neff #4, Mieska, Myers, Bannon
          --    achieve at 85% of maxProficiency
          INSERT INTO achievement (creatureId, skillCode, proficiency,
                                   achDate, test_townId)
                          VALUES (4, 'TR4', 85, datetime('2012-07-30'), 'le');
          INSERT INTO achievement (creatureId, skillCode, proficiency,
                                   achDate, test_townId)
                          VALUES (5, 'TR4', 85, datetime('2012-07-30'), 'le');
          INSERT INTO achievement (creatureId, skillCode, proficiency,
                                   achDate, test_townId)
                          VALUES (2, 'TR4', 85, datetime('2012-07-30'), 'le');
          INSERT INTO achievement (creatureId, skillCode, proficiency,
                                   achDate, test_townId)
                          VALUES (1, 'TR4', 85, datetime('2012-07-30'), 'le');

          -- Thor, Rapinoe, and Kermit form debate team in Seattle, WA and
          -- achieve at 80% of maxProficiency
          INSERT INTO achievement (creatureId, skillCode, proficiency,
                                   achDate, test_townId)
                          VALUES (9, 'D3', 8, datetime('now', 'localtime'), 'sw');
          INSERT INTO achievement (creatureId, skillCode, proficiency,
                                   achDate, test_townId)
                          VALUES (13, 'D3', 8, datetime('now', 'localtime'), 'sw');
          INSERT INTO achievement (creatureId, skillCode, proficiency,
                                   achDate, test_townId)
                          VALUES (7, 'D3', 8, datetime('now', 'localtime'), 'sw');

In the achievement relation data, there are 2 creatures that have achieved 3 skills, which is the maximum number that have been achieved. Run the above query and you will see that result.

.. tip:: Note in this case that we needed two SQL queries: first we must save the result from the first group in a new relation, then use it as input to the second SQL group query in the FROM clause. Note the use of *distinct* in the first of the 2 SQL queries- be sure you see why this is necessary.

Group then Filter
~~~~~~~~~~~~~~~~~

Earlier we filtered first to avoid a problem with NULL values. Here is an example of Filter after Group.

  Find the creatureId and skillCodeCount where the creature has achieved 2 or more skills.

.. tabbed:: combo4

    .. tab:: SQL query

        .. activecode:: creature_count_skills_ge_2
           :language: sql
           :include: achievement_create_combo

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

  Count the reside_townId per each creatureId.

  Count the non-null origin_townId per each skillCode of Skill.

.. tip:: **Group over identifier** doesn't do anything useful. If you do it, it is likely because you made a mistake. Consider these:


For two reasons you cannot Group over the input relation’s identifying columns. First, it is a misuse of Reduce. Remember, a Reduce to the same identifier as the input relation is bad because it really is a Project. Second, an aggregate function cannot yield anything of value. There is exactly one Creature with each creatureId. Of course! Aggregate functions aggregate values contained in rows (plural), but Grouping over the identifier means that functions must aggregate a (single) value contained in one row. That is, such a Group can never yield anything new – the 'aggregate' function doesn't mean anything. In the above cases the count is 1.
