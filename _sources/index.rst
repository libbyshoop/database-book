==========================================================
Mastering Relational Databases: from Models to Querying
==========================================================

Libby Shoop

2019

What this book is for
:::::::::::::::::::::

This book has the following intended purposes:

1. To accompany additional detailed reading material by making it possible for you to actively bring to life and practice the concepts that you read about.

2. To guide you through the process of creating data based on existing data models using SQL. The syntax you will see is that of of SQLite, which is run inside your browser in the pages of this active book.

3. To guide you through formation of queries by visually mapping them out using diagrams before translating them to SQL for execution.

What this book is not
:::::::::::::::::::::

This book is not a substitute for a good book about conceptual data modeling. The readings here assume that you have begun to master the concepts of modeling data to be stored in a relational database. We will use illustrations using Logical Data Structure (LDS) notation, as presented in:

  *Mastering Data Modeling, A User-Driven Approach*, by John Carlis and Joseph Maguire. Addison-Wesley Professional, 2000. ISBN 9780134176536

This book is not a full reference to the SQL standard or its implementation in SQLite. You should practice looking up additional details about the syntax presented here. If you are using another database system for your work, you will want to have useful references on hand for it. What you see here will be examples to get you started.

This book is not a substitute for attempting more data creation and analysis of larger sets of data, using different database management systems. I strongly suggest that you practice the techniques you see here by attempting increasingly more sophisticated queries on larger databases using MySQL, Postgres, Oracle, or SQLite installed on a server, virtual machine, desktop, or laptop. This book presents the basics, and you should practice further with your own data.

Part 1: From conceptual models to SQL data creation
---------------------------------------------------

The first several chapters linked below will guide you through the basic mechanisms typically used to implement tables in relational databases and to generate data instances and store them in tables. Basic querying is include just to verify the data has been created. This material is not exhaustive, but rather illustrative of basic features of SQL. As you practice, you will want to consult other more detailed references for the database system you are using in practice.

Part 2: Mastering Database Querying with Relational Algebra and SQL
--------------------------------------------------------------------

Beginning with the 'Databases and Querying' chapter, we will go through how to design queries using a graphical notation based on relational database theory that helps you think clearly about what data results you can expect from operations on data relations (a special form of data tables). With a design in hand, you will then be able to create correct queries using SQL-- we guide you through that process with simple examples.

Table of Contents
:::::::::::::::::

.. toctree::
  :numbered:
  :maxdepth: 1

  01ModelingIntro/toctree.rst
  02OneEntityShapes/toctree.rst
  03TwoEntityShapes/toctree.rst
  04ThreeEntityShapes/toctree.rst
  05IntroQuerying/toctree.rst
  06Relations/toctree.rst
  07OperatorFramework/toctree.rst
  08TinyDB/toctree.rst
  09UnaryOps/toctree.rst
  10QueriesAfterUnary/toctree.rst
  11SetOps/toctree.rst
  12QueryAfterSet/toctree.rst
  13MatchJoin/toctree.rst
  14OuterJoin/toctree.rst
  15Divide/toctree.rst
  16CompareJoin/toctree.rst
  17CategoryRelations/toctree.rst

Recognition and Thanks
::::::::::::::::::::::

A great deal of the material in part 2 was originally written by John Carlis for an audience that included a wide range of people, from undergraduate and graduate students to experienced computing professionals. His unpublished manuscript was entitled "*Mastering Database Querying and Analysis*". Its primary focus was relational algebra precedence charts. In 2015, three years before his death, he had given me permission to edit a copy of his material to make it approachable for undergraduate students. This online book is the result of my attempt at that task, most of which I am completing after his death. I have also changed the presentation to interleave data models and SQL in part 1 and relational algebra concepts and SQL querying in part 2. This work is therefore a derivative of Professor Carlis' original work.

Original unpublished work: Copyright |copy| 1999 - 2015, John V. Carlis.

This work: Copyright |copy| 2019, Elizabeth G. Shoop |---| all rights reserved.

.. |copy| unicode:: 0xA9 .. copyright sign
.. |---| unicode:: U+02014 .. em dash
   :trim:


I wish to extend thanks to Brad Miller and the `Runestone Interactive <http://runestoneinteractive.org/>`_ team, whose software platform enabled me to create this interactive book. John Carlis always believed in learning by practicing and being active; this technology enables you to do that, and I believe he would be happy with what we are trying to do here.

Warning: A work in Progress
:::::::::::::::::::::::::::

.. image:: https://upload.wikimedia.org/wikipedia/commons/2/2d/Wikidata_logo_under_construction_sign_square.svg
    :width: 100px
    :align: left
    :alt: Under construction

The material you will read here is still under constant revision. You may find sections with little detail that are still in progress (look for the construction sign above and to the left), and you may be surprised by new additions showing up at any time. There may still be errors in some of the examples as I publish new versions. Please bear with me.

I am only using a small part of what Runestone interactive books can provide. Some links in the title bar don't yet work or don't seem to belong. Please bear with me as I work towards making this material more like the other fully interactive books found on `Runestone Academy <https://runestone.academy/runestone/default/user/login?_next=/runestone/default/index>`_.
