An often-used Combination
--------------------------

In this brief interlude we will see a pattern that occurs fairly often in many queries. It combines all of the unary operators and Times. Try to study it to be certain that you understand what is in each result (I have made a note to help in one case). Note what an interesting result we can obtain.

**The English query is:**

    How does each creature's achieved skill proficiency compare to other creatures who have achieved the best proficiency at that skill?

Note here that we will need to know what the maximum score achieved per skill was (implying group). The words "compare to" in the query require us to interpret them in some way. In this case, I chose to compute the difference between each creature's achievement proficiency at that skill and the maximum achieved for that skill by any creature (this implies a computed column, which we interesting will add to a reduce- check that out below). A value of zero means that creature achieved the maximum, and the higher the value, the farther from the maximum they were.

**The Precedence Chart**

Here is our longest precedence chart so far- it does get the job done and demonstrates the power of what you can do with relational algebra.

|

.. image:: ../img/SetExamples/TimesFilterReduce_interlude.png

|

In this chart, I chose to show achievement twice at the top. It could be included once- it wouldn't change the query. I chose this way of visualizing it because when we convert it into SQL, the top left portion and the top right portion before the times are best completed as separate queries where an intermediate relation is produced. The two intermediate relations then are used in the Times to create another intermediate relation.

.. tip:: Notice in the chart above that the result relation name after the Times gets long, and in is useful to put the A and B input relation names in parentheses. Then to the left of the entity I chose to shorten the name going forward in the chart. This is a practice that I use most of the time on bigger charts: show the detail inside the relation box just after the operation like Times, then shorten it going forward.

**The longer SQL query with intermediate relations:**

In the following SQL code tabs, the creation of the intermediate relations is in the second tab. **Study this code carefully and compare it to the chart above.** You could do this by downloading the SQL Intermediate code as a text file and viewing it your favorite editor.

.. tip:: The use of intermediate relations to complete a longer query like this makes the result possible to attain with fewer errors. It is sometimes possible to create single long complex SQL queries for some charts, but debugging them and reading them later is very hard. The use of intermediate relations that match points in the precedence chart like we have done here makes producing correct results the first time much easier.


.. tabbed:: after_set_query

  .. tab:: SQL show

      .. activecode:: Show_Skill_Prof_Difference
         :language: sql
         :include: achievement_create_filter, after_set_intermediate

         SELECT *
         FROM AchSkillByCreatureDifferenceFromMax;

  .. tab:: SQL Intermediate

     .. activecode:: after_set_intermediate
        :language: sql
        :include: achievement_create_project
        :enabledownload:

        -- top left side of chart
        DROP TABLE IF EXISTS AchievedSkillWithProficiency;
        CREATE TABLE AchievedSkillWithProficiency AS
        SELECT distinct creatureId, skillCode, proficiency
        FROM achievement;

        -- top right side of chart
        DROP TABLE IF EXISTS MaxProficiencyAchievedPerSkill;
        CREATE TABLE MaxProficiencyAchievedPerSkill AS
        SELECT skillCode, max(proficiency) AS maxProficiency
        FROM achievement
        GROUP BY skillCode;

        -- Times (duplicate skillCode renamed)
        DROP TABLE IF EXISTS AchievedSkill_MaxProficiency_Pair;
        CREATE TABLE AchievedSkill_MaxProficiency_Pair AS
        SELECT A.*, B.skillCode AS maxSkillCode, B.maxProficiency
        FROM AchievedSkillWithProficiency A,
             MaxProficiencyAchievedPerSkill B;

        -- Filter, reduce and compute proficiencyDifference
        DROP TABLE IF EXISTS AchSkillByCreatureDifferenceFromMax;
        CREATE TABLE AchSkillByCreatureDifferenceFromMax AS
        SELECT creatureId, skillCode,
                maxProficiency - proficiency AS proficiencyDifference
        FROM AchievedSkill_MaxProficiency_Pair
        WHERE skillCode = maxSkillCode;

  .. tab:: Achievement data values

        .. csv-table:: **Achievement**
            :file: ../creatureData/achievement.csv
            :widths: 10, 10, 10, 20, 30, 20
            :header-rows: 1



