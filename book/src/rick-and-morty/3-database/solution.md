# My Solution in SQLite

## Some Important Observations

> The users table cannot have `DEFAULT 0` in **(created|updated)\_by**, it will only be available to the rest of the table.
> A user can only be created by another user, the **system** user only creates the first admin user.

> Note that also as a good practice I define a **system** user with id `0`. This user should only be used in scripts or tools external to the project.
> This user cannot be deleted, to prevent it I add a `TRIGGER`.

> All references only restrict the delete action because a purge operation can cause some records to be orphaned.
> The only **_safe_** way to purge a record is to purge all parents first.
> An **_unsafe_** but effective way is to run the query `PRAGMA Foreign_keys = OFF` first, remember to set it to `ON` after your _**unsafe**_ operations.

> SQLite doesn't have enums, so I use `CHECK` to define a set of allowed strings.
>
> The `BOOLEAN` type is an alias to `INTEGER` that SQLite allows, it is also necessary to check if it is `false`\|`0` or `true` \| `1`.

### Base table schema

As a good practice, I decide to use this schema as the default table schema for all tables.

```sql
CREATE TABLE IF NOT EXISTS <table_name> (
  id          INTEGER NOT NULL,                             -- The id of the <record_name>
  created_by  INTEGER NOT NULL  DEFAULT 0,                  -- The user that creates this record
  updated_by  INTEGER NOT NULL  DEFAULT 0,                  -- The user that updates this record
  deleted_by  INTEGER           DEFAULT NULL,               -- The user that deletes this record
  created_at  TEXT    NOT NULL  DEFAULT CURRENT_TIMESTAMP,  -- Time at which the record was created in the database
  updated_at  TEXT    NOT NULL  DEFAULT CURRENT_TIMESTAMP,  -- Time at which the record was created and updated
  deleted_at  TEXT              DEFAULT NULL,               -- Time at which the record was deleted

  PRIMARY KEY (id),
  FOREIGN KEY (created_by) REFERENCES users (id) ON DELETE RESTRICT,
  FOREIGN KEY (updated_by) REFERENCES users (id) ON DELETE RESTRICT,
  FOREIGN KEY (deleted_by) REFERENCES users (id) ON DELETE RESTRICT
);
```

### Base triggers

As a good practice I add some triggers to add extra security and usability to the tables.

#### Prevent record from being purged

This trigger prevents the record from being purged without first being marked as deleted.

```sql
CREATE TRIGGER IF NOT EXISTS prevent_<table_name>_purge
  BEFORE DELETE
  ON <table_name>
  WHEN old.deleted_at IS NULL OR old.deleted_by IS NULL
BEGIN
  SELECT RAISE (ABORT, "Before you purge a record, you must mark it as deleted. Try defining deleted_at and deleted_by before purging the record");
END;
```

#### Update record **updated_at**

This trigger automatically updates **updated_at** after a record is updated.

```sql
CREATE TRIGGER IF NOT EXISTS update_<table_name>_updated_at
  AFTER UPDATE
  ON <table_name>
BEGIN
  UPDATE <table_name>
  SET updated_at = CURRENT_TIMESTAMP
  WHERE id = new.id;
END;
```

## Database Schema

**File**: `<root>/database/schema.sql`

### Database settings

```sql
PRAGMA foreign_keys = ON;
```

### Users definition

```sql
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
```

### Insert system user

```sql
INSERT INTO users (id, name, created_by, updated_by)
VALUES (0, "system", 0, 0) ON CONFLICT DO NOTHING;
```

### Characters definition

```sql
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
```

### Character species definition

```sql
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
```

### Character types definition

```sql
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
```

### Locations definition

```sql
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
```

### Location types definition

```sql
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
```

### Location dimensions definition

```sql
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
```

### Episodes definition

```sql
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
```

### Characters Episodes definition

```sql
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

```

## Script to populate the database

Since SQLite has a utility to import from **csv**, I first convert the **json** files to **csv** files and with a bash script use the sqlite3 cli to populate the database.

### Setup script

```bash#!/bash
DB_PATH="$(pwd)/$(dirname "$0")/database.db"
SCHEMA_PATH="$(pwd)/$(dirname "$0")/schema.sql"

if [ -f "$DB_PATH" ]; then rm "$DB_PATH"; fi
if [ -f "$SCHEMA_PATH" ]; then sqlite3 "$DB_PATH" <"$SCHEMA_PATH"; fi
```

### Script to populate the database

#### Base script file (imports, and db initialization)

```javascript
import { DateTime } from 'luxon'
import { dirname, join } from 'node:path'
import { fileURLToPath } from 'node:url'
import sqlite3 from 'sqlite3'

import characters from './characters.json' assert { type: 'json' }
import episodes from './episodes.json' assert { type: 'json' }
import locations from './locations.json' assert { type: 'json' }

const __dirname = dirname(fileURLToPath(import.meta.url))
const db = new sqlite3.Database(join(__dirname, 'database.db'), err => {
  if (err) return console.error(err.message)
  console.log('Connected to the SQlite database.')
})

/**
 * format date to sqlite ISO String with UTC time zone
 * @param {string} date
 * @returns {string}
 */
function formatDate(date) {
  return DateTime.fromJSDate(new Date(date)).toUTC().toFormat('yyyy-LL-dd HH:mm:ss')
}

/**
 * split episode string into [season, episode] object
 * @param {string} str
 * @returns {[number, number]}
 */
function parseEpisode(str) {
  let season = ''
  let episode = ''
  let isSeason = false
  let isEpisode = false
  for (const c of str) {
    if (c === 'S') isSeason = true
    if (c === 'E') isEpisode = true
    if (['S', 'E'].includes(c)) continue
    if (isEpisode) episode += c
    else if (isSeason) season += c
  }

  return [parseInt(season), parseInt(episode)]
}

// this is placed at the end of the file
db.close(err => {
  if (err) return console.error(err.message)
  console.log('Close the database connection.')
})
```

#### Populate characters

```javascript
;(function populateCharacters() {
  const speciess = new Set()
  const types = new Set()
  /** @type {{[key: string]: string[]}} */
  const episodes = {}

  const rows = characters
    .map(
      ({ id, name, status, gender, species, type, origin, location, image, episode, created }) => {
        if (species) speciess.add(species)
        if (type) types.add(type)
        episodes[id] = episode
        return [
          id,
          JSON.stringify(name),
          JSON.stringify(status),
          JSON.stringify(gender),
          [...speciess].indexOf(species),
          type ? [...types].indexOf(type) + 1 : 'NULL',
          location || 'NULL',
          origin || 'NULL',
          JSON.stringify(image),
          +true, // from_api
          JSON.stringify(formatDate(created)), // created_at
        ].join(',')
      }
    )
    .map(row => `(${row})`)
    .join(',')

  const speciesRow = [...speciess]
    .map((name, index) => [index + 1, JSON.stringify(name)].join(','))
    .map(row => `(${row})`)
    .join(',')
  const typesRows = [...types]
    .map((name, index) => [index + 1, JSON.stringify(name)].join(','))
    .map(row => `(${row})`)
    .join(',')

  const sqlSpecies = `INSERT INTO character_species (id, name) VALUES ${speciesRow} ON CONFLICT DO NOTHING;`
  const sqlTypes = `INSERT INTO character_types (id, name) VALUES ${typesRows} ON CONFLICT DO NOTHING;`
  const sql = `INSERT INTO characters (id,name,status,gender,species_id,type_id,location_id,origin_id,image,from_api,created_at) VALUES ${rows} ON CONFLICT DO NOTHING;`

  db.run(sqlSpecies, function (err) {
    if (err) return console.error(err.message)
    console.log(`Character species rows inserted ${this.changes}`)
  })

  db.run(sqlTypes, function (err) {
    if (err) return console.error(err.message)
    console.log(`Character types rows inserted ${this.changes}`)
  })

  db.run(sql, function (err) {
    if (err) return console.error(err.message)
    console.log(`Characters rows inserted ${this.changes}`)
  })

  const episodesRows = Object.entries(episodes)
    .map(([cid, eids]) => eids.map(eid => [cid, eid].join(',')).map(row => `(${row})`))
    .join(',')

  const sqlEpisodes = `INSERT INTO characters_episodes (character_id,episode_id) VALUES ${episodesRows} ON CONFLICT DO NOTHING;`

  db.run(sqlEpisodes, function (err) {
    if (err) return console.error(err.message)
    console.log(`Characters episodes rows inserted ${this.changes}`)
  })
})()
```

#### Populate locations

```javascript
;(function populateLocations() {
  const types = new Set()
  const dimensions = new Set()

  const rows = locations
    .map(({ id, name, type, dimension, created }) => {
      if (type) types.add(type)
      if (dimension) dimensions.add(dimension)
      return [
        id,
        JSON.stringify(name),
        type ? [...types].indexOf(type) + 1 : 'NULL',
        dimension ? [...dimensions].indexOf(dimension) + 1 : 'NULL',
        +true, // from_api
        JSON.stringify(formatDate(created)), // created_at
      ].join(',')
    })
    .map(row => `(${row})`)
    .join(',')

  const typesRows = [...types]
    .map((name, index) => [index + 1, JSON.stringify(name)].join(','))
    .map(row => `(${row})`)
    .join(',')
  const dimensionsRows = [...dimensions]
    .map((name, index) => [index + 1, JSON.stringify(name)].join(','))
    .map(row => `(${row})`)
    .join(',')

  const sqlTypes = `INSERT INTO location_types (id, name) VALUES ${typesRows} ON CONFLICT DO NOTHING;`
  const sqlDimensions = `INSERT INTO location_dimensions (id, name) VALUES ${dimensionsRows} ON CONFLICT DO NOTHING;`
  const sql = `INSERT INTO locations (id,name,type_id,dimension_id,from_api,created_at) VALUES ${rows} ON CONFLICT DO NOTHING;`

  db.run(sqlTypes, function (err) {
    if (err) return console.error(err.message)
    console.log(`Location types rows inserted ${this.changes}`)
  })

  db.run(sqlDimensions, function (err) {
    if (err) return console.error(err.message)
    console.log(`Location dimensions rows inserted ${this.changes}`)
  })

  db.run(sql, function (err) {
    if (err) return console.error(err.message)
    console.log(`Locations rows inserted ${this.changes}`)
  })
})()
```

#### Populate episodes

```javascript
;(function populateEpisodes() {
  const rows = episodes
    .map(({ id, name, episode: episodeString, air_date, created }) => {
      const [season, episode] = parseEpisode(episodeString)
      return [
        id,
        JSON.stringify(name),
        season,
        episode,
        JSON.stringify(formatDate(air_date)),
        +true, // from_api
        JSON.stringify(formatDate(created)), // created_at
      ].join(',')
    })
    .map(row => `(${row})`)
    .join(',')

  const sql = `INSERT INTO episodes (id,name,season,episode,air_date,from_api,created_at) VALUES ${rows} ON CONFLICT DO NOTHING;`
  db.run(sql, function (err) {
    if (err) return console.error(err.message)
    console.log(`Episodes rows inserted ${this.changes}`)
  })
})()
```

#### Population process output

```
Character types rows inserted 169
Character species rows inserted 10
Location dimensions rows inserted 33
Locations rows inserted 126
Location types rows inserted 45
Characters rows inserted 826
Characters episodes rows inserted 1267
Episodes rows inserted 51
```
