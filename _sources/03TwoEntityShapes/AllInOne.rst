What we have seen so far
------------------------

Here is a complete version of all of the SQL data creation statements in one place so that you can download it as one file and so you can try more things if you would like.

.. activecode:: all_creature_1
   :language: sql

   DROP TABLE IF EXISTS town;

   CREATE TABLE town (
   townId          VARCHAR(3)      NOT NULL PRIMARY KEY,
   townName        VARCHAR(20),
   State           VARCHAR(20),
   Country         VARCHAR(20),
   townNickname    VARCHAR(80),
   townMotto       VARCHAR(80)
   );

   INSERT INTO town VALUES ('p', 'Philadelphia', 'PA', 'United States', 'Philly', 'Let brotherly love endure');
   INSERT INTO town VALUES ('a', 'Anoka', 'MN', 'United States', 'Halloween Capital of the world', NULL);
   INSERT INTO town VALUES ('be', 'Blue Earth', 'MN', 'United States', 'Beyond the Valley of the Jolly Grean Giant', 'Earth so rich the city grows!');
   INSERT INTO town VALUES ('b', 'Bemidji', 'MN', 'United States', 'B-town', 'The first city on the Mississippi');
   INSERT INTO town VALUES ('d', 'Duluth', 'MN', 'United States', 'Zenith City', NULL);
   INSERT INTO town VALUES ('g', 'Greenville', 'MS', 'United States', 'The Heart & Soul of the Delta', 'The Best Food, Shopping, & Entertainment In The South');
   INSERT INTO town VALUES ('t', 'Tokyo', 'Kanto', 'Japan', NULL, NULL);
   INSERT INTO town VALUES ('as', 'Asgard', NULL, NULL, 'Home of Odin''s vault', 'Where magic and science are one in the same');

   CREATE TABLE creature (
   creatureId          INTEGER      NOT NULL PRIMARY KEY,
   creatureName        VARCHAR(20),
   creatureType        VARCHAR(20),
   townId VARCHAR(3) REFERENCES town(townId)     -- foreign key
   );

   INSERT INTO creature VALUES (1,'Bannon','person','p');
   INSERT INTO creature VALUES (2,'Myers','person','a');
   INSERT INTO creature VALUES (3,'Neff','person','be');
   INSERT INTO creature VALUES (4,'Neff','person','b');
   INSERT INTO creature VALUES (5,'Mieska','person','d');
   INSERT INTO creature VALUES (6,'Carlis','person','p');
   INSERT INTO creature VALUES (7,'Kermit','frog','g');
   INSERT INTO creature VALUES (8,'Godzilla','monster','t');
   INSERT INTO creature VALUES (9,'Thor','superhero','as');
   INSERT INTO creature VALUES (10,'Iron Man','superhero','z');

And here are retrieval statements that you can try after you experiment.

.. activecode:: creature_retrieve_3
   :language: sql
   :include: all_creature_1

   SELECT * FROM creature;

.. activecode:: creature_retrieve_4
  :language: sql
  :include: all_creature_1

  SELECT * FROM town;

.. activecode:: creature_retrieve_5
  :language: sql
  :include: all_creature_1

  SELECT creatureName, townName
  FROM creature natural join town;
