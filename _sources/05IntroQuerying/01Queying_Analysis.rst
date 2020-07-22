What We Mean by Querying and Analysis
--------------------------------------

Within the complex DBMS realm this book focuses on “querying” and “analysis." When you query you: express precisely what you want in a narrative form; anchor your understanding with germane instances, which may bring to light narrative fuzziness; convert it to commands with precisely-named result relations; and have the DBMS come up with how to efficiently execute the commands on your database.

When you analyze, you query, study the results, and follow with more querying, repeating this cycle until you satisfy your purposes, which might evolve along the way. As you become a master you will come through experience to a richer understanding of analysis, but do not expect to be able to precisely define it. Such large notions generally do not have precise definitions. Fortunately, you can get a sense for analysis by thinking about several aspects of it.

1. You might analyze because you are:

   -  Responding to some external trigger, such as a surprise shortfall in the availability of a key raw material, you seek its cause.

   -  Performing a periodic task, such as generating a quarterly performance report, where you have already thought through most of what you need to know.

   -  Endeavoring, proactively, to improve things, such as studying inventory levels as a prelude to revising purchasing policies.

   -  Developing a thought, where you notice some anomaly or trend, and that leads you to delve into it.

2. People who analyze increase their knowledge, becoming more valuable. You can often acquire an in-depth, nuanced understanding of the database and of the organizational context of your analyses.

3. As part of analysis, people ask two kinds of queries. 

   a. They ask what I call “thin” queries, where “thin” connotes that they access or change little of the data. For example:

      -  How much does Carlis owe?

      Thin queries are helpful for small decisions, such as:

      -  No, do not loan money to Carlis (and you may or may not record that decision).

   |

   b. People also ask “fat” queries that involve more extensive analyses, such as:

      -  Compare the debt load of customers by their employment status and credit history.

      These type of analyses support larger decisions, such as:

      -  Creating a revised schedule of income thresholds for loan applicants.


The Role of SQL: the end product, not the initial tool
------------------------------------------------------

SQL, which is short for Structured Query Language and pronounced “S-Q-L" or “See-Quell." is the standard relational DBMS interface language. Every (R)DBMS vendor complies with the standard (or almost does so), and also has some non-standard features.

If you use a relational DBMS for querying then eventually you, or an application you are writing, must use SQL to specify your queries — SQL is the language that the DBMS accepts. However, there are several reasons for you to avoid SQL for *planning* your queries.

Both the syntax of SQL and the way querying is generally presented in textbooks, lead you to think that your task when querying is to *display one unnamed table*. I object to each of those four italicized words.

-  If you think that you will *display* your (single) result, as opposed to *saving* a result relation, then you will focus on that one outcome, and not look to amortize the cost of getting that result by reusing it in further analyses.

-  You should learn to think about producing multiple results, not just *one*. When you analyze data you do more than get *the* result relation for *the* query.

-  You should *name* each result – final or intermediate. If you do not name it, then you may not have gotten what the user wanted and then remain blissfully ignorant of that sad fact until the user complains. If you name a result then you are more likely to: a) know what you got, b) get what you wanted, and c) reuse what you got in further analyses, thereby gaining more benefit.

-  If you produce a *table*, as opposed to a relation, then, since a table can have duplicate rows, you will have a harder time saying what is in one row. If you produce a relation then you are aided in naming the result by reflecting on the relation’s identifier.

Many people have found querying with SQL terribly difficult. Even experts find SQL hard to create and read. Do not be surprised if an analyst struggles to understand their own SQL. It is impossible for users to understand any but the simplest SQL (those thin queries mentioned earlier). Many valuable queries, although they sound simple in an English narrative form, look complex when converted to SQL. Of course some simple sounding queries are hard to state in Relational Algebra too, but in SQL it is much worse.

Many analysts who only use SQL tend to write complex, convoluted queries. When you are planning a complex query in SQL, you are forced to think about it all at once. That mental juggling means that you indeed are working hard. Furthermore, such SQL scripts tend to be “one off” – you use it once and then fail to reuse it.

Practice Discipline and Planning Instead
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For all of the above reasons I think that SQL itself and SQL practice are flawed for planning. As a consequence, users reap much less benefit than they could from expensively acquired data. What should you do to overcome these flaws? My advice is to insulate yourself from bare SQL by mastering a collection of **Relational Algebra operators**, following a disciplined way of naming relations and of working with narratives.

What does “Relational Algebra” mean?
-------------------------------------

Here is a minimal definition of Relational Algebra:

      Relational Algebra is a set of operators, or functions. Each operator works on one or two relations and (almost always) yields a named result relation. Query commands are formed by a “composition of functions” where the output of one operator can be input into one or several succeeding operators. A Relational Algebra query gets compiled into SQL for execution.

Reread the last sentence, and note that Relational Algebra and SQL are not mutually exclusive. Just as you write software programs in higher level languages, ignoring lower level details, and compiling to machine level for execution, you should seek to *plan* in Relational Algebra, and *compile* to SQL for execution. (The DBMS compiles SQL into an even lower level.) This point is worth saying another way. Do not think of SQL and Relational Algebra as competitors. You can plan at a level above SQL. When needed, SQL is still there available for use.

As an illustration of higher level planning, here is a Relational Algebra precedence chart illustrating a single operator (filter, which you will study later) that works on one relation (Achievement):

|

.. image:: ../img/UnaryExamples/AchievementFilter.png
    :height: 200px
    :align: center
    :alt: Achievement filter operation chart

|

The result of applying the filter operation in this example is a new relation that we have named to express precisely what is in it. This graphical example is just part of what is usually a much larger plan, consisting of several operators working on both original relations in our database and intermediate relations such as the one named "Achievement of Creature with creatureId = 1".

Which operators comprise Relational Algebra? Well, there is no fixed collection established by some authoritative body, so you need to be open-minded. Some operators are given different names by different authors. For example, “Filter," the name I use for a certain operator, also can be called “Restrict” or “Select”. Different authors will choose somewhat different collections.

What Notation? Some authors, as I do, use words for the operators, while others use (mostly Greek) symbols in place of words. The greek symbols as a shortcut are hard to remember and detract from mastery, so we will avoid them.

What names? Well, every result relation needs a name – no anonymous relations allowed. Moreover, each needs a good name, one precisely connoting its content. Fortunately, and this a major distinguishing feature of this book, a good name for every result relation can be formed from knowing the operator and its inputs.

The Big Picture Summary
-----------------------

Now that you have been introduced to the database realm, you are ready to read, as briefly stated as I can make it, the big picture of the context and purpose of remainder of this book:

**Context**: for users, an analyst stores and manages lots of data using a relational DBMS in a truly relational way: declaring precisely-named relations, and no other kind of structure. The analyst gains value by examining the data, working with users to formulate precise query narratives, and transforming them into relational algebra charts with precisely named result relations.  After this, the analyst compiles those commands into SQL for execution and studies the results. This process is repeated until users are satisfied.


**Purpose**: to help you master querying and analyzing relational data.
