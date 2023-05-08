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


CREATE TRIGGER IF NOT EXISTS prevent_user_system_delete
  BEFORE DELETE
  ON users
  WHEN old.id = 0
BEGIN
  SELECT RAISE (ABORT, "Cannot delete system user");
END;


CREATE TRIGGER IF NOT EXISTS prevent_user_purge 
  BEFORE DELETE
  ON users
  WHEN (old.deleted_at IS NULL OR old.deleted_by IS NULL) AND old.id <> 0
BEGIN
  SELECT RAISE (ABORT, "Before you purge a record, you must mark it as deleted. Try defining deleted_at and deleted_by before purging the record");
END;


CREATE TRIGGER IF NOT EXISTS update_user_updated_at
  AFTER UPDATE
  ON users
BEGIN
  UPDATE users 
  SET updated_at = CURRENT_TIMESTAMP
  WHERE id = new.id;
END;


INSERT INTO users (id, name, created_by, updated_by)
VALUES (0, "system", 0, 0) ON CONFLICT DO NOTHING;

