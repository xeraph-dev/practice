CREATE TABLE IF NOT EXISTS characters (
  id          INTEGER NOT NULL,                             -- The id of the character
  name        TEXT    NOT NULL,                             -- The name of the character
  status      TEXT    NOT NULL,                             -- The status of the character
  gender      TEXT    NOT NULL,                             -- The gender of the character
  image       TEXT    NOT NULL,                             -- The image of the character
  from_api    BOOLEAN NOT NULL  DEFAULT false,              -- If the data was obtained from the original api
  created_by  INTEGER NOT NULL  DEFAULT 0,                  -- The user that creates this record
  updated_by  INTEGER NOT NULL  DEFAULT 0,                  -- The user that updates this record
  deleted_by  INTEGER           DEFAULT NULL,               -- The user that deletes this record
  created_at  TEXT    NOT NULL  DEFAULT CURRENT_TIMESTAMP,  -- Time at which the record was created in the database
  updated_at  TEXT    NOT NULL  DEFAULT CURRENT_TIMESTAMP,  -- Time at which the record was created and updated
  deleted_at  TEXT              DEFAULT NULL,               -- Time at which the record was deleted
  
  CHECK (status = 'Alive' OR status = 'Dead' OR status = 'unknown'),
  CHECK (gender = 'Female' OR gender = 'Male' OR gender = 'Genderless' OR gender = 'unknown'),
  PRIMARY KEY (id),
  FOREIGN KEY (created_by) REFERENCES users (id) ON DELETE RESTRICT,
  FOREIGN KEY (updated_by) REFERENCES users (id) ON DELETE RESTRICT,
  FOREIGN KEY (deleted_by) REFERENCES users (id) ON DELETE RESTRICT
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
