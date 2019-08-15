One-entity shapes: begin to consider 'how'
------------------------------------------

Stuff here.


SQL !!
------

.. activecode:: my_first_sql
   :language: sql

   DROP TABLE IF EXISTS Person;

   CREATE TABLE Person (
    PersonID integer primary key,
    LastName varchar(255),
    FirstName varchar(255),
    Address varchar(255),
    City varchar(255)
   );
   INSERT INTO Person(PersonID, LastName, FirstName, Address, City)
   VALUES (111, 'Shoop', 'Libby', '1600 Grand Avenue', 'Saint Paul')

.. activecode:: my_2nd_sql
  :language: sql
  :include: my_first_sql

  select * from Person;
  
