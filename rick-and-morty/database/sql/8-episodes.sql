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