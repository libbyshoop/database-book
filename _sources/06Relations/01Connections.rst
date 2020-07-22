Connections between Relations
-----------------------------

Two relations can be connected in various ways, but only by data values (symbolic pointers), not by addresses (direct pointers). Such connections have consequences for what questions you can ask and what operators you use to answer the questions.

For a relation users may assert zero, one, or many **foreign keys** that the DBMS enforces when the database is updated. For one foreign key users assert that a set of one or more columns in one “foreign” relation correspond, pairwise, to a set of one or more columns that form the identifier in another, “home” relation (paired columns must be from the same domain of values) – they come from the same domain. A foreign key value cannot be NULL and must refer to an existing home value. Thus, a foreign key is a guaranteed connection.

The set of columns referring to a home relation is called a “foreign key.” The home and foreign column names can be the same or different. In the example below, the foreign key called townId in creature has the same column name as the primary key of the "home" relation called town. However, we could have named this column 'reside_TownId' in creature and left it townId in town. (Indeed, notice that the later large example we will use in chapter 8 does just this.) A foreign key gets declared at the type, or column, level. At an instance level this requires that each particular foreign key in a row must refer to a single corresponding home row. This says that it is a “foreign key with referential integrity enforced” but, since that is a mouthful, you will see the plain “foreign key” instead.

You have encountered an example of foreign key declaration earlier when we showed how to map a two-entity shape and a 3-entity shape from a conceptual model to DBMS table creation statements. Here are the SQL statements that illustrate the two-relation connection, repeated from that earlier chapter:

.. code-block:: sql

    CREATE TABLE town (
    townId          VARCHAR(3)      NOT NULL PRIMARY KEY,
    townName        VARCHAR(20),
    State           VARCHAR(20),
    Country         VARCHAR(20),
    townNickname    VARCHAR(80),
    townMotto       VARCHAR(80)
    );

    CREATE TABLE creature (
    creatureId          INTEGER      NOT NULL PRIMARY KEY,
    creatureName        VARCHAR(20),
    creatureType        VARCHAR(20),
    townId VARCHAR(3) REFERENCES town(townId)     -- foreign key
    );

.. warning:: Some novices conflate identifier and foreign key, but they are separate notions. While both identifier and foreign key assertions imply non-NULL cell values in the appropriate columns, an assertion of non-NULL for a column does not imply that it must belong to either an identifier or foreign key.
