Joe Celko's page examples
=========================

.. activecode:: pilot_hangar_create
   :language: sql

    DROP TABLE IF EXISTS PilotSkills;

    CREATE TABLE PilotSkills
    (pilot_name CHAR(15) NOT NULL,
    plane_name CHAR(15) NOT NULL,
    PRIMARY KEY (pilot_name, plane_name));

    DROP TABLE IF EXISTS Hangar;
    CREATE TABLE Hangar
    (plane_name CHAR(15) NOT NULL PRIMARY KEY);

    INSERT INTO PilotSkills VALUES ('Celko',    'Piper Cub');
    INSERT INTO PilotSkills VALUES ('Higgins',  'B-52 Bomber');
    INSERT INTO PilotSkills VALUES ('Higgins',  'F-14 Fighter');
    INSERT INTO PilotSkills VALUES ('Higgins',  'Piper Cub');
    INSERT INTO PilotSkills VALUES ('Jones',    'B-52 Bomber');
    INSERT INTO PilotSkills VALUES ('Jones',    'F-14 Fighter');
    INSERT INTO PilotSkills VALUES ('Smith',    'B-1 Bomber');
    INSERT INTO PilotSkills VALUES ('Smith',    'B-52 Bomber');
    INSERT INTO PilotSkills VALUES ('Smith',    'F-14 Fighter');
    INSERT INTO PilotSkills VALUES ('Wilson',   'B-1 Bomber');
    INSERT INTO PilotSkills VALUES ('Wilson',   'B-52 Bomber');
    INSERT INTO PilotSkills VALUES ('Wilson',   'F-14 Fighter');
    INSERT INTO PilotSkills VALUES ('Wilson',   'F-17 Fighter');

    INSERT INTO Hangar VALUES ('B-1 Bomber');
    INSERT INTO Hangar VALUES ('B-52 Bomber');
    INSERT INTO Hangar VALUES ('F-14 Fighter');


.. activecode:: pilot_hangar_divide
   :language: sql
   :include: pilot_hangar_create

   -- A method made popular by C. Date in his textbooks
   SELECT DISTINCT pilot_name
   FROM PilotSkills AS PS1
   WHERE NOT EXISTS
       (SELECT *
          FROM Hangar
         WHERE NOT EXISTS
               (SELECT *
                  FROM PilotSkills AS PS2
                 WHERE (PS1.pilot_name = PS2.pilot_name)
                   AND (PS2.plane_name = Hangar.plane_name)));

Exact division as proposed by Celko

.. activecode:: pilot_hangar_divide_exact
   :language: sql
   :include: pilot_hangar_create

    SELECT PS1.pilot_name
      FROM PilotSkills AS PS1
           LEFT OUTER JOIN
           Hangar AS H1
           ON PS1.plane_name = H1.plane_name
      GROUP BY PS1.pilot_name
    HAVING COUNT(PS1.plane_name) = (SELECT COUNT(plane_name) FROM Hangar)
       AND COUNT(H1.plane_name) = (SELECT COUNT(plane_name) FROM Hangar);
