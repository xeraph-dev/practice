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
