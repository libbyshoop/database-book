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
reside_townId VARCHAR(3) REFERENCES town(townId),     -- foreign key
idol_creatureId     INTEGER
);

ALTER TABLE creature
ADD FOREIGN KEY(idol_creatureId) REFERENCES creature(creatureId);

CREATE TABLE skill (
skillCode          VARCHAR(3)      NOT NULL PRIMARY KEY,
skillDescription   VARCHAR(40),
maxProficiency     INTEGER,     -- max score that can be achieved for this skill
minProficiency     INTEGER,     -- min score that can be achieved for this skill
origin_townId      VARCHAR(3)     REFERENCES town(townId)     -- foreign key
);

CREATE TABLE teamSkill (
skillCode      VARCHAR(3)  NOT NULL PRIMARY KEY references skill (skillCode),
teamSize       INTEGER
);

CREATE TABLE achievement (
achId              INTEGER NOT NULL PRIMARY KEY AUTO_INCREMENT, -- mysql needs the _
creatureId         INTEGER,
skillCode          VARCHAR(3),
proficiency        INTEGER,
achDate            DATETIME,
test_townId VARCHAR(3) REFERENCES town(townId),     -- foreign key
FOREIGN KEY (creatureId) REFERENCES creature (creatureId),
FOREIGN KEY (skillCode) REFERENCES skill (skillCode)
);

CREATE TABLE aspiration
( -- foreign key
  creatureId    INTEGER     NOT NULL   REFERENCES creature(creatureId),
  -- foreign key
  skillCode     VARCHAR(3)  NOT NULL   REFERENCES skill(skillCode),
  aspiredProficiency INTEGER,
  desired_townId     VARCHAR(3) REFERENCES town(townId),     -- foreign key
  PRIMARY KEY (creatureId, skillCode)
);

CREATE TABLE role
(
  roleName VARCHAR(20)   NOT NULL PRIMARY KEY
);

CREATE TABLE contribution (
    creatureId         INTEGER     NOT NULL REFERENCES creature(creatureId),
    achId              INTEGER     NOT NULL REFERENCES achievement(achId),
    skillCode          VARCHAR(3)  NOT NULL REFERENCES skill(skillCode),
    roleName           VARCHAR(20) REFERENCES role(roleName),
    PRIMARY KEY (creatureId, achId)
);

CREATE TABLE aspiredContribution (
    creatureId         INTEGER     NOT NULL REFERENCES creature(creatureId),
    skillCode          VARCHAR(3)  NOT NULL REFERENCES skill(skillCode),
    roleName           VARCHAR(20) REFERENCES role(roleName),
    PRIMARY KEY (creatureId, skillCode)
);
