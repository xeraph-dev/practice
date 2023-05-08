

CREATE TABLE IF NOT EXISTS characters (
  id          INTEGER NOT NULL      PRIMARY KEY,                -- The id of the character
  name        TEXT    NOT NULL,                                 -- The name of the character
  status      TEXT    NOT NULL CHECK(status = 'Alive' OR        -- The status of the character
                                     status = 'Dead'  OR 
                                     status = 'unknown'),
  gender      TEXT    NOT NULL CHECK(gender = 'Female'      OR  -- The gender of the character
                                     gender = 'Male'        OR 
                                     gender = 'Genderless'  OR 
                                     gender = 'unknown'),
  created_by  INTEGER NOT NULL      REFERENCES users (id)       -- The user that creates this record
                                      ON DELETE RESTRICT,
  updated_by  INTEGER NOT NULL      REFERENCES users (id)       -- The user that updates this record
                                      ON DELETE RESTRICT,   
  deleted_by  INTEGER DEFAULT NULL  REFERENCES users (id)       -- The user that deletes this record
                                      ON DELETE RESTRICT,   
  created_at  TEXT    NOT NULL DEFAULT CURRENT_TIMESTAMP,       -- Time at which the record was created in the database
  updated_at  TEXT    NOT NULL DEFAULT CURRENT_TIMESTAMP,       -- Time at which the record was created and updated
  deleted_at  TEXT    DEFAULT NULL                              -- Time at which the record was deleted
);
