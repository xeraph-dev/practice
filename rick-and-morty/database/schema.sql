PRAGMA foreign_keys = ON;



CREATE TABLE IF NOT EXISTS users (
  id          INTEGER NOT NULL,                             -- The id of the user
  name        TEXT    NOT NULL,                             -- The name of the user
  created_by  INTEGER NOT NULL,                             -- The user that creates this record
  updated_by  INTEGER NOT NULL,                             -- The user that updates this record
  deleted_by  INTEGER           DEFAULT NULL,               -- The user that deletes this record
  created_at  TEXT    NOT NULL  DEFAULT CURRENT_TIMESTAMP,  -- Time at which the record was created in the database
  updated_at  TEXT    NOT NULL  DEFAULT CURRENT_TIMESTAMP,  -- Time at which the record was created and updated
  deleted_at  TEXT              DEFAULT NULL,               -- Time at which the record was deleted
  
  PRIMARY KEY (id),
  UNIQUE (name),
  FOREIGN KEY (created_by) REFERENCES users (id) ON DELETE RESTRICT,
  FOREIGN KEY (updated_by) REFERENCES users (id) ON DELETE RESTRICT,
  FOREIGN KEY (deleted_by) REFERENCES users (id) ON DELETE RESTRICT
);


CREATE TRIGGER IF NOT EXISTS prevent_users_system_delete
  BEFORE DELETE
  ON users
  WHEN old.id = 0
BEGIN
  SELECT RAISE (ABORT, "Cannot delete system user");
END;


CREATE TRIGGER IF NOT EXISTS prevent_users_purge 
  BEFORE DELETE
  ON users
  WHEN (old.deleted_at IS NULL OR old.deleted_by IS NULL) AND old.id <> 0
BEGIN
  SELECT RAISE (ABORT, "Before you purge a record, you must mark it as deleted. Try defining deleted_at and deleted_by before purging the record");
END;


CREATE TRIGGER IF NOT EXISTS update_users_updated_at
  AFTER UPDATE
  ON users
BEGIN
  UPDATE users 
  SET updated_at = CURRENT_TIMESTAMP
  WHERE id = new.id;
END;


INSERT INTO users (id, name, created_by, updated_by)
VALUES (0, "system", 0, 0) ON CONFLICT DO NOTHING;



CREATE TABLE IF NOT EXISTS characters (
  id          INTEGER NOT NULL,                             -- The id of the character
  name        TEXT    NOT NULL,                             -- The name of the character
  status      TEXT    NOT NULL,                             -- The status of the character
  gender      TEXT    NOT NULL,                             -- The gender of the character
  species_id  INTEGER NOT NULL,                             -- The species of the character.
  type_id     INTEGER,                                      -- The type or subspecies of the character.
  location_id INTEGER,                                      -- The location of the character.
  origin_id   INTEGER,                                      -- The origin of the character.
  image       TEXT    NOT NULL,                             -- The image of the character
  from_api    BOOLEAN NOT NULL  DEFAULT false,              -- If the data was obtained from the original api
  created_by  INTEGER NOT NULL  DEFAULT 0,                  -- The user that creates this record
  updated_by  INTEGER NOT NULL  DEFAULT 0,                  -- The user that updates this record
  deleted_by  INTEGER           DEFAULT NULL,               -- The user that deletes this record
  created_at  TEXT    NOT NULL  DEFAULT CURRENT_TIMESTAMP,  -- Time at which the record was created in the database
  updated_at  TEXT    NOT NULL  DEFAULT CURRENT_TIMESTAMP,  -- Time at which the record was created and updated
  deleted_at  TEXT              DEFAULT NULL,               -- Time at which the record was deleted
  
  CHECK (status = 'Alive'  OR status = 'Dead' OR status = 'unknown'),
  CHECK (gender = 'Female' OR gender = 'Male' OR gender = 'Genderless' OR gender = 'unknown'),
  CHECK (from_api IN (false, true)),
  PRIMARY KEY (id),
  FOREIGN KEY (species_id)  REFERENCES character_species (id) ON DELETE RESTRICT,
  FOREIGN KEY (type_id)     REFERENCES character_types (id)   ON DELETE RESTRICT,
  FOREIGN KEY (created_by)  REFERENCES users (id)             ON DELETE RESTRICT,
  FOREIGN KEY (updated_by)  REFERENCES users (id)             ON DELETE RESTRICT,
  FOREIGN KEY (deleted_by)  REFERENCES users (id)             ON DELETE RESTRICT
);


CREATE TRIGGER IF NOT EXISTS prevent_characters_purge 
  BEFORE DELETE
  ON characters
  WHEN old.deleted_at IS NULL OR old.deleted_by IS NULL
BEGIN
  SELECT RAISE (ABORT, "Before you purge a record, you must mark it as deleted. Try defining deleted_at and deleted_by before purging the record");
END;


CREATE TRIGGER IF NOT EXISTS update_characters_updated_at
  AFTER UPDATE
  ON characters
BEGIN
  UPDATE characters 
  SET updated_at = CURRENT_TIMESTAMP
  WHERE id = new.id;
END;



CREATE TABLE IF NOT EXISTS character_species (
  id          INTEGER NOT NULL,                             -- The id of the character species
  name        TEXT    NOT NULL,                             -- The name of the character species
  created_by  INTEGER NOT NULL  DEFAULT 0,                  -- The user that creates this record
  updated_by  INTEGER NOT NULL  DEFAULT 0,                  -- The user that updates this record
  deleted_by  INTEGER           DEFAULT NULL,               -- The user that deletes this record
  created_at  TEXT    NOT NULL  DEFAULT CURRENT_TIMESTAMP,  -- Time at which the record was created in the database
  updated_at  TEXT    NOT NULL  DEFAULT CURRENT_TIMESTAMP,  -- Time at which the record was created and updated
  deleted_at  TEXT              DEFAULT NULL,               -- Time at which the record was deleted
  
  PRIMARY KEY (id),
  UNIQUE (name),
  FOREIGN KEY (created_by) REFERENCES users (id) ON DELETE RESTRICT,
  FOREIGN KEY (updated_by) REFERENCES users (id) ON DELETE RESTRICT,
  FOREIGN KEY (deleted_by) REFERENCES users (id) ON DELETE RESTRICT
);


CREATE TRIGGER IF NOT EXISTS prevent_character_species_purge 
  BEFORE DELETE
  ON character_species
  WHEN old.deleted_at IS NULL OR old.deleted_by IS NULL
BEGIN
  SELECT RAISE (ABORT, "Before you purge a record, you must mark it as deleted. Try defining deleted_at and deleted_by before purging the record");
END;


CREATE TRIGGER IF NOT EXISTS update_character_species_updated_at
  AFTER UPDATE
  ON character_species
BEGIN
  UPDATE character_species 
  SET updated_at = CURRENT_TIMESTAMP
  WHERE id = new.id;
END;



CREATE TABLE IF NOT EXISTS character_types (
  id          INTEGER NOT NULL,                             -- The id of the character type
  name        TEXT    NOT NULL,                             -- The name of the character type
  created_by  INTEGER NOT NULL  DEFAULT 0,                  -- The user that creates this record
  updated_by  INTEGER NOT NULL  DEFAULT 0,                  -- The user that updates this record
  deleted_by  INTEGER           DEFAULT NULL,               -- The user that deletes this record
  created_at  TEXT    NOT NULL  DEFAULT CURRENT_TIMESTAMP,  -- Time at which the record was created in the database
  updated_at  TEXT    NOT NULL  DEFAULT CURRENT_TIMESTAMP,  -- Time at which the record was created and updated
  deleted_at  TEXT              DEFAULT NULL,               -- Time at which the record was deleted
  
  PRIMARY KEY (id),
  UNIQUE (name),
  FOREIGN KEY (created_by) REFERENCES users (id) ON DELETE RESTRICT,
  FOREIGN KEY (updated_by) REFERENCES users (id) ON DELETE RESTRICT,
  FOREIGN KEY (deleted_by) REFERENCES users (id) ON DELETE RESTRICT
);


CREATE TRIGGER IF NOT EXISTS prevent_character_types_purge 
  BEFORE DELETE
  ON character_types
  WHEN old.deleted_at IS NULL OR old.deleted_by IS NULL
BEGIN
  SELECT RAISE (ABORT, "Before you purge a record, you must mark it as deleted. Try defining deleted_at and deleted_by before purging the record");
END;


CREATE TRIGGER IF NOT EXISTS update_character_types_updated_at
  AFTER UPDATE
  ON character_types
BEGIN
  UPDATE character_types 
  SET updated_at = CURRENT_TIMESTAMP
  WHERE id = new.id;
END;



CREATE TABLE IF NOT EXISTS locations (
  id            INTEGER NOT NULL,                             -- The id of the location
  name          TEXT    NOT NULL,                             -- The name of the location
  type_id       TEXT,                                         -- The type of the location
  dimension_id  TEXT,                                         -- The dimension of the location
  from_api      BOOLEAN NOT NULL  DEFAULT false,              -- If the data was obtained from the original api
  created_by    INTEGER NOT NULL  DEFAULT 0,                  -- The user that creates this record
  updated_by    INTEGER NOT NULL  DEFAULT 0,                  -- The user that updates this record
  deleted_by    INTEGER           DEFAULT NULL,               -- The user that deletes this record
  created_at    TEXT    NOT NULL  DEFAULT CURRENT_TIMESTAMP,  -- Time at which the record was created in the database
  updated_at    TEXT    NOT NULL  DEFAULT CURRENT_TIMESTAMP,  -- Time at which the record was created and updated
  deleted_at    TEXT              DEFAULT NULL,               -- Time at which the record was deleted
  
  CHECK (from_api IN (false, true)),
  PRIMARY KEY (id),
  UNIQUE (name),
  FOREIGN KEY (type_id)       REFERENCES location_types (id)      ON DELETE RESTRICT,
  FOREIGN KEY (dimension_id)  REFERENCES location_dimensions (id) ON DELETE RESTRICT,
  FOREIGN KEY (created_by)    REFERENCES users (id)               ON DELETE RESTRICT,
  FOREIGN KEY (updated_by)    REFERENCES users (id)               ON DELETE RESTRICT,
  FOREIGN KEY (deleted_by)    REFERENCES users (id)               ON DELETE RESTRICT
);


CREATE TRIGGER IF NOT EXISTS prevent_locations_purge 
  BEFORE DELETE
  ON locations
  WHEN old.deleted_at IS NULL OR old.deleted_by IS NULL
BEGIN
  SELECT RAISE (ABORT, "Before you purge a record, you must mark it as deleted. Try defining deleted_at and deleted_by before purging the record");
END;


CREATE TRIGGER IF NOT EXISTS update_locations_updated_at
  AFTER UPDATE
  ON locations
BEGIN
  UPDATE locations 
  SET updated_at = CURRENT_TIMESTAMP
  WHERE id = new.id;
END;



CREATE TABLE IF NOT EXISTS location_types (
  id          INTEGER NOT NULL,                             -- The id of the location type
  name        TEXT    NOT NULL,                             -- The name of the location type
  created_by  INTEGER NOT NULL  DEFAULT 0,                  -- The user that creates this record
  updated_by  INTEGER NOT NULL  DEFAULT 0,                  -- The user that updates this record
  deleted_by  INTEGER           DEFAULT NULL,               -- The user that deletes this record
  created_at  TEXT    NOT NULL  DEFAULT CURRENT_TIMESTAMP,  -- Time at which the record was created in the database
  updated_at  TEXT    NOT NULL  DEFAULT CURRENT_TIMESTAMP,  -- Time at which the record was created and updated
  deleted_at  TEXT              DEFAULT NULL,               -- Time at which the record was deleted
  
  PRIMARY KEY (id),
  UNIQUE (name),
  FOREIGN KEY (created_by) REFERENCES users (id) ON DELETE RESTRICT,
  FOREIGN KEY (updated_by) REFERENCES users (id) ON DELETE RESTRICT,
  FOREIGN KEY (deleted_by) REFERENCES users (id) ON DELETE RESTRICT
);


CREATE TRIGGER IF NOT EXISTS prevent_location_types_purge 
  BEFORE DELETE
  ON location_types
  WHEN old.deleted_at IS NULL OR old.deleted_by IS NULL
BEGIN
  SELECT RAISE (ABORT, "Before you purge a record, you must mark it as deleted. Try defining deleted_at and deleted_by before purging the record");
END;


CREATE TRIGGER IF NOT EXISTS update_location_types_updated_at
  AFTER UPDATE
  ON location_types
BEGIN
  UPDATE location_types 
  SET updated_at = CURRENT_TIMESTAMP
  WHERE id = new.id;
END;



CREATE TABLE IF NOT EXISTS location_dimensions (
  id          INTEGER NOT NULL,                             -- The id of the location dimension
  name        TEXT    NOT NULL,                             -- The name of the location dimension
  created_by  INTEGER NOT NULL  DEFAULT 0,                  -- The user that creates this record
  updated_by  INTEGER NOT NULL  DEFAULT 0,                  -- The user that updates this record
  deleted_by  INTEGER           DEFAULT NULL,               -- The user that deletes this record
  created_at  TEXT    NOT NULL  DEFAULT CURRENT_TIMESTAMP,  -- Time at which the record was created in the database
  updated_at  TEXT    NOT NULL  DEFAULT CURRENT_TIMESTAMP,  -- Time at which the record was created and updated
  deleted_at  TEXT              DEFAULT NULL,               -- Time at which the record was deleted

  PRIMARY KEY (id),
  UNIQUE (name),
  FOREIGN KEY (created_by) REFERENCES users (id) ON DELETE RESTRICT,
  FOREIGN KEY (updated_by) REFERENCES users (id) ON DELETE RESTRICT,
  FOREIGN KEY (deleted_by) REFERENCES users (id) ON DELETE RESTRICT
);


CREATE TRIGGER IF NOT EXISTS prevent_location_dimensions_purge 
  BEFORE DELETE
  ON location_dimensions
  WHEN old.deleted_at IS NULL OR old.deleted_by IS NULL
BEGIN
  SELECT RAISE (ABORT, "Before you purge a record, you must mark it as deleted. Try defining deleted_at and deleted_by before purging the record");
END;


CREATE TRIGGER IF NOT EXISTS update_location_dimensions_updated_at
  AFTER UPDATE
  ON location_dimensions
BEGIN
  UPDATE location_dimensions 
  SET updated_at = CURRENT_TIMESTAMP
  WHERE id = new.id;
END;



CREATE TABLE IF NOT EXISTS episodes (
  id          INTEGER NOT NULL,                             -- The id of the episode
  name        TEXT    NOT NULL,                             -- The name of the episode
  season      INTEGER NOT NULL,                             -- The season number of the episode
  episode     INTEGER NOT NULL,                             -- The episode number of the episode
  air_date    TEXT    NOT NULL,                             -- The air date of the episode
  from_api    BOOLEAN NOT NULL  DEFAULT false,              -- If the data was obtained from the original api
  created_by  INTEGER NOT NULL  DEFAULT 0,                  -- The user that creates this record
  updated_by  INTEGER NOT NULL  DEFAULT 0,                  -- The user that updates this record
  deleted_by  INTEGER           DEFAULT NULL,               -- The user that deletes this record
  created_at  TEXT    NOT NULL  DEFAULT CURRENT_TIMESTAMP,  -- Time at which the record was created in the database
  updated_at  TEXT    NOT NULL  DEFAULT CURRENT_TIMESTAMP,  -- Time at which the record was created and updated
  deleted_at  TEXT              DEFAULT NULL,               -- Time at which the record was deleted

  CHECK (from_api IN (false, true)),
  PRIMARY KEY (id),
  UNIQUE (name),
  UNIQUE (season, episode),
  FOREIGN KEY (created_by) REFERENCES users (id) ON DELETE RESTRICT,
  FOREIGN KEY (updated_by) REFERENCES users (id) ON DELETE RESTRICT,
  FOREIGN KEY (deleted_by) REFERENCES users (id) ON DELETE RESTRICT
);


CREATE TRIGGER IF NOT EXISTS prevent_episodes_purge 
  BEFORE DELETE
  ON episodes
  WHEN old.deleted_at IS NULL OR old.deleted_by IS NULL
BEGIN
  SELECT RAISE (ABORT, "Before you purge a record, you must mark it as deleted. Try defining deleted_at and deleted_by before purging the record");
END;


CREATE TRIGGER IF NOT EXISTS update_episodes_updated_at
  AFTER UPDATE
  ON episodes
BEGIN
  UPDATE episodes 
  SET updated_at = CURRENT_TIMESTAMP
  WHERE id = new.id;
END;



CREATE TABLE IF NOT EXISTS characters_episodes (
  id            INTEGER NOT NULL,                             -- The id of the character episode
  character_id  INTEGER NOT NULL,                             -- The id of the character
  episode_id    INTEGER NOT NULL,                             -- The id of the episode
  created_by    INTEGER NOT NULL  DEFAULT 0,                  -- The user that creates this record
  updated_by    INTEGER NOT NULL  DEFAULT 0,                  -- The user that updates this record
  deleted_by    INTEGER           DEFAULT NULL,               -- The user that deletes this record
  created_at    TEXT    NOT NULL  DEFAULT CURRENT_TIMESTAMP,  -- Time at which the record was created in the database
  updated_at    TEXT    NOT NULL  DEFAULT CURRENT_TIMESTAMP,  -- Time at which the record was created and updated
  deleted_at    TEXT              DEFAULT NULL,               -- Time at which the record was deleted

  PRIMARY KEY (id),
  UNIQUE(character_id, episode_id),
  FOREIGN KEY (character_id)  REFERENCES characters (id)  ON DELETE RESTRICT,
  FOREIGN KEY (episode_id)    REFERENCES episodes (id)    ON DELETE RESTRICT,
  FOREIGN KEY (created_by)    REFERENCES users (id)       ON DELETE RESTRICT,
  FOREIGN KEY (updated_by)    REFERENCES users (id)       ON DELETE RESTRICT,
  FOREIGN KEY (deleted_by)    REFERENCES users (id)       ON DELETE RESTRICT
);


CREATE TRIGGER IF NOT EXISTS prevent_characters_episodes_purge 
  BEFORE DELETE
  ON characters_episodes
  WHEN old.deleted_at IS NULL OR old.deleted_by IS NULL
BEGIN
  SELECT RAISE (ABORT, "Before you purge a record, you must mark it as deleted. Try defining deleted_at and deleted_by before purging the record");
END;


CREATE TRIGGER IF NOT EXISTS update_characters_episodes_updated_at
  AFTER UPDATE
  ON characters_episodes
BEGIN
  UPDATE characters_episodes 
  SET updated_at = CURRENT_TIMESTAMP
  WHERE id = new.id;
END;



CREATE VIEW IF NOT EXISTS v_characters AS
SELECT
  c.id,
  c.name,
  c.status,
  c.gender,
  c.species_id,   cs.name AS species,
  c.type_id,      ct.name AS type,
  c.location_id,  cl.name AS location,
  c.origin_id,    co.name AS origin,
  c.image,
  c.from_api,
  c.created_by,
  c.updated_by,
  c.deleted_by,
  c.created_at,
  c.updated_at,
  c.deleted_at
FROM characters AS c
INNER JOIN character_species  AS cs ON cs.id = c.species_id
INNER JOIN character_types    AS ct ON ct.id = c.type_id
INNER JOIN locations          AS cl ON cl.id = c.location_id
INNER JOIN locations          AS co ON co.id = c.origin_id;



CREATE VIEW IF NOT EXISTS v_locations AS
SELECT
  l.id,
  l.name,
  l.type_id,      lt.name AS type,
  l.dimension_id, ld.name AS dimension,
  l.from_api,
  l.created_by,
  l.updated_by,
  l.deleted_by,
  l.created_at,
  l.updated_at,
  l.deleted_at
FROM locations AS l
INNER JOIN location_types       AS lt ON lt.id = l.type_id
INNER JOIN location_dimensions  AS ld ON ld.id = l.dimension_id;
