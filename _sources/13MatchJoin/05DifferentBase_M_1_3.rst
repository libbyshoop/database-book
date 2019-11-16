Different Base A and B, M - 1 match over cols Aid(S),Bid(E)
------------------------------------------------------------

English Query:

    Find each Aspiration with its Creature data.

LDS fragment pertaining to this query:

|

.. image:: ../img/MatchJoin/05/Asp_Cr_LDS.png
    :width: 420px
    :align: center
    :alt: Creature database Creature - Aspiration - Skill intersection shape

|

Columns of the three relations in the fragment:

|

.. image:: ../img/MatchJoin/05/Asp_Cr_cols.png

|

Precedence Chart:

|

.. image:: ../img/MatchJoin/05/Asp_Cr_MJ_S_E.png

|

Other Queries to try:
~~~~~~~~~~~~~~~~~~~~~

    Find each Aspiration with its Skill Data.

    Find each Aspiration where the creature resides in the same town that they desired/aspired to obtain the Skill.

Look at the orange-highlighted columns above and devise another Match Join query using them.




.. image:: https://upload.wikimedia.org/wikipedia/commons/2/2d/Wikidata_logo_under_construction_sign_square.svg
    :width: 100px
    :align: left
    :alt: Under construction
