Different Base A and B, M - 1 match over cols Aid(D), Bid(E)
--------------------------------------------------------------

The first full example we present is one you have seen earlier. We will provide the complete details here, including a portion of the conceptual schema that is relevant (because this becomes a good way to decide the symmetry of the operation).

This case is also called *Natural Join* because it occurs frequently on shapes in the conceptual schema that look like this:

|

.. image:: ../img/MatchJoin/Ach_Skill_LDS_frag.png
    :width: 220px
    :align: center
    :alt: Creature database Achievement - Skill many to one shape

|

From the above shape, we are able to state that the symmetry case is *M - 1*, non-symmtric-A, because for each Achievement (A) there is one Skill (B), but one Skill can be used in many Achievements.

The English Query is:

    Find each Achievement with its Skill data.

Next, the precedence chart shows the relation with the many end in the schema fragment, Achievement, as the A relation, and the Skill at the one end as the B relation.

|

.. image:: ../img/MatchJoin/Ach_Skill_MJ.png
    :width: 400px
    :align: center
    :alt: Match Join example

|

It's time to look carefully at an SQL query for this example, along with alternate syntax (there is never just one way in our languages, it seems; but this is usually helpful once we have practiced and learned them).

The first tab below illustrates the traditional syntax that makes the times clear in the FROM clause, the filter clear in the WHERE clause, and the reduce clear in the SELECT clause.

In the second tab is an alternate syntax that looks a little bit more like the precedence chart, describing A INNER JOIN B ON A.skillCode = B.skillCode. You still need to explicitly list the columns to appear in the result in the SELECT CLAUSE.

.. warning:: In SQLite and many other DBMSs, when using syntax like these first 2 tabs, we must list all of the columns of the B relation except the one we are matching over explicitly. A.*, B.* in the SELECT clause results in a **table**, because 2 columns would have the same name in this case.

The third tab shows a syntax that works in only this special case of match join, M - 1, where we are matching over the column in relation A that has the same name and is the foreign key into relation B. The database software is able to infer the match on equality over the shared column name, so the match is omitted. Also, the system knows to eliminate one copy of that column and automatically performs the reduce. This syntax is handy, but only useable in this situation. It occurs so often in our databases, however, that it is nice to have this shortcut syntax.

.. tabbed:: Ach_Skill_MJ_1

    .. tab:: SQL Times-Filter-Reduce MJ query

      .. activecode:: ach_skill_MJ_D_E
        :language: sql
        :include: ach_skill_create_MJ_1

        -- Achievement with its Skill data
                    -- reduce by removing B.skillCode
        SELECT A.*, B.skillDescription,
                    B.maxProficiency, B.minProficiency,
                    B.origin_townId
        FROM achievement A, skill B       -- times
        WHERE A.skillCode = B.skillCode   -- equality match filter
        ;


    .. tab:: SQL Inner Join MJ query

      .. activecode:: ach_skill_InnerJ_D_E
        :language: sql
        :include: ach_skill_create_MJ_1

        -- Achievement with its Skill data
                    -- reduce by removing B.skillCode
        SELECT A.*, B.skillDescription,
                    B.maxProficiency, B.minProficiency,
                    B.origin_townId
        FROM achievement A
        INNER JOIN skill B            -- like MJ operator symbol
        ON A.skillCode = B.skillCode   -- match filter over cols
        ;

    .. tab:: SQL Natural Join MJ query

      .. activecode:: ach_skill_NaturalJ_D_E
        :language: sql
        :include: ach_skill_create_MJ_1

        -- Achievement with its Skill data
        SELECT *
        FROM achievement A
        NATURAL JOIN skill B
        -- this only works because each has skillCode col
        ;

    .. tab:: SQL data

      .. activecode:: ach_skill_create_MJ_1
        :language: sql

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
        -- !!!!!!!!!!
        -- !!!!!!!! CHNAGES HERE FROM CODIO
        -- Neff #3 swims in Bemidji
        INSERT INTO achievement (creatureId, skillCode, proficiency,
                                 achDate, test_townId)
                        VALUES (3, 'E', 5, datetime('now'), 'b');

        -- Kermit floats in Greenville
        INSERT INTO achievement (creatureId, skillCode, proficiency,
                                 achDate, test_townId)
                        VALUES (7, 'A', 5, datetime('now'), 'g');

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


Other Queries to try
~~~~~~~~~~~~~~~~~~~~~~~

Try creating the precedence charts for some of these queries. These are all different-base, M-1 (non-symmetric) circumstances. You should focus on two things:

- Which relation is the A, many end, and therefore points to the higher peak of the Match Join half-house symbol for non-symmetric case, and
- for each in put relation, the 'works on' columns that should be matched, choosing between E, M, S, O, or D for Aid(): and Bid(): inside the operator shape. 

.. tip:: If you haven't yet written down the table describing these 5 letters, E, M, S, O, and D shown in sections 13.1 and 13.2, you should do it now as you practice. I ask you to write it out because it will help you remember them and you should have it accessible as you work.

`This drawio operator template <https://drive.google.com/file/d/1AduoHhvr7ve4gVrcl-9nnoHR1Yne4WQH/view?usp=sharing>`_ also contains a tab for the Match Join operators that you can use as a guide as you try to draw them in diagrams.net. If you dowloaded this and used it already, you just have to go find the extra tab called Match Join with a new drawing showing the different circumstances.

One of these below is different than the others. Can you spot it and determine what else you will need to do?

**English Queries:**

    1. Find each achievement with its creature data.

    2. Find each achievement with its town data.

    3. Find each gargling aspiration with its skill data.

    4. Find each skill with its town data.

    5. Find each creature with its town data.

    6. Find each AspiredContribution with its role data.

    7. Find each aspiration with its town data.

    8. Find each contribution with its role data.

    9. Find each contribution with its skill data.
