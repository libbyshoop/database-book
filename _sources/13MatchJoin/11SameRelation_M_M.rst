Same Relation A and B, M - M match over cols Aid(D),Bid(D)
------------------------------------------------------------

Now let's look at matching over one of the columns in the creature relation that is not its identifier: reside_townId.

Here is the Creature information again:

|

.. image:: ../img/MatchJoin/10/Creature_LDS_cols.png
    :height: 200px
    :align: center
    :alt: Creature entity and its columns in the corresponding table

|

English Query

    Find each ordered pair of creatures that reside in the same town.


Precedence Chart

|

.. image:: ../img/MatchJoin/11/Same_town_creature_pair.png
    :height: 400px
    :align: center
    :alt: Creature entity and its columns in the corresponding table

|



In the example below, we must use the syntax that similar to the times from the set operator chapter, as given in the first tab. We add the WHERE clause to get the filter. We project by eliminating reside_townId from C2.

Note how this is an ordered creature pair.

.. tabbed:: reflexive_M_1_MJ

    .. tab:: SQL query

        .. activecode:: creature_town_MJ
           :language: sql
           :include: creature_create_MJ_town

           SELECT C1.creatureId AS C1_creatureId,
                  C1.creatureName AS C1_creatureName,
                  C1.creatureType AS C1_creatureType,
                  C1.reside_townId AS C1_reside_townId,
                  C1.idol_creatureId AS C1_idol_creatureId,
                  C2.creatureId AS C2_creatureId,
                  C2.creatureName AS C2_creatureName,
                  C2.creatureType AS C2_creatureType,
                  C2.idol_creatureId AS C2_idol_creatureId
           FROM creature C1, creature C2
           WHERE C1.reside_townId = C2.reside_townId;

    .. tab:: SQL data

        .. activecode:: creature_create_MJ_town
           :language: sql

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


.. image:: https://upload.wikimedia.org/wikipedia/commons/2/2d/Wikidata_logo_under_construction_sign_square.svg
    :width: 100px
    :align: left
    :alt: Under construction


Other Queries to try:
~~~~~~~~~~~~~~~~~~~~~~~

Try creating the precedence charts for these queries.

**English Query:**

    Find each ordered pair of skills that resides in the same town.
    
    Find each ordered pair of achievements that tested in the same town.
