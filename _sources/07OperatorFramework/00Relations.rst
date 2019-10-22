Relations as input and output
------------------------------

When using relational algebra and precedence charts to plan queries, we begin with one or two relations as *input*, chose an operator (with its own input parameters, much like a function), and indicate clearly what the *output* relation is. Here is an example:

|

.. image:: ../img/UnaryExamples/AchievementFilter.png
    :width: 300px
    :align: center
    :alt: Achievement and Filter operator example

|

Note the parts of this chart:

-  We have one input relation (Achievement), shown as a box;
-  one operator (Filter), shown as a box with rounded left and right edges, with the condition parameter for the filter shown inside it;
-  an output relation with a different name (because the operator worked on each row of the input relation to produce a different relation);
-  an indication alongside each relation what columns identify it.

You will soon find out just what the filter operator does. For now, note that this example illustrates a *crucial fact* for understanding the relational operators:

  .. important::
    *The result of each Relational Algebra operator is exactly one relation (or table).*

What the result relation is
~~~~~~~~~~~~~~~~~~~~~~~~~~~~

To become good at querying you must fully recognize what this crucial fact means and the consequences of it:

-  The result relation is usually a  *relation* and not some other structure. Sadly, there are exceptions to this, in which the result is a *table* instead. You will need to carefully learn when these exceptions arise.

-  The result relation is exactly *one* relation, not zero or more than one.

-  The result relation's name must be unique within the database – a consequence of *set* - and be properly named. (A little preaching: As you learn the various operators, you will get gently introduced to naming guidelines. If you do not become skilled at picking appropriate names, then you will never achieve mastery. It will take effort but is worthwhile.)


-  The result relation, except in rare cases, differs from its one or two input relations. It can have a different number of columns, different column names, a different identifier, a different number of rows, and different cell values.

-  The result relation, since it is a relation, must have an identifier, and, if you are disciplined, that identifier will be congruent with the result relation’s name.

This last point brings us to the next crucial fact that will help you learn how to ensure the correctness of your planned query:

  .. important::
    *To indicate what identifies each row instance, every result relation in a precedence chart should have an underlined base noun as part of its name.*

To illustrate this, let's repeat the precedence chart used above again:

|

.. image:: ../img/UnaryExamples/AchievementFilter.png
    :width: 300px
    :align: center
    :alt: Achievement and Filter operator example

|

As you may recall from earlier implementations of the Achievement relation, the columns that serve as the identifying primary key are creatureId and skillCode. The input relation in this chart is one that is created as part of our original data that matches the conceptual model. So its name and **base** noun are the same: Achievement. This is why it is underlined- we will get used to underlining the base (shortened from base noun) in each relation on a chart. You will later learn that the filter operation does not change the number and type of columns of an input relation, so the output relation maintains its base as Achievement (signified again by the underline).

To be certain that you get the base correct in each relation on a chart, it is good practice while you are learning to also write down the identifying columns near the relation box on the chart. As you improve and feel more confident about what is in your database, you may decide to forgo this practice. We will use examples that do it and encourage you to start by doing it as you learn which operators change the base and therefore the identifying columns.

  .. tip::
    When you start out, writing down the identifying columns first helps you decide what the base of a result relation should be.



Throughout this book you will see the phrase “result relation” rather than the shorter phrase “result.” My intent is not to lengthen the book (no, unlike old-time British lawyers, I am not paid by the word), but to help you to internalize this crucial concept, and to help you learn to think in terms of relations (note how it is not used in the next subsection).

What the result is not
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You need to learn what the result **never** is:

-  A constant, e.g., “3," which is Bannon’s gargling Score. Operations on Achievement to get this value result in a 1 row - 1 column relation containing that value.

-  A list, e.g., {1,3}, which are the distinct Scores achieved by Bannon. Operations on Achievement to get these values result in a 2 row - 1 column relation containing those values.

- The result never has a location that you know about. You never refer to a relation row by a memory address, or by place within a relation, e.g., “the third column” or “the ninth row."

- And so on — there are lots of other structures that are never the result, because it is always a relation (or in rare cases a table).
