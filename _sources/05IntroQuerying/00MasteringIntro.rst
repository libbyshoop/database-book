Mastering relational data analysis
-------------------------------------------------------

This part of this book is aimed at relative newcomers to relational databases, with the primary intention of enabling you to develop a mastery of querying relational databases to obtain the correct results you desire.

Why seek such mastery? Here is a simple answer: saving data has no value; only cost. Value comes when you analyze data to improve your understanding or to help you make decisions, and the more advanced your mastery, the more value you can add. As you will see, I claim that both the design and the practice of SQL is flawed for querying and analysis, and there is a better way for you to work that incorporates operators that use and produce only relations and, at least as importantly, using language in a precise, disciplined way in formulating query narratives and in naming relations.

What technical background do you need to begin seeking mastery? Happily the answer is “None” – this book begins at the beginning with data in relations and takes you through the operators. Your focus will not be so much on technology, but on precise communication among people and on problem solving skills. (Be careful if you have database system experience already. Some experienced professionals have been slower starters than novices, because they had some unlearning to do.)

When working with data stored in a relational database management system (DBMS), a human can perform different roles. Users work with analysts to determine what data to store and what analyses to do. Analysts devise plans for accomplishing the analyses, and convert plans to a form executable by the DBMS. **This is the primary focus of the rest of this book.** The aim is to make you comfortable with how to plan and obtain a result and be certain that it is correct.

Other roles that are also involved, yet not a part of this book include Database Administrators, DBA’s, who have responsibility for the whole database — for large, shared databases, no single user or analyst has that purview. DBA’s give orders to the DBMS about defining types of data (relations), user privileges, performance (e.g., choosing which indexes to build), backup and recovery, etc. Application programmers write code, “apps," that gives users specialized, limited views of their data and, happily, insulates them from the messy details of DBMS access, and, perhaps, performs computations on data extracted from the database via the DBMS.

Relations vs. Tables
--------------------

Unfortunately, many database realm terms are overloaded. The next few paragraphs just briefly define several. First and unfortunately, despite its name, a *relational* DBMS can use and produce structures other than relations. Much of this book is about a disciplined DBMS usage where you stick with just relations as input to and output from operators.

In the simplest terms, within a truly relational database a *relation* is a uniquely named structure consisting of cells of singleton data values organized into a rectangle, for example, Achievement. It consists of a set of unique rows and a set of uniquely named columns. Some or all of the columns are declared to be an identifier, that is, they serve to distinguish among the rows – no duplicate rows. The burden of enforcing these uniqueness restrictions is shifted onto the DBMS.


.. table:: **Achievement**
  :widths: 20 20 20

  ===========  =========  ===========
   creatureId  skillCode  proficiency
  ===========  =========  ===========
  1                    A            1
  3                    A            2
  3                    Z            1
  4                    A            2
  ===========  =========  ===========

By contrast, a *table* is a structure consisting of cells of values organized into a rectangle of rows and a set of uniquely named columns. However, a table: i) is named if it is stored, but may be only displayed and not named; and ii) has no identifying columns, and as a consequence, the DBMS will allow a table to have duplicate rows. In mathematical terms, a relation consists of a *set* of rows while a table consists of a *bag* (or multi-set) of rows. Note: a table with no duplicate rows is not a relation, since it is missing a set of identifying columns.


.. warning:: **Beware**! Some people mistakenly use relation and table as synonyms. This is fostered by the DBMS language (SQL) syntax where you always say “create table” -- sadly, no “create relation” command exists. To make a relation (in effect, but not in name) you create a table and then declare a set of columns to serve as the identifier (“primary key”). As you master the material in this book you will come to consider the distinction between relation and table to be of prime importance, and will not misuse the terms.



Beginning Analysis  with relational algebra diagrams
----------------------------------------------------

Analysts and users express query requirements as written narratives that are comprehensible by people, but not by a DBMS. A narrative query eventually must be transformed into a language the DBMS can understand. In this book you will learn to plan queries (to solve analysis problems) using a variant of Relational Algebra expressed in precedence charts. These are diagrams that define the operations you need to perform on relations.

You will also learn how to convert Relational Algebra precedence charts to SQL for execution. This is only done after you have a proper and correct chart, because SQL itself is a messy and error-prone mechanism for mastering analysis.

Some people use “query” in a restrictive sense and to them a query only extracts data and leaves the database unchanged. I use query in a broader sense, and expect that intermediate result relations can be saved by the DBMS, and used as input to later queries. So a human or software user, one given the proper permissions by the DBA, can dynamically change the database, adding both new data types (elements of the schema) and instances of those types. **The precedence charts we will create rely on and assume the use of intermediate relations.**

There will be an example of one of these diagrams in the next section.
