Test of Outer Join
==================


.. tabbed:: oj_test

    .. tab:: SQL query OJ

      .. activecode:: oj_left
         :language: sql
         :include: oj_test_create

         SELECT S.Name AS Street, U.*
         FROM Streets S
         LEFT OUTER JOIN Users U ON U.Streetid = S.Id;


    .. tab:: SQL query count

      .. activecode:: oj_count
         :language: sql
         :include: oj_test_create

         DROP TABLE IF EXISTS OuterJoinStreetUser;

         CREATE TABLE OuterJoinStreetUser AS
         SELECT S.Name AS Street, U.*
         FROM Streets S
         LEFT OUTER JOIN Users U ON U.Streetid = S.Id;

         SELECT  Street, Count(Username) AS COUNT
         FROM OuterJoinStreetUser
         GROUP BY Street;

    .. tab:: SQL create

      .. activecode:: oj_test_create
         :language: sql

         DROP TABLE IF EXISTS Streets;
         CREATE TABLE Streets
          (
            ID INT PRIMARY KEY,
            Name VARCHAR(100)
          );

          DROP TABLE IF EXISTS users;
          CREATE TABLE users
          (
            Username VARCHAR(100) PRIMARY KEY,
            StreetID INT
                REFERENCES Streets ( ID )
          );

          INSERT INTO Streets
          VALUES ( 1, '1st street' ),
            ( 2, '2nd street' ),
            ( 3, '3rd street' ),
            ( 4, '4th street' ),
            ( 5, '5th street' );
          INSERT INTO users
          VALUES ( 'Pol', 1 ),
            ( 'Doortje', 1 ),
            ( 'Marc', 2 ),
            ( 'Bieke', 2 ),
            ( 'Paulien', 2 ),
            ( 'Fernand', 2 ),
            ( 'Pascal', 2 ),
            ( 'Boma', 3 ),
            ( 'Goedele', 3 ),
            ( 'Xavier', 4 );
