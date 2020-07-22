The Essence of Relational Databases
-----------------------------------

What is in a database? A broad answer to this question is that a database contains instances of types of data that users deem worth remembering. This Chapter is about the only structure a relational system uses to represent query and analyze data, namely, the *relation*.

**Reading advice.** Resist the urge to read the following too quickly. It contains crucial concepts that masters of querying and analysis must 'own', meaning it must be second nature and implicit in your thinking as you learn.

Data in Relations
~~~~~~~~~~~~~~~~~~~~~~

A **relational database** consists of a perhaps-empty *set* of relations, which is defined in the next section. A relational database management system (DBMS) consists of software that enables the creation, population, and querying of relations. There is of course much more to the workings of an RDMBS, but we won't delve into those details here.

.. note:: Here is a **crucial fact** with consequences to your mastery:
..

   **A relational system hinges on the notion of set.**

While “set” is used in dozens of ways, a common but deceptively simple definition is: a set is a perhaps-empty, *unordered* collection of *unique* elements. A set is often shown in two dimensions with its elements enclosed by a line, as in a Venn diagram, or in one dimension (text) as elements enclosed in curly braces ( "{" , "}" ). In general a set’s elements can be anything: heterogeneous, e.g., {a remote control, an apple, a jackhammer, pi}, or, more commonly in computing, homogeneous, e.g., {7, 34, 24}. In mathematics generally each set element is simple, often a number or letter, but, and this has significant consequences, in the database realm some sets have elements that are not simple, but are themselves sets - composites.

.. warning:: It is sometimes easy to be complacent when thinking about a set. Take special care to pay attention to the two italicized words above: *unordered* and *unique*. These play a critical role in relational databases.

.. Section RD4 takes a closer look at set properties and at associations between sets in the context of relations.

Relation Defined
~~~~~~~~~~~~~~~~

A **relation** is a particular structure of data values in cells, generally depicted as a rectangle. Let's consider this tiny relation as our first example:

.. csv-table:: **Recipe**
   :file: recipe_tiny.csv
   :widths: 20, 10, 25, 25
   :header-rows: 1

Briefly, a relation such as this has these features:

- *one* name (Recipe);
- a *set* (size 4) of columns, each with *one* name (recipe_id, rank, recipe_category, & recipe_name);
- a *set* (size 2) of distinct rows;
- *one* *set* (size 1) of identifying columns (recipe_id), each of which is denoted in some way, with italics, or perhaps underlined;
- and a *set* (4x2=8) of cells, each with *one* value or, if allowed, a NULL value.


Instead of relation you may see the terms table or file, but, as you may recall from the last chapter, both terms are incorrect.

Let's add some detail to this definition. A relation has:

-  **A non-empty set of named columns, each with a singular name, with an encoding data type, and coming from a named domain.**

   Here *set* dictates that: every relation has at least one column; no two columns within a relation have the same name; a column name can never be NULL, that is, there are no anonymous columns, and columns can appear in any left-to-right order. A column’s name should be meaningful, to a human, indicating what *one* cell of the column holds (which is why its name must be singular). A column name can, and commonly does, appear in more than one relation.

   When you declare a relation’s column to the DBMS you specify a **data type,** an encoding such as integer, character, etc, that the column’s values have.

   The set of values that you want to allow for a column might be smaller than those the encoding data type would allow. For example, a Ph between 0.0 and 14.0, and a one-character data type for a Course-Grade column might be constrained to only A through F. Each allowed value is said to come from a named **domain**, e.g., "acceptable course grade". That name is often the same as the column name. While you do **not** explicitly declare a domain to the DBMS, you can choose to have such constraints enforced by the DBMS, or by an application program, or (foolishly?) trust the users to behave. Two columns (in different relations) with the same name almost always come from the same domain, but could have different data types, or mean different things (and eventually cause confusion). Two columns with different names often come from the same domain, especially if parts of their names are indicative of their having the same domain.

   Each column has a **scale**, which can be nominal, ordinal, or numeric.

.. note:: Instead of column the terms attribute, field, or variable might be used.

-  **A perhaps-empty set of rows.**

   Each row is about one instance of the relation name, and is comprised of a *set* of values, one for each column of the relation. So, while the elements of a set can be heterogeneous, the rows in a relation are homogeneous in the sense that they are all about the same type of thing. Likewise the values in each cell of a row are homogeneous – about the same kind of thing and encoded (integer, character, etc.) the same way.

.. note:: Instead of row the terms instance, tuple, or record might be used.

-  **For each row, a set of row-column cells, each with one value.**

   The DBMS treats each cell value as *one* thing, a singleton (atomic) value. Each cell value in a column is a sensible value from the column’s domain, and encoded in its declared data type, or, if allowed, NULL. (NULL means “has no remembered value.")

   So, and of crucial importance: a relation is a *set of sets*, a set of composite rows, not a set of simple elements.

-  **A non-empty set of columns serving as an identifier.**

   An identifier for a relation is a non-empty set of one or more (perhaps all) of its columns. By declaring an identifier, you assert that no identifying cell value can be NULL, and the identifier is unique, that is, it distinguishes the relation's rows from each other – for current and future instances – there are no duplicate rows.

.. note:: Instead of identifier the terms key, primary key, or accession number might be used.

-  **Exactly one, unique, short, internal (DBMS) name.**

   The relational DBMS enforces the restriction that every (saved) relation is named and no two relations in the database (or in just your view of the database) have the same name – a *set* of names. A relation’s name can never be NULL, that is, there are no anonymous relations. A relation cannot have more than one name, although in querying you can (and sometimes must) use temporary aliases. This DBMS relation name is limited to a few dozen keystrokes (it varies for each system).

   While the DBMS just requires unique names, humans need something else:

-  **Exactly one, unique meaningful-to-humans, singular noun (phrase) name.**

   While the DBMS just requires unique names, humans need meaningful names. Later we will work on choosing a meaningful name for a relation. This topic pervades the book and is the most significant and taxing skill to master.

.. warning:: Beware! Some students fail to appreciate the importance of relation names, not even trying to become skilled namers, and thus never progress to mastery.

A relation that comes directly from users is called a “\ **raw**\ ” or “raw data” relation, while one that results from a Relational Algebra operator is called a “\ **derived**\ ” relation. A “\ **view**\ ” is a derived relation that is not materialized until execution time. All three kinds are still relations for planning purposes.

Summary
~~~~~~~~

Here is a video summarizing the above details. Playback faster if you feel like I'm going to slow; 1.5 speed is just fine, I think.

.. youtube:: JsnH_5fa8oA

