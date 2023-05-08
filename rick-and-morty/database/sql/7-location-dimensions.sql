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


ALTER TABLE locations 
ADD COLUMN dimension_id INTEGER  -- The dimension of the character.
REFERENCES location_dimensions (id) ON DELETE RESTRICT;
