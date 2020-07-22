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
           :include: skill_combo_create

           SELECT origin_townId,
                  count(skillCode) AS SkillCount
           FROM Skill
           WHERE origin_townId is not null
           GROUP BY origin_townId;

    .. tab:: SQL data

       .. activecode:: skill_combo_create
          :language: sql

          CREATE TABLE skill (
          skillCode          VARCHAR(3)      NOT NULL PRIMARY KEY,
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
          achId              INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
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

Exercises
~~~~~~~~~~

Try creating the precedence charts for queries in Exercises 1-9. Exercise 10 is like those in the previous section. In case you've lost track of the schema for the database, here it is again, followed by the English query exercises.

|

.. image:: ../08TinyDB/smallCreatureDB_LDS.png
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
          :include: combo_all_creature_create
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

  .. tab:: SQL data

    .. activecode:: combo_all_creature_create
      :language: sql

      -- ------------------   town -- -------------------------------

      DROP TABLE IF EXISTS town;

      CREATE TABLE town (
      townId          VARCHAR(3)      NOT NULL PRIMARY KEY,
      townName        VARCHAR(20),
      State           VARCHAR(20),
      Country         VARCHAR(20),
      townNickname    VARCHAR(80),
      townMotto       VARCHAR(80)
      );

      -- order matches table creation:
      -- id    name          state   country
      -- nickname   motto
      INSERT INTO town VALUES ('p', 'Philadelphia', 'PA', 'United States',
                                'Philly', 'Let brotherly love endure');
      INSERT INTO town VALUES ('a', 'Anoka', 'MN', 'United States',
                                'Halloween Capital of the world', NULL);
      INSERT INTO town VALUES ('be', 'Blue Earth', 'MN', 'United States',
                                'Beyond the Valley of the Jolly Green Giant',
                                'Earth so rich the city grows!');
      INSERT INTO town VALUES ('b', 'Bemidji', 'MN', 'United States',
                                'B-town', 'The first city on the Mississippi');
      INSERT INTO town VALUES ('d', 'Duluth', 'MN', 'United States',
                              'Zenith City', NULL);
      INSERT INTO town VALUES ('g', 'Greenville', 'MS', 'United States',
                                'The Heart & Soul of the Delta',
                                'The Best Food, Shopping, & Entertainment In The South');
      INSERT INTO town VALUES ('t', 'Tokyo', 'Kanto', 'Japan', NULL, NULL);
      INSERT INTO town VALUES ('as', 'Asgard', NULL, NULL,
                                'Home of Odin''s vault',
                                'Where magic and science are one in the same');
      INSERT INTO town VALUES ('mv', 'Metroville', NULL, NULL,
                              'Home of the Incredibles',
                              'Still Standing');
      INSERT INTO town VALUES ('le', 'London', 'England', 'United Kingdom',
                              'The Smoke',
                              'Domine dirige nos');
      INSERT INTO town VALUES ('sw', 'Seattle', 'Washington', 'United States',
                              'The Emerald City',
                              'The City of Goodwill');

      -- ------------------   creature -- -------------------------------
      DROP TABLE IF EXISTS creature;


      CREATE TABLE creature (
      creatureId          INTEGER      NOT NULL PRIMARY KEY,
      creatureName        VARCHAR(20),
      creatureType        VARCHAR(20),
      reside_townId VARCHAR(3) REFERENCES town(townId),     -- foreign key
      idol_creatureId     INTEGER,
      FOREIGN KEY(idol_creatureId) REFERENCES creature(creatureId)
      );

      INSERT INTO creature VALUES (1,'Bannon','person','p',10);
      INSERT INTO creature VALUES (2,'Myers','person','a',9);
      INSERT INTO creature VALUES (3,'Neff','person','be',NULL);
      INSERT INTO creature VALUES (4,'Neff','person','b',3);
      INSERT INTO creature VALUES (5,'Mieska','person','d', 10);
      INSERT INTO creature VALUES (6,'Carlis','person','p',9);
      INSERT INTO creature VALUES (7,'Kermit','frog','g',8);
      INSERT INTO creature VALUES (8,'Godzilla','monster','t',6);
      INSERT INTO creature VALUES (9,'Thor','superhero','as',NULL);
      INSERT INTO creature VALUES (10,'Elastigirl','superhero','mv',13);
      INSERT INTO creature VALUES (11,'David Beckham','person','le',9);
      INSERT INTO creature VALUES (12,'Harry Kane','person','le',11);
      INSERT INTO creature VALUES (13,'Megan Rapinoe','person','sw',10);

      -- ------------------   skill -- -------------------------------
      DROP TABLE IF EXISTS skill;

      CREATE TABLE skill (
      skillCode          VARCHAR(3)      NOT NULL PRIMARY KEY,
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
      -- Note that no skill originates in Philly or Metroville or Asgaard

      -- ------------------  teamSkill  -- -------------------------------
      DROP TABLE IF EXISTS teamSkill;

      CREATE TABLE teamSkill (
      skillCode      VARCHAR(3)  NOT NULL PRIMARY KEY references skill (skillCode),
      teamSize       INTEGER
      );

      INSERT INTO teamSkill VALUES ('B2', 2);
      INSERT INTO teamSkill VALUES ('TR4', 4);
      INSERT INTO teamSkill VALUES ('C2', 2);
      INSERT INTO teamSkill VALUES ('THR', 2);
      INSERT INTO teamSkill VALUES ('D3', 3);

      -- ------------------  achievement  -- -------------------------------
      DROP TABLE IF EXISTS achievement;

      CREATE TABLE achievement (
      achId              INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
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
      -- Godzilla achieves PK in Tokyo poorly with no date
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

      -- no 2-person canoeing achievements, but some have aspirations

      -- ------------------  aspiration  -- -------------------------------
      DROP TABLE IF EXISTS aspiration;

      CREATE TABLE aspiration
      ( -- foreign key
        creatureId    INTEGER     NOT NULL   REFERENCES creature(creatureId),
        -- foreign key
        skillCode     VARCHAR(3)  NOT NULL   REFERENCES skill(skillCode),
        aspiredProficiency INTEGER,
        desired_townId     VARCHAR(3) REFERENCES town(townId),     -- foreign key
        PRIMARY KEY (creatureId, skillCode)
      );


      -- Bannon aspires float in Anoka with proficiency of 3
      INSERT INTO aspiration VALUES (1,'A',3,'a');
      -- Bannon aspires swim in Bemidji with proficiency of 4
      INSERT INTO aspiration VALUES (1,'E',4,'b');
      -- Bannon aspires gargling in Blue Earth with proficiency of 3
      INSERT INTO aspiration VALUES (1,'Z',3,'be');
      -- Myers aspires float with proficiency of 3
      INSERT INTO aspiration VALUES (2,'A',3,NULL);
      -- Neff #3 aspires float in Bemidji with proficiency of 8
      INSERT INTO aspiration VALUES (3,'A',8,'b');
      -- Neff #3 aspires gargling in Blue Earth with proficiency of 5
      INSERT INTO aspiration VALUES (3,'Z',5,'be');
      -- Neff #4 aspires swim in Greenville with proficiency of 3
      INSERT INTO aspiration VALUES (4,'E',3,'g');
      -- Mieska aspires gargling in Duluth with proficiency of
      INSERT INTO aspiration VALUES (5,'Z',10,'d');
      -- Carlis aspires gargling in London with proficiency of
      INSERT INTO aspiration VALUES (6,'Z',3,'le');
      -- Kermit aspires swim in Bemidji with proficiency of
      INSERT INTO aspiration VALUES (7,'E',3,'b');
      -- Godzilla aspires sink in Tokyo with proficiency of
      INSERT INTO aspiration VALUES (8,'O',4,'t');

      -- Beckham, Kane, and Rapinoe aspire to achieve PK at maxProficiency in London
      INSERT INTO aspiration VALUES (11,'PK',10,'le');
      INSERT INTO aspiration VALUES (12,'PK',10,'le');
      INSERT INTO aspiration VALUES (13,'PK',10,'le');
      -- Kermit aspires to achieve 2-person bobsledding at proficiency 20 in Duluth
      INSERT INTO aspiration VALUES (7,'B2',20,'d');
      -- Bannon and Mieska aspire to achieve 4x100 meter track relay at
      -- proficiency of 85 in Seattle, WA.
      INSERT INTO aspiration VALUES (1,'TR4',85,'sw');
      INSERT INTO aspiration VALUES (5,'TR4',85,'sw');

      -- Thor, Rapinoe, and Kermit form debate team in Seattle, WA and
      -- asppire to achieve at 80% of maxProficiency
      INSERT INTO aspiration VALUES (9,'D3',8,'sw');
      INSERT INTO aspiration VALUES (13,'D3',8,'sw');
      INSERT INTO aspiration VALUES (7,'D3',8,'sw');

      -- no 2-person canoeing achievements, but some have aspirations

      -- Carlis and Bannon aspire to achieve 2-person canoeing in Bemidji
      -- with proficiency of 9
      INSERT INTO aspiration VALUES (6,'C2',9,'b');
      INSERT INTO aspiration VALUES (1,'C2',9,'b');

      -- Thor, Elastigirl do not aspire to anything

      -- ------------------  role  -- -------------------------------
      DROP TABLE IF EXISTS role;
      CREATE TABLE role
      (
        roleName VARCHAR(20)   NOT NULL PRIMARY KEY
      );

      INSERT INTO role VALUES ('first leg');   -- 4x100 track
      INSERT INTO role VALUES ('second leg');  -- 4x100 track
      INSERT INTO role VALUES ('third leg');   -- 4x100 track
      INSERT INTO role VALUES ('anchor leg');  -- 4x100 track
      INSERT INTO role VALUES ('pilot');       -- 2-crew bobsled
      INSERT INTO role VALUES ('brakeman');    -- 2-crew bobsled
      INSERT INTO role VALUES ('right leg');   -- 3-legged race
      INSERT INTO role VALUES ('left leg');    -- 3-legged race
      INSERT INTO role VALUES ('stern paddler'); -- 2-person canoeing
      INSERT INTO role VALUES ('bow paddler');   -- 2-person canoeing
      INSERT INTO role VALUES ('first speaker'); -- Australasia debating
      INSERT INTO role VALUES ('second speaker');-- Australasia debating
      INSERT INTO role VALUES ('team captain');  -- Australasia debating


      -- ------------------  contribution  -- -------------------------------
      DROP TABLE IF EXISTS contribution;
      CREATE TABLE contribution (
          creatureId         INTEGER     NOT NULL REFERENCES creature(creatureId),
          achId              INTEGER     NOT NULL REFERENCES achievement(achId),
          skillCode          VARCHAR(3)  NOT NULL REFERENCES skill(skillCode),
          roleName           VARCHAR(20) REFERENCES role(roleName),
          PRIMARY KEY (creatureId, achId)
      );

      -- Thor (right leg) achieves three-legged race in Metroville (with Elastigirl (left leg))
      INSERT INTO contribution VALUES (9, 12, 'THR', 'right leg');
      INSERT INTO contribution VALUES (10, 13, 'THR', 'left leg');
      -- Kermit 'pilots' 2-crew bobsledding
      --       with Thor as brakeman
      INSERT INTO contribution VALUES (7, 14, 'B2', 'pilot');
      INSERT INTO contribution VALUES (9, 15, 'B2', 'brakeman');
      --
      -- keep track relay, have 4 people:
      --   Neff #4 (first leg), Mieska(second leg), Myers (third leg), Bannon (anchor leg)
      INSERT INTO contribution VALUES (4, 16, 'TR4', 'first leg');
      INSERT INTO contribution VALUES (5, 17, 'TR4', 'second leg');
      INSERT INTO contribution VALUES (2, 18, 'TR4', 'third leg');
      INSERT INTO contribution VALUES (1, 19, 'TR4', 'anchor leg');
      -- Thor (second speaker), Rapinoe (team captain), and Kermit (first speaker) form debate team
      INSERT INTO contribution VALUES (7, 22, 'D3', 'first speaker');
      INSERT INTO contribution VALUES (9, 20, 'D3', 'second speaker');
      INSERT INTO contribution VALUES (13, 21, 'D3', 'team captain');

      --
      -- no 2-person canoeing contributions, but some have aspirations


      -- ------------------  aspiredContribution  -- -------------------------------
      DROP TABLE IF EXISTS aspiredContribution;
      CREATE TABLE aspiredContribution (
          creatureId         INTEGER     NOT NULL REFERENCES creature(creatureId),
          skillCode          VARCHAR(3)  NOT NULL REFERENCES skill(skillCode),
          roleName           VARCHAR(20) REFERENCES role(roleName),
          PRIMARY KEY (creatureId, skillCode)
      );


      -- no 2-person canoeing contributions, but Carlis and Bannon have aspirations
      INSERT INTO aspiredContribution VALUES (6, 'C2', 'stern paddler');
      INSERT INTO aspiredContribution VALUES (1, 'C2', 'bow paddler');

      -- Bannon and Mieska aspire to contribute to achieve 4x100 meter track relay
      -- Bannon contributed in his aspired to role, Mieska had a different
      -- aspired to role than he ultimately contributed to
      INSERT INTO aspiredContribution VALUES (1, 'TR4', 'anchor leg');
      INSERT INTO aspiredContribution VALUES (5, 'TR4', 'third leg');

      -- Kermit aspires to contribute to piloting bobsled
      INSERT INTO aspiredContribution VALUES (7, 'B2', 'pilot');

      -- Thor, Rapinoe and Kermit aspire to contribute to debate
      INSERT INTO aspiredContribution VALUES (7, 'D3', 'first speaker');
      INSERT INTO aspiredContribution VALUES (9, 'D3', 'second speaker');
      INSERT INTO aspiredContribution VALUES (13, 'D3', 'team captain');

      -- Elastigirl, others not aspiring to contribute to anything


.. important:: 

  **Draw the precedence charts! It's for your own good.**

  Novices who have done some coding will be tempted to jump straight to the SQL and skip the precedence charts. The queries that you have seen so far are simple enough that this temptation might even work fairly well. However, as we progress through this book, starting with the chart will be the best way to ensure that you get the query correct. I will argue that even the first exercise here:

  "Find each non-null achDate of Achievements whose skillCode = 'PK'"

  requires you to realize that you will need to use a Reduce. Making the chart, even if it is simply chicken scratching on paper or electronic pad, enables you to then much more easily remember that you will need the distinct keyword as shown. 

  My next observation, coming from my experience of doing many, many of these queries, is that working through the chart helps you figure out the input relation. You cannot get the SQL right if you haven't started at the right place, and you will spin your wheels on senseless work. Take this query from above as an example:

  "Find each creatureId of Creature who has achieved in the Town whose test_townId is ‘t’."

  Without considering your data schema and the base relations of your database, your first reaction should be "do I start from Creature, Town, or Achievement?" As you practice and move towards mastery, you will more quickly know that you can begin at Achievement. Drawing the chart helps you get there.