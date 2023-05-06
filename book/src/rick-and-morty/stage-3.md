# Location and Episode feature

## Tasks

- [ ] Define the database schema
  - [ ] [Locations](#locations)
  - [ ] [Episodes](#episodes)

## Database

### Locations

| Key Type                                     | Column Name    | Type       | Nullable | Unique  | Default             | Comment                                                |
| -------------------------------------------- | -------------- | ---------- | -------- | ------- | ------------------- | ------------------------------------------------------ |
| **_Primary Key_**                            | **id**         | `INTEGER`  | `false`  | `true`  |                     | The id of the location                                 |
|                                              | **name**       | `TEXT`     | `false`  | `false` |                     | The name of the location                               |
|                                              | **type**       | `TEXT`     | `false`  | `false` |                     | The type of the location                               |
|                                              | **dimension**  | `TEXT`     | `false`  | `false` |                     | The dimension of the location                          |
|                                              | **from_api**   | `BOOLEAN`  | `false`  | `false` | `false`             | If the data was optained from the original api         |
| **_Foreign Key_** <br> [user](stage-2.md#users).**id** | **created_by** | `INTEGER`  | `true`   | `false` | `NULL`              | The location that create this character                |
|                                              | **created_at** | `DateTime` | `false`  | `false` | `CURRENT_TIMESTAMP` | Time at which the location was created in the database |
|                                              | **updated_at** | `DateTime` | `false`  | `false` | `CURRENT_TIMESTAMP` | Time at which the location was updated                 |

### Episodes

| Key Type                                     | Column Name    | Type       | Nullable | Unique  | Default             | Comment                                               |
| -------------------------------------------- | -------------- | ---------- | -------- | ------- | ------------------- | ----------------------------------------------------- |
| **_Primary Key_**                            | **id**         | `INTEGER`  | `false`  | `true`  |                     | The id of the episode                                 |
|                                              | **name**       | `TEXT`     | `false`  | `false` |                     | The name of the episode                               |
|                                              | **air_date**   | `DateTime` | `false`  | `false` |                     | The air date of the episode                           |
|                                              | **from_api**   | `BOOLEAN`  | `false`  | `false` | `false`             | If the data was optained from the original api        |
| **_Foreign Key_** <br> [user](stage-2.md#users).**id** | **created_by** | `INTEGER`  | `true`   | `false` | `NULL`              | The episode that create this character                |
|                                              | **created_at** | `DateTime` | `false`  | `false` | `CURRENT_TIMESTAMP` | Time at which the episode was created in the database |
|                                              | **updated_at** | `DateTime` | `false`  | `false` | `CURRENT_TIMESTAMP` | Time at which the episode was updated                 |
