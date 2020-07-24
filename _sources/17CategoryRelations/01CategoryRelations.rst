Category Relations
===================

In the chapter describing the Divide operator, we introduced the idea of creating a new relation, called the Pattern relation, that would assist us in performing a powerful analysis. In this chapter we will once again use this concept of creating new relations that can help us perform analyses. In this case, we are going to create relations that keep knowledge about the domain of the data in the database as new data of its own. This is a very powerful concept that you can use in many ways once you understand how it is done.

Making missing information new data
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In many cases with data in databases, we find ourselves wanting to ask queries like this:

    Find each creature who is a fair swimmer.

In this type of query, our client must explain to us just what constitutes fair in swimming. In addition, this query opens up many more very similar queries, asking about poor 2-man bobsledding, good swimming, poor swimming, good debating, excellent penalty kicking, etc. The general concept at work here is that a **range of values of proficiency** constitutes a category of performance.

What we will show is that we can create a new relation that will codify into data what is meant by poor swimming, fair swimming, good swimming, and other categories of the other skills in this database. Let's start by first examining the skill relation, which has some information in it about the range of values that proficiency can take on per skill. Noticing in this relation the maxProficiency and minProficiency data values:


.. csv-table:: **Skill**
   :file: ../creatureData/skill.csv
   :widths: 10, 30, 20, 20, 20
   :header-rows: 1


Given this information, and in consultation with a client, we might be able to decide that for the 'swim' skill, the various categories of swimming achievement might be something like this:

+-----------+----------------+-----------------------+-----------------------+
| SkillCode |  Category      | low proficiency value | high proficiency value|
+-----------+----------------+-----------------------+-----------------------+
|  E        | poor           | 0                     | 1                     |
+-----------+----------------+-----------------------+-----------------------+
|  E        | fair           | 2                     | 3                     |
+-----------+----------------+-----------------------+-----------------------+
|  E        | good           | 4                     | 5                     |
+-----------+----------------+-----------------------+-----------------------+

Because the full range of possible values of swim proficiency in the skill table is 0 to 5, we could develop the above categories, or levels of performance. This assumes that proficiency values are integers and can be interpreted as the following: if an achievement is performed at a proficiency equal to or greater than 0, and less than or equal to 1, the swim achievement is poor.

Different categories can be developed for each skill- we will see another example below.

We can take the above categories and **create a new table** containing this information as new data.

.. activecode:: swim_category
   :language: sql

   DROP TABLE IF EXISTS swim_category;

   CREATE TABLE swim_category (
   skillCode          VARCHAR(3)      NOT NULL,
   category           VARCHAR(20)     NOT NULL,
   lowProfVal         INTEGER         NOT NULL,
   highProfVal        INTEGER         NOT NULL
   );

   INSERT INTO swim_category VALUES ('E', 'poor', 0, 1);
   INSERT INTO swim_category VALUES ('E', 'fair', 2, 3);
   INSERT INTO swim_category VALUES ('E', 'good', 4, 5);



Once we have this new relation, now we can use Compare Join to match achievements of this particular skill and determine whether the proficiency falls into the range. In this query, we report all swim categories, but it turns out there is only one creature who has achieved swimming.

.. activecode:: swim_category_compare
   :language: sql
   :include: all_creature_create, swim_category

   SELECT distinct achievement.creatureId, swim_category.category
   FROM achievement, swim_category
   WHERE achievement.skillCode = swim_category.skillCode
   AND   achievement.proficiency >= swim_category.lowProfVal
   AND   achievement.proficiency <= swim_category.highProfVal
   ;


In this case, there was only one creature who swims, and the proficiency he happens to have achieved makes it fall into the fair category. A far more normal occurrence with large databases is that multiple creatures might fall into multiple categories. We can see a brief glimpse of this if we examine the gargling skill. Here is a very similar distribution of skill categories in another new table:

.. activecode:: gargling_category
  :language: sql
  :include: all_creature_create

  DROP TABLE IF EXISTS gargling_category;

  CREATE TABLE gargling_category (
  skillCode          VARCHAR(3)      NOT NULL,
  category           VARCHAR(20)     NOT NULL,
  lowProfVal         INTEGER         NOT NULL,
  highProfVal        INTEGER         NOT NULL
  );

  INSERT INTO gargling_category VALUES ('Z', 'poor', 0, 1);
  INSERT INTO gargling_category VALUES ('Z', 'fair', 2, 3);
  INSERT INTO gargling_category VALUES ('Z', 'good', 4, 5);

.. note:: It is important to see that these category tables are tables until we decide what columns might be sufficient to identify them. In this example and in most cases you might develop, the combination of skillCode and category serves to identify the gargling_category relation.

Now here is the Compare Join between achievement and this new gargling_category, along with a Reduce to two columns (which will identify the new result relation):

.. activecode:: gargling_category_compare
  :language: sql
  :include: all_creature_create, gargling_category

  SELECT distinct achievement.creatureId, gargling_category.category
  FROM achievement, gargling_category
  WHERE achievement.skillCode = gargling_category.skillCode
  AND   achievement.proficiency >= gargling_category.lowProfVal
  AND   achievement.proficiency <= gargling_category.highProfVal
  ;

What we have now is each gargling creature and the category their proficiency score falls into. Since creatures achieve the same skill more than once, it is likely helpful to add the date of the achievement along with its category, like this:

.. activecode:: gargling_category_compare_good_date
  :language: sql
  :include: all_creature_create, gargling_category

  SELECT distinct achievement.creatureId,
                  gargling_category.category, achievement.achDate
  FROM achievement, gargling_category
  WHERE achievement.skillCode = gargling_category.skillCode
  AND   achievement.proficiency >= gargling_category.lowProfVal
  AND   achievement.proficiency <= gargling_category.highProfVal
  ;

.. important:: The above query results in a relation where all three columns identify it. You might be tempted to think that we can simply carry the date as an additional column, but there actually are 2 good gargling achievements by the creature whose creatureId is 3 on exactly the same date in the underlying data. Below is a check of that. Thus we are reducing, making all three columns the identifier of the result relation.

Here is SQL for a **table** of the creatureId, skillCode, proficiency, and achDate of gargling achievements, so you can see the ones by creatureId 3.

.. activecode:: gargling_ach
  :language: sql
  :include: all_creature_create

  SELECT creatureId, skillCode, proficiency, achDate
  FROM   achievement
  WHERE  skillCode = 'Z';

We can go one step further with the category relation and ask specifically about the good gargling creatures.

.. activecode:: gargling_category_compare_good
  :language: sql
  :include: all_creature_create, gargling_category

  SELECT distinct achievement.creatureId,
                  gargling_category.category, achievement.achDate
  FROM achievement, gargling_category
  WHERE achievement.skillCode = gargling_category.skillCode
  AND   achievement.proficiency >= gargling_category.lowProfVal
  AND   achievement.proficiency <= gargling_category.highProfVal
  AND   gargling_category.category = 'good'
  ;

Notice how we can very easily change this to ask for the fair gargling creatures with their category and date achieved. Here is a precedence chart that shows how if we perform the last filter late, we can reuse the compare join to get either result.

|

.. image:: ../img/CompareJoin/GarglingCategoryCompare.png
    :align: center
    :height: 1200px
    :alt: Gargling Creature Category chart

|



Other Queries to try:
~~~~~~~~~~~~~~~~~~~~~~

Note for these that you can choose how much to report and you will be able to decide what a score range means for categories of the penalty kick skill. However, for completing the precedence chart similar to that in this chapter, you can assume that you have a relation called "penalty kick category", for example.

    1. Find each creatureId of Creature who aspires to achieve good swimming.

    2. Find each creatureId of Creature who is {poor, good} at penalty kick (skillCode = 'PK').

    3. Find each creature who achieves penalty kick (skillCode = 'PK') and what category they fall into.

In case it would help, here are Aspiration and Achievement again:

.. csv-table:: **Aspiration**
   :file: ../creatureData/aspiration.csv
   :widths: 25, 25, 25, 25

.. csv-table:: **Achievement**
    :file: ../creatureData/achievement.csv
    :widths: 10, 10, 10, 20, 30, 20
    :header-rows: 1

Here is a space where you can try to develop the SQL queries, with a start on the swimming categories from above.

.. activecode:: gargling_category_compare_good
  :language: sql
  :include: all_creature_create

  DROP TABLE IF EXISTS swim_category;

   CREATE TABLE swim_category (
   skillCode          VARCHAR(3)      NOT NULL,
   category           VARCHAR(20)     NOT NULL,
   lowProfVal         INTEGER         NOT NULL,
   highProfVal        INTEGER         NOT NULL
   );

   INSERT INTO swim_category VALUES ('E', 'poor', 0, 1);
   INSERT INTO swim_category VALUES ('E', 'fair', 2, 3);
   INSERT INTO swim_category VALUES ('E', 'good', 4, 5);

