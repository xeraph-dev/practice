# Database

> If you will be using migrations, you can name the file to be written in this task whatever you prefer, and then move it to the correct location in the migrations folder in the server configuration step.

In this task, you will write the entire database schema _(with a minimal user table)_ based on the stats obtained from the downloaded datasets.

After writing the schema, you must write a small script to populate the database with the downloaded datasets.

I will give you the database schema in an easy to understand format and you need to translate it into SQL.

> If you really want to prove yourself, try just following the tasks below without looking the schema that I provide you.

## Tasks

- [ ] [Database Schema](#database-schema)
  - [ ] [Initialize Database](#initialize-database)
  - [ ] [Users Table](#users-table)
  - [ ] [Characters Table](#characters-table)
    - [ ] [Character Species Table](#character-species-table)
    - [ ] [Character Types Table](#character-types-table)
    - [ ] [Character Status Enum/Table](#character-status-enum)
    - [ ] [Character Gender Enum/Table](#character-gender-enum)
  - [ ] [Locations Table](#locations-table)
    - [ ] [Location Types Table](#location-types-table)
    - [ ] [Location Dimensions Table](#location-dimensions-table)
  - [ ] [Episodes Table](#episodes-table)
  - [ ] [Characters Episodes Table](#characters-episodes-table)
- [ ] [Script to populate the database](#script-to-populate-the-database)

## Database Schema

### Some things to consider

- All tables are named in the plural, it works like a folder in the file system.
- I prefer to use TEXT over VARCHAR(N) for simplicity. You can use VARCHAR(N) if you want.
- The `INTEGER` type is also for simplicity. Maybe in the database of your choice you can define a more specific integer type like `byte` (`8` **bits**), `short` (`16` **bits**), etc... Use it if you want.
- The [Users Table](#users-table) will not be used at this time, but will need to be defined to reference the fields (**created**|**updated**|**deleted**)**\_by** in the tables to be defined in this task. So we will define the minimal table (only id and metadata).
- `Enums` in **SQLite** must be defined by creating a table and inserting the data after the table is created or using the [CHECK constraints](https://www.sqlitetutorial.net/sqlite-check-constraint/). In code it can be defined as its alternative in language.
- fields (**created**|**updated**|**deleted**)**\_**(**by**|**in**) are used as record metadata. It's good practice for all records to have these fields.
- **deleted\_**(**by**|**in**) fields are used to know when the record was marked as deleted. It's good practice to never delete a record directly, just mark it as deleted, and if you really want to delete it, do it in a purge step.
- the **from_api** field is only used for the synchronization process to know which record was imported from the original API and which was not.
- `DateTime` is not directly supported in **SQLite** and maybe some other databases. I recommend using the `TEXT` type in these cases.

### Initialize Database

Setup your database folder and create your first migration file

### Users Table

| Key Type                                           | Column Name    | Type       | Nullable | Unique  | Default             | Comment                                              |
| -------------------------------------------------- | -------------- | ---------- | -------- | ------- | ------------------- | ---------------------------------------------------- |
| **_Primary Key_**                                  | **id**         | `INTEGER`  | `false`  | `true`  |                     | The id of the user                                   |
|                                                    | **name**       | `TEXT`     | `false`  | `true`  |                     | The name of the user                                 |
| **_Foreign Key_** <br> [user](#users-table).**id** | **created_by** | `INTEGER`  | `false`  | `false` |                     | The user that creates this record                    |
| **_Foreign Key_** <br> [user](#users-table).**id** | **updated_by** | `INTEGER`  | `false`  | `false` |                     | The user that updates this record                    |
| **_Foreign Key_** <br> [user](#users-table).**id** | **deleted_by** | `INTEGER`  | `true`   | `false` | `NULL`              | The user that deletes this record                    |
|                                                    | **created_at** | `DateTime` | `false`  | `false` | `CURRENT_TIMESTAMP` | Time at which the record was created in the database |
|                                                    | **updated_at** | `DateTime` | `false`  | `false` | `CURRENT_TIMESTAMP` | Time at which the record was created and updated     |
|                                                    | **deleted_at** | `DateTime` | `true`   | `false` | `NULL`              | Time at which the record was deleted                 |

### Characters Table

| Key Type                                                                    | Column Name     | Type                                         | Nullable | Unique  | Default             | Comment                                              |
| --------------------------------------------------------------------------- | --------------- | -------------------------------------------- | -------- | ------- | ------------------- | ---------------------------------------------------- |
| **_Primary Key_**                                                           | **id**          | `INTEGER`                                    | `false`  | `true`  |                     | The id of the character                              |
|                                                                             | **name**        | `TEXT`                                       | `false`  | `false` |                     | The name of the character                            |
|                                                                             | **status**      | [Character Statuses](#character-status-enum) | `false`  | `false` |                     | The status of the character                          |
|                                                                             | **gender**      | [Character Genders](#character-gender-enum)  | `false`  | `false` |                     | The gender of the character                          |
| **_Foreign Key_** <br> [character_species](#character-species-table).**id** | **species_id**  | `INTEGER`                                    | `false`  | `false` |                     | The species of the character.                        |
| **_Foreign Key_** <br> [character_type](#character-types-table).**id**      | **type_id**     | `INTEGER`                                    | `true`   | `false` |                     | The type or subspecies of the character.             |
| **_Foreign Key_** <br> [location](#locations-table).**id**                  | **location_id** | `INTEGER`                                    | `true`   | `false` |                     | The location of the character.                       |
| **_Foreign Key_** <br> [location](#locations-table).**id**                  | **origin_id**   | `INTEGER`                                    | `true`   | `false` |                     | The origin location of the character.                |
|                                                                             | **image**       | `TEXT`                                       | `false`  | `false` |                     | The image of the character                           |
|                                                                             | **from_api**    | `BOOLEAN`                                    | `false`  | `false` | `false`             | If the data was optained from the original api       |
| **_Foreign Key_** <br> [user](#users-table).**id**                          | **created_by**  | `INTEGER`                                    | `false`  | `false` |                     | The user that creates this record                    |
| **_Foreign Key_** <br> [user](#users-table).**id**                          | **updated_by**  | `INTEGER`                                    | `false`  | `false` |                     | The user that updates this record                    |
| **_Foreign Key_** <br> [user](#users-table).**id**                          | **deleted_by**  | `INTEGER`                                    | `true`   | `false` | `NULL`              | The user that deletes this record                    |
|                                                                             | **created_at**  | `DateTime`                                   | `false`  | `false` | `CURRENT_TIMESTAMP` | Time at which the record was created in the database |
|                                                                             | **updated_at**  | `DateTime`                                   | `false`  | `false` | `CURRENT_TIMESTAMP` | Time at which the record was created and updated     |
|                                                                             | **deleted_at**  | `DateTime`                                   | `true`   | `false` | `NULL`              | Time at which the record was deleted                 |

### Character Species Table

| Key Type                                           | Column Name    | Type       | Nullable | Unique  | Default             | Comment                                              |
| -------------------------------------------------- | -------------- | ---------- | -------- | ------- | ------------------- | ---------------------------------------------------- |
| **_Primary Key_**                                  | **id**         | `INTEGER`  | `false`  | `true`  |                     | The id of the character species                      |
|                                                    | **name**       | `TEXT`     | `false`  | `true`  |                     | The name of the character species                    |
| **_Foreign Key_** <br> [user](#users-table).**id** | **created_by** | `INTEGER`  | `false`  | `false` |                     | The user that creates this record                    |
| **_Foreign Key_** <br> [user](#users-table).**id** | **updated_by** | `INTEGER`  | `false`  | `false` |                     | The user that updates this record                    |
| **_Foreign Key_** <br> [user](#users-table).**id** | **deleted_by** | `INTEGER`  | `true`   | `false` | `NULL`              | The user that deletes this record                    |
|                                                    | **created_at** | `DateTime` | `false`  | `false` | `CURRENT_TIMESTAMP` | Time at which the record was created in the database |
|                                                    | **updated_at** | `DateTime` | `false`  | `false` | `CURRENT_TIMESTAMP` | Time at which the record was created and updated     |
|                                                    | **deleted_at** | `DateTime` | `true`   | `false` | `NULL`              | Time at which the record was deleted                 |

### Character Types Table

| Key Type                                           | Column Name    | Type       | Nullable | Unique  | Default             | Comment                                              |
| -------------------------------------------------- | -------------- | ---------- | -------- | ------- | ------------------- | ---------------------------------------------------- |
| **_Primary Key_**                                  | **id**         | `INTEGER`  | `false`  | `true`  |                     | The id of the character type or subspecies           |
|                                                    | **name**       | `TEXT`     | `false`  | `true`  |                     | The name of the character type or subspecies         |
| **_Foreign Key_** <br> [user](#users-table).**id** | **created_by** | `INTEGER`  | `false`  | `false` |                     | The user that creates this record                    |
| **_Foreign Key_** <br> [user](#users-table).**id** | **updated_by** | `INTEGER`  | `false`  | `false` |                     | The user that updates this record                    |
| **_Foreign Key_** <br> [user](#users-table).**id** | **deleted_by** | `INTEGER`  | `true`   | `false` | `NULL`              | The user that deletes this record                    |
|                                                    | **created_at** | `DateTime` | `false`  | `false` | `CURRENT_TIMESTAMP` | Time at which the record was created in the database |
|                                                    | **updated_at** | `DateTime` | `false`  | `false` | `CURRENT_TIMESTAMP` | Time at which the record was created and updated     |
|                                                    | **deleted_at** | `DateTime` | `true`   | `false` | `NULL`              | Time at which the record was deleted                 |

### Character Status Enum

- `Alive`
- `Dead`
- `unknown`

### Character Gender Enum

- `Female`
- `Male`
- `Genderless`
- `unknown`

### Locations Table

| Key Type                                                                  | Column Name      | Type       | Nullable | Unique  | Default             | Comment                                              |
| ------------------------------------------------------------------------- | ---------------- | ---------- | -------- | ------- | ------------------- | ---------------------------------------------------- |
| **_Primary Key_**                                                         | **id**           | `INTEGER`  | `false`  | `true`  |                     | The id of the location                               |
|                                                                           | **name**         | `TEXT`     | `true`   | `false` |                     | The name of the location                             |
| **_Foreign Key_** <br> [location_type](#location-types-table).**id**      | **type_id**      | `INTEGER`  | `true`   | `false` |                     | The type of the location                             |
| **_Foreign Key_** <br> [location_dimension](#location-types-table).**id** | **dimension_id** | `INTEGER`  | `true`   | `false` |                     | The dimension of the location                        |
|                                                                           | **from_api**     | `BOOLEAN`  | `false`  | `false` | `false`             | If the data was optained from the original api       |
| **_Foreign Key_** <br> [user](#users-table).**id**                        | **created_by**   | `INTEGER`  | `false`  | `false` |                     | The user that creates this record                    |
| **_Foreign Key_** <br> [user](#users-table).**id**                        | **updated_by**   | `INTEGER`  | `false`  | `false` |                     | The user that updates this record                    |
| **_Foreign Key_** <br> [user](#users-table).**id**                        | **deleted_by**   | `INTEGER`  | `true`   | `false` | `NULL`              | The user that deletes this record                    |
|                                                                           | **created_at**   | `DateTime` | `false`  | `false` | `CURRENT_TIMESTAMP` | Time at which the record was created in the database |
|                                                                           | **updated_at**   | `DateTime` | `false`  | `false` | `CURRENT_TIMESTAMP` | Time at which the record was created and updated     |
|                                                                           | **deleted_at**   | `DateTime` | `true`   | `false` | `NULL`              | Time at which the record was deleted                 |

### Location Types Table

| Key Type                                           | Column Name    | Type       | Nullable | Unique  | Default             | Comment                                              |
| -------------------------------------------------- | -------------- | ---------- | -------- | ------- | ------------------- | ---------------------------------------------------- |
| **_Primary Key_**                                  | **id**         | `INTEGER`  | `false`  | `true`  |                     | The id of the location type                          |
|                                                    | **name**       | `TEXT`     | `false`  | `false` |                     | The name of the location type                        |
| **_Foreign Key_** <br> [user](#users-table).**id** | **created_by** | `INTEGER`  | `false`  | `false` |                     | The user that creates this record                    |
| **_Foreign Key_** <br> [user](#users-table).**id** | **updated_by** | `INTEGER`  | `false`  | `false` |                     | The user that updates this record                    |
| **_Foreign Key_** <br> [user](#users-table).**id** | **deleted_by** | `INTEGER`  | `true`   | `false` | `NULL`              | The user that deletes this record                    |
|                                                    | **created_at** | `DateTime` | `false`  | `false` | `CURRENT_TIMESTAMP` | Time at which the record was created in the database |
|                                                    | **updated_at** | `DateTime` | `false`  | `false` | `CURRENT_TIMESTAMP` | Time at which the record was created and updated     |
|                                                    | **deleted_at** | `DateTime` | `true`   | `false` | `NULL`              | Time at which the record was deleted                 |

### Location Dimensions Table

| Key Type                                           | Column Name    | Type       | Nullable | Unique  | Default             | Comment                                              |
| -------------------------------------------------- | -------------- | ---------- | -------- | ------- | ------------------- | ---------------------------------------------------- |
| **_Primary Key_**                                  | **id**         | `INTEGER`  | `false`  | `true`  |                     | The id of the location dimension                     |
|                                                    | **name**       | `TEXT`     | `false`  | `false` |                     | The name of the location dimension                   |
| **_Foreign Key_** <br> [user](#users-table).**id** | **created_by** | `INTEGER`  | `false`  | `false` |                     | The user that creates this record                    |
| **_Foreign Key_** <br> [user](#users-table).**id** | **updated_by** | `INTEGER`  | `false`  | `false` |                     | The user that updates this record                    |
| **_Foreign Key_** <br> [user](#users-table).**id** | **deleted_by** | `INTEGER`  | `true`   | `false` | `NULL`              | The user that deletes this record                    |
|                                                    | **created_at** | `DateTime` | `false`  | `false` | `CURRENT_TIMESTAMP` | Time at which the record was created in the database |
|                                                    | **updated_at** | `DateTime` | `false`  | `false` | `CURRENT_TIMESTAMP` | Time at which the record was created and updated     |
|                                                    | **deleted_at** | `DateTime` | `true`   | `false` | `NULL`              | Time at which the record was deleted                 |

### Episodes Table

| Key Type                                           | Column Name    | Type       | Nullable | Unique  | Default             | Comment                                              |
| -------------------------------------------------- | -------------- | ---------- | -------- | ------- | ------------------- | ---------------------------------------------------- |
| **_Primary Key_**                                  | **id**         | `INTEGER`  | `false`  | `true`  |                     | The id of the episode                                |
|                                                    | **name**       | `TEXT`     | `true`   | `false` |                     | The name of the episode                              |
|                                                    | **season**     | `INTEGER`  | `false`  | `false` |                     | The season number                                    |
|                                                    | **episode**    | `INTEGER`  | `false`  | `false` |                     | The episode number                                   |
|                                                    | **air_date**   | `DateTime` | `false`  | `false` |                     | The air date of the episode                          |
|                                                    | **from_api**   | `BOOLEAN`  | `false`  | `false` | `false`             | If the data was optained from the original api       |
| **_Foreign Key_** <br> [user](#users-table).**id** | **created_by** | `INTEGER`  | `false`  | `false` |                     | The user that creates this record                    |
| **_Foreign Key_** <br> [user](#users-table).**id** | **updated_by** | `INTEGER`  | `false`  | `false` |                     | The user that updates this record                    |
| **_Foreign Key_** <br> [user](#users-table).**id** | **deleted_by** | `INTEGER`  | `true`   | `false` | `NULL`              | The user that deletes this record                    |
|                                                    | **created_at** | `DateTime` | `false`  | `false` | `CURRENT_TIMESTAMP` | Time at which the record was created in the database |
|                                                    | **updated_at** | `DateTime` | `false`  | `false` | `CURRENT_TIMESTAMP` | Time at which the record was created and updated     |
|                                                    | **deleted_at** | `DateTime` | `true`   | `false` | `NULL`              | Time at which the record was deleted                 |

### Characters Episodes Table

| Key Type                                                     | Column Name      | Type       | Nullable | Unique  | Default             | Comment                                              |
| ------------------------------------------------------------ | ---------------- | ---------- | -------- | ------- | ------------------- | ---------------------------------------------------- |
| **_Primary Key_**                                            | **id**           | `INTEGER`  | `false`  | `false` |                     | The id of the character episode                      |
| **_Foreign Key_** <br> [character](#characters-table).**id** | **character_id** | `INTEGER`  | `false`  | `false` |                     | The id of the character                              |
| **_Foreign Key_** <br> [episode](#episodes-table).**id**     | **episode_id**   | `INTEGER`  | `false`  | `false` |                     | The id of the episode                                |
| **_Foreign Key_** <br> [user](#users-table).**id**           | **created_by**   | `INTEGER`  | `false`  | `false` |                     | The user that creates this record                    |
| **_Foreign Key_** <br> [user](#users-table).**id**           | **updated_by**   | `INTEGER`  | `false`  | `false` |                     | The user that updates this record                    |
| **_Foreign Key_** <br> [user](#users-table).**id**           | **deleted_by**   | `INTEGER`  | `true`   | `false` | `NULL`              | The user that deletes this record                    |
|                                                              | **created_at**   | `DateTime` | `false`  | `false` | `CURRENT_TIMESTAMP` | Time at which the record was created in the database |
|                                                              | **updated_at**   | `DateTime` | `false`  | `false` | `CURRENT_TIMESTAMP` | Time at which the record was created and updated     |
|                                                              | **deleted_at**   | `DateTime` | `true`   | `false` | `NULL`              | Time at which the record was deleted                 |

## Script to populate the database

Write a simple script to populate the database using the datasets download in [2-get-data](../2-get-data/task.md).
