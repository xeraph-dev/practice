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


ALTER TABLE characters 
ADD COLUMN species_id INTEGER NOT NULL  -- The species of the character.
REFERENCES character_species (id) ON DELETE RESTRICT;