Complex Examples of Union, Intersect, and Minus
---------------------------------------------------

In the last section we used two simple single-column relations to visualize the set operations. Now let's see just a bit interest that can be added to queries, making them behave more 'relationally'.

Suppose now we look at  two different relations that we can derive as result relations in this database that have the same base. Let's recall the schema for this database and introduce a relation that we haven't used yet.

|

.. image:: ../08tinyDB/smallCreatureDB_LDS.png
    :width: 600px
    :align: center
    :alt: Creature database conceptual schema

|

Find the entity named Aspiration, which maps to a relation also named Aspiration. This data represents creatures who have aspired to achieve a skill in a particular town with a particular proficiency (they may or may not have achieved it with the same proficiency or in the same town). A point to note about the schema is what is the same and different about the Achievement and Aspiration entities and their corresponding relations. Note that they have four columns in common:

- creatureId,
- skillCode,
- proficiency or aspiredProficiency, and
- test_townId or desired_townId.

.. tip: The sameness about the chicken-feet-in shapes between Creature-Achievement-Skill and Creature-Aspiration-Skill is something that you should look for in conceptual schemas, because when they exist, you have a powerful opportunity to ask interesting questions. We will look at a few now.

Here is the Aspiration data:

.. csv-table:: **Aspiration**
   :file: ../creatureData/aspiration.csv
   :widths: 25, 25, 25, 25
   :header-rows: 1

To compare data in Aspiration and Achievement, we need relations with the same number of columns, with data in each column that can be compared. Let's use a Reduce on Achievement to get the same four columns with like types and similar data and nearly identical names. Here is a chart for that:


Now we can use this achieved skill data to compare to the aspired skill data in Aspiration, which has the same columns with like data that can be compared.

The SQL to create and keep the result relation from the above Reduce operation is in the second tab below. Run the first tab to see what the data looks like.

.. tabbed:: AdvancedSet1

    .. tab:: SQL show

        .. activecode:: Show_AchievedSkillInTownWithProficiency
           :language: sql
           :include: achievement_create_set2, AchievedSkillInTownWithProficiency

           SELECT * FROM AchievedSkillInTownWithProficiency;


    .. tab:: SQL create

        .. activecode:: AchievedSkillInTownWithProficiency
           :language: sql
           :include: achievement_create_set2

           DROP TABLE IF EXISTS AchievedSkillInTownWithProficiency;

           CREATE TABLE AchievedSkillInTownWithProficiency AS
           SELECT DISTINCT creatureId, skillCode, proficiency, test_townId
           FROM achievement;



    .. tab:: SQL data Achievement

        .. activecode:: achievement_create_set2
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

            -- Bannon floats in Anoka (where he aspired) [he did not improve]
            INSERT INTO achievement (creatureId, skillCode, proficiency,
                                     achDate, test_townId)
                            VALUES (1, 'A', 3, datetime('now'), 'a');
            -- Bannon floats in Anoka (where he aspired)
            INSERT INTO achievement (creatureId, skillCode, proficiency,
                                     achDate, test_townId)
                            VALUES (1, 'A', 3, datetime('2018-07-14 14:00'), 'a');

            -- Bannon swims in Duluth (he aspired in Bemidji) [he improved]
            INSERT INTO achievement (creatureId, skillCode, proficiency,
                                     achDate, test_townId)
                            VALUES (1, 'E', 4, datetime('now'), 'd');
            -- Bannon swims in Duluth (he aspired in Bemidji)
            INSERT INTO achievement (creatureId, skillCode, proficiency,
                                     achDate, test_townId)
                            VALUES (1, 'E', 3, datetime('2017-09-15 15:35'), 'd');


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

    .. tab:: SQL data Aspiration

       .. activecode:: aspiration_create_set2
          :language: sql

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

Now we have two relations that are *compatible* for use with the set operators Union, Intersect, and Minus, because they have the same four columns of data that can be compared:

1. The result relation from the Reduce on Achievement, with the rather long, yet descriptive name AchievedSkillInTownWithProficiency. When you run the query above, it produced 20 instances/rows in the result.

2. The Aspiration relation. This has 22 different instances/rows in it.

The first represents when a creature achieved a skill at a proficiency in a town. The second represents that a creature aspires to achieve that skill at a desired proficiency in a particular town.

Let's examine what we can do with this.

Queries using all columns
~~~~~~~~~~~~~~~~~~~~~~~~~

One of the most restrictive type of English queries that we can ask from these two relations is like this:

    Find each (creatureId, skillCode, proficiency, and townId) combination where a creature achieves a skill at a proficiency in a town **AND** that creature aspired to achieve that skill at that proficiency in that town.

The word AND in the above query is highlighted to indicate that this is an Intersection query.

When this Intersection is performed, each row is treated as one instance in each relation. Each row in AchievedSkillInTownWithProficiency is compared to each row in Aspiration, and all four values in each column must match for the row to be included in the result relation.

.. activecode:: All_column_intersection
   :language: sql
   :include: achievement_create_set2, aspiration_create_set2, AchievedSkillInTownWithProficiency

   SELECT creatureId, skillCode, proficiency, test_townId
   FROM AchievedSkillInTownWithProficiency
   INTERSECT
   SELECT creatureId, skillCode, aspiredProficiency, desired_townId
   FROM Aspiration;

Exercise
********

Experiment with changing the keyword INTERSECT to UNION and also to EXCEPT in the above SQL. What are the corresponding English queries for each of these and how does the name of the result relation change? Practice drawing the precedence charts for these queries with a drawing tool.

Queries with some, but not all columns
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

With the same original input relations, AchievedSkillInTownWithProficiency, and Aspiration, each of which are identified by creatureId and skillCode. This makes them effectively the same base, because they are both Creature-Skill Pairs. We can ask other queries by first using a Project on each relation and then using the set operators. For example, we can ask the following, regardless of town or proficiency score.

    Find each creatureId and skillCode of Creature who has achieved AND aspired to achieve that Skill.

Here is SQL for this query:

.. activecode:: 2_column_intersection
  :language: sql
  :include: achievement_create_set2, aspiration_create_set2, AchievedSkillInTownWithProficiency

  SELECT creatureId, skillCode
  FROM AchievedSkillInTownWithProficiency
  INTERSECT
  SELECT creatureId, skillCode
  FROM Aspiration;

Use the above code area to try these queries:

  Find each creatureId and skillCode of Creature who has achieved OR aspired to achieve that Skill

  Find each creatureId and skillCode of Creature who has achieved BUT NOT aspired to achieve that Skill

  Find each creatureId and skillCode of Creature who has aspired to achieve BUT NOT achieved that Skill

  Find each skillCode of skill that is neither achieved nor aspired to

  Find each skillCode of skill that is is not both achieved and aspired to

  Find each unachieved skill by frog creatures

  Find each creature who has achieved more than one skill

  Find each creature whose average skill level is greater than 1

  Find each creature whose minimum skill level achieved is >=2

  Find creatureId of each creature who has achieved floating and gargling

  Find creatureId of each creature who has achieved floating but not gargling
