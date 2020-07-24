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


**Logic to use in decision-making process for chart formulation:**

For the above stated English query, we will use Achievement and Skill as the two input relations.  These two relations clearly have different bases.

We can decide that the matching will be on skillCode of Skill and its foreign key in Achievement, also called skillCode. (The phrase 'with its' helps us decide this.) The relationship between the two input relations, Achievement to Skill over skillCode, is M-1. This is also apparent from the DB schema fragment. This means we will use the non-symmetric half-house shape for the Match Join operator, and Achievement (A relation) will point to the the peak of the half-house Match Join symbol, and Skill at the lower side of the top of the half-house symbol (the B relation). 

The skillCode column is disjoint from (D) Achievement's identifier, and the skillCode column is exactly (E) Skill's identifier. This is the 'works on' column that appears in the precedence chart below as Aid(D):skillCode and Bid(E):skillCode.

These decisions result in the following precedence chart:

|

.. image:: ../img/MatchJoin/Ach_Skill_MJ.png
    :width: 400px
    :align: center
    :alt: Match Join example

|

**Result relation name and base:** This M-1, non-symmetric Match Join case with A at the peak and B at the lower end of the symbol *always results in a result relation whose base is the same as input relation A*. So in this case the base of the result relation is Achievement and therefore its identifier is the same as Achievement's (achId). The phrase "with its Skill data" is a succinct and accurate way of completing the naming of the result relation in this case.

.. tip::
  Look for this naming convention and base determination for the M-1 non-symmetric cases that follow in the next 2 sections and in the English practice queries below in this section. This is the way to name these result relations and easily determine the base.

It's time to look carefully at an SQL query for this example, along with alternate syntax (there is never just one way in our languages, it seems; but this is usually helpful once we have practiced and learned them).

The first tab below illustrates the traditional syntax that makes the times clear in the FROM clause, the filter clear in the WHERE clause, and the reduce clear in the SELECT clause.

In the second tab is an alternate syntax that looks a little bit more like the precedence chart, describing A INNER JOIN B ON A.skillCode = B.skillCode. You still need to explicitly list the columns to appear in the result in the SELECT CLAUSE.

.. warning:: In SQLite and many other DBMSs, when using syntax like these first 2 tabs, we must list all of the columns of the B relation except the one we are matching over explicitly. A.*, B.* in the SELECT clause results in a **table**, because 2 columns would have the same name in this case.

The third tab shows a syntax that works in only this special case of match join, M - 1, where we are matching over the column in relation A that has the same name and is the foreign key into relation B. The database software is able to infer the match on equality over the shared column name, so the match is omitted. Also, the system knows to eliminate one copy of that column and automatically performs the reduce. This syntax is handy, but only useable in this situation. It occurs so often in our databases, however, that it is nice to have this shortcut syntax.

.. tabbed:: DifferentBase3_MJ_M_1_1

    .. tab:: SQL Times-Filter-Reduce MJ query

      .. activecode:: ach_skill_MJ_D_E
        :language: sql
        :include: all_creature_create

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
        :include: all_creature_create

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
        :include: all_creature_create

        -- Achievement with its Skill data
        SELECT *
        FROM achievement A
        NATURAL JOIN skill B
        -- this only works because each has skillCode col
        ;

    .. tab:: Achievement, skill data values

        .. csv-table:: **Achievement**
           :file: ../creatureData/achievement.csv
           :widths: 10, 10, 10, 20, 30, 20
           :header-rows: 1

        .. csv-table:: **Skill**
          :file: ../creatureData/skill.csv
          :widths: 10, 30, 20, 20, 20
          :header-rows: 1


.. tip:: 
  This M-1 match join over the foreign key column in input relation A to the identifier of input relation B is referred to in the database community as the **natural join**. This is why there is a special syntax for completing it in SQLite that uses those keywords. A master data analyst learns to *naturally use natural join* to complete many analyses.

  **Result relation naming:** Note the phrase "with its" in all of the queries below and the example on this page. This is what we use for this natural join situation, and for the other types of M-1 situations, which you will see in the next two examples.


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
