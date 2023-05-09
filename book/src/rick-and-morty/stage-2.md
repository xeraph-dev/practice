# Characters feature

## Tasks

- [ ] [Implement the restful api](#restful-api)
  - [ ] Implement `/images` static folder, it should contains a path like `/characters/<character id>.jpeg`
  - [ ] [GET Characters](#get-characters-species)
    - [ ] [GET Character](#get-character)
    - [ ] [Create Character](#create-character)
    - [ ] [Update Character](#update-character)
    - [ ] [Parial Update Character](#parcial-update-character)
    - [ ] [Delete Character](#delete-character)
  - `/character`
    - [ ] [GET List Character Species](#get-list-characters-species)
      - [ ] [Get Character Species](#get-characters-species)
      - [ ] [Create Character Species](#create-characters-species)
      - [ ] [Update Character Species](#update-characters-species)
      - [ ] [Parcial Update Character Species](#parcial-update-characters-species)
      - [ ] [Delete Character Species](#delete-characters-species)
    - [ ] [GET List Character Subspecies](#get-list-characters-subspecies)
      - [ ] [Get Character Subspecies](#get-characters-subspecies)
      - [ ] [Create Character Subspecies](#create-characters-subspecies)
      - [ ] [Update Character Subspecies](#update-characters-subspecies)
      - [ ] [Parcial Update Character Subspecies](#parcial-update-characters-subspecies)
      - [ ] [Delete Character Subspecies](#delete-characters-subspecies)
  - [ ] Implement the includes query params
  - [ ] Implement pagination for responses
  - [ ] Implement sorting for responses
  - [ ] Implement filtering for responses
  - [ ] Implement ranged responses
- [ ] Add unit tests to all features

## Script to fill database

Create an run a script that uses the `.csv` generated prevously to populate the local database. Only include the current fields, skip the rest.

## Code Types

### User Type

| Key               | Type               | Nullable |
| ----------------- | ------------------ | -------- |
| **id**            | `Integer`          | `false`  |
| **created_by**    | [user](#user-type) | `true`   |
| **created_by_id** | `Integer`          | `true`   |
| **created_at**    | `DateTime`         | `false`  |
| **updated_at**    | `DateTime`         | `false`  |

### Character Type

| Key               | Type                                              | Nullable | Comment                                                                 |
| ----------------- | ------------------------------------------------- | -------- | ----------------------------------------------------------------------- |
| **id**            | `Integer`                                         | `false`  |                                                                         |
| **name**          | `String`                                          | `false`  |                                                                         |
| **status**        | [character_status](#character-status)             | `false`  |                                                                         |
| **gender**        | [character_gender](#character-gender)             | `false`  |                                                                         |
| **species**       | [character_specie](#character-species-type)       | `true`   |                                                                         |
| **species_id**    | `Integer`                                         | `false`  |                                                                         |
| **subspecies**    | [character_subspecie](#character-subspecies-type) | `true`   |                                                                         |
| **subspecies_id** | `Integer`                                         | `true`   |                                                                         |
| **from_api**      | `Boolean`                                         | `false`  |                                                                         |
| **image_path**    | `String`                                          | `false`  | Computed at character creation. It contains the character's image path. |
| **created_by**    | [user](#user-type)                                | `true`   |                                                                         |
| **created_by_id** | `Integer`                                         | `true`   |                                                                         |
| **created_at**    | `DateTime`                                        | `false`  |                                                                         |
| **updated_at**    | `DateTime`                                        | `false`  |                                                                         |

### Character Species Type

| Key               | Type               | Nullable |
| ----------------- | ------------------ | -------- |
| **id**            | `Integer`          | `false`  |
| **name**          | `String`           | `false`  |
| **created_by**    | [user](#user-type) | `true`   |
| **created_by_id** | `Integer`          | `true`   |
| **created_at**    | `DateTime`         | `false`  |
| **updated_at**    | `DateTime`         | `false`  |

### Character SubSpecies Type

| Key               | Type               | Nullable |
| ----------------- | ------------------ | -------- |
| **id**            | `Integer`          | `false`  |
| **name**          | `String`           | `false`  |
| **created_by**    | [user](#user-type) | `true`   |
| **created_by_id** | `Integer`          | `true`   |
| **created_at**    | `DateTime`         | `false`  |
| **updated_at**    | `DateTime`         | `false`  |

### ResponseMeta

| Key       | Type      | Nullable | Comment                |
| --------- | --------- | -------- | ---------------------- |
| **total** | `Integer` | `false`  | Total count of records |
| **page**  | `Integer` | `false`  | Current page           |
| **count** | `Integer` | `false`  | Record count           |

### ResponseError

| Key        | Type      | Nullable | Comment                                                                                                    |
| ---------- | --------- | -------- | ---------------------------------------------------------------------------------------------------------- |
| **status** | `Integer` | `false`  | Status code of the response                                                                                |
| **error**  | `String`  | `false`  | Error message based on status code (ex: for 400, **error**=`"Bad Request"``)                               |
| **reason** | `String`  | `false`  | The main reason of the error (ex: for 400 and bad ranged input, **reason**=`"Invalid ranged query param"`) |
| **form**   | `Object`  | `true`   | If the endpoint will respond to a form, use this property to specify the error of each field individually  |

## Restful API

> All API routes are under `/api/<version>` or as subdomain `api.<domain>/<version>`. It's important to version the API to be able to make breaking changes without affecting current clients
>
> In this practice you will use `/api/v1` as the root of all api endpoints. The endpoints don't contain this fragment in their path to avoid redundancy

> - If an unexpected error occurs on the server, respond with status code [500](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/500)
> - If the user tries to access to a non-defined endpoint, respond with status code [404](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/404)
> - If the user tries to access to a non-defined method, respond with status code [405](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/405)
> - If the user sends a bad query param, respond with status code [400](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/400)
> - If the endpoint ends without error but the response is empty, respond with status code [204](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/204). This is useful when update or delete an entity
> - If the endpoint ends without errors and creates a new entity successfully, respond with status code [201](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/201). This is useful when create an entity
> - If the endpoint ends without error and the response is not empty, respond with status code [200](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/200) unless endpoint specifies another status code (ex: 201 for creations)
> - I recommend to define all endpoints first and respond with status code [501](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/501), it's useful to avoid errors when naming or forgetting some endpoint
> - If any error occurs on the server, respond wit body [ResponseError](#responseerror)

> `includes` query params will be used to include the entity of a reference (ex: in endpoint [GET Characters](#get-characters) `includes`=**species** will include [character](#character-type).species in the response). Also can contains multiple includes separated by comma (ex: `includes`=**species**,**subspecies**)
>
> `page` and `count` are used for pagination. In SQL `page` is `OFFSET` and `count` is `LIMIT`
>
> `sortBy` and `sortDir` are used for sorting. In SQL `sortBy` is `ORDER BY` and `sortDir` is `ASC` or `DESC` after `ORDER BY`. `sortBy` also can be separated by comma, SQL allow it (ex: `sortBy`=**status**,**name**)
>
> `filterBy` and `q` are used for filtering. In SQL you can to filter with `WHERE`, `AND`, and `OR` keywords. `filterBy` is used for dinamically filtering, you can define a default `filterBy` (ex: in [Character](#character-type), `.name` will be the default `filterBy`). `filterBy` also can be separated by comma for multiple filtering (ex: `filterBy`=**status**,**name** and `q`=`Alive`,`Rick`)

> Remember always to validate the user input, is not a good idea to pass to the database an invalid key to `ORDER BY` for example

> The property **ranged** in the response meons that you need to define other endpoint like `<root endpoint>/:range` where `range` will be the range applied to the data. Implement the follow features to range.
>
> - separate by comma to select specific entities or add more ranges. Examples:
>   - `1,2,3` will select the entities `1`, `2`, and `3`
>   - `1..3` will select the entities `1`, `2`, and `3`
>   - `1,3..5` will select the entities `1`, `3`, `4`, and `5`
> - dot dot (or slice range) to select a list of elements from `start` to `end`. Examples:
>   - `1..3` will select the entities `1`, `2` and `3`
>   - `..3` will select the entities lower and equal than `3`
>   - `3..` will select the entities greater and equal than `3`
>   - `..` will select all entities, useless for the end user. It's the default when user calls the `<root endpoint>`
> - In `DELETE` endpoints, ranged allows to delete multiple data at same time. **_By careful_**.

> - List of `<Type>` means, an array of `<Type>` elements
> - Partial `<Type>` means, the type but without auto-generated fields like **id**, **created_by**, **created_at**, and **updated_at**
> - Hard Partial `<Type>` mains, same of Partial but any property is required

### GET Characters

- **Request**:

  - **ranged**
  - **Method**: `GET`
  - **Path**: `/characters`
  - **query params**: `includes`, `page`, `count`, `sortBy`, `sortDir`, `filterBy`, `q`

- **Response**:

  - **status**: `200`
  - **body**:

  | Key      | Type                                 | Nullable |
  | -------- | ------------------------------------ | -------- |
  | **meta** | [ResponseMeta](#responsemeta)        | `false`  |
  | **data** | List of [Character](#character-type) | `false`  |

### GET Character

> If character does not exists, respond with status code `404`

- **Request**:

  - **Method**: `GET`
  - **Path**: `/characters/:id`
  - **query params**: `includes`

- **Response**:

  - **status**: `200`
  - **body**:

  | Key      | Type                         | Nullable |
  | -------- | ---------------------------- | -------- |
  | **data** | [Character](#character-type) | `false`  |

### Create Character

- **Request**:

  - **Method**: `POST`
  - **Path**: `/characters`
  - **query params**: `includes`
  - **body**:

  | Key      | Type                                 | Nullable |
  | -------- | ------------------------------------ | -------- |
  | **data** | Partial [Character](#character-type) | `false`  |

- **Response**:

  - **status**: `201`
  - **body**:

  | Key      | Type                         | Nullable |
  | -------- | ---------------------------- | -------- |
  | **data** | [Character](#character-type) | `false`  |

### Update Character

Replace old character with a new character. The id will be the same, so technically is a full update.

- **Request**:

  - **Method**: `PUT`
  - **Path**: `/characters/:id`
  - **body**:

  | Key  | Type                                 | Nullable |
  | ---- | ------------------------------------ | -------- |
  | data | Partial [Character](#character-type) | `false`  |

- **Response**:

  - **status**: `204`

### Parcial Update Character

Just update the submitted properties. It's more efficient. An example of when it is usefull, to update only the character name (no need to validate the rest of properties because they won't be updated)

- **Request**:

  - **Method**: `PATCH`
  - **Path**: `/characters/:id`
  - **body**:

  | Key  | Type                                      | Nullable |
  | ---- | ----------------------------------------- | -------- |
  | data | Hard Partial [Character](#character-type) | `false`  |

- **Response**:

  - **status**: `204`

### Delete Character

- **Request**:

  - **ranged**
  - **Method**: `DELETE`
  - **Path**: `/characters/:id`

- **Response**:

  - **status**: `204`

### GET List Character's Species

- **Request**:

  - **ranged**
  - **Method**: `GET`
  - **Path**: `/character/species`
  - **query params**: `includes`, `page`, `count`, `sortBy`, `sortDir`, `filterBy`, `q`

- **Response**:

  - **status**: `200`
  - **body**:

  | Key      | Type                                                 | Nullable |
  | -------- | ---------------------------------------------------- | -------- |
  | **meta** | [ResponseMeta](#responsemeta)                        | `false`  |
  | **data** | List of [Character Species](#character-species-type) | `false`  |

### GET Character's Species

> If character's species does not exists, respond with status code `404`

- **Request**:

  - **Method**: `GET`
  - **Path**: `/character/species/:id`

- **Response**:

  - **status**: `200`
  - **body**:

  | Key      | Type                                         | Nullable |
  | -------- | -------------------------------------------- | -------- |
  | **data** | [Character Species](#character-species-type) | `true`   |

### Create Character's Species

- **Request**:

  - **Method**: `POST`
  - **Path**: `/character/species`
  - **body**:

  | Key      | Type                                                 | Nullable |
  | -------- | ---------------------------------------------------- | -------- |
  | **data** | Partial [Character Species](#character-species-type) | `false`  |

- **Response**:

  - **status**: `201`
  - **body**:

  | Key      | Type                                         | Nullable |
  | -------- | -------------------------------------------- | -------- |
  | **data** | [Character Species](#character-species-type) | `false`  |

### Update Character's Species

- **Request**:

  - **Method**: `PUT`
  - **Path**: `/character/species/:id`
  - **body**:

  | Key  | Type                                                 | Nullable |
  | ---- | ---------------------------------------------------- | -------- |
  | data | Partial [Character Species](#character-species-type) | `false`  |

- **Response**:

  - **status**: `204`

### Parcial Update Character's Species

- **Request**:

  - **Method**: `PATCH`
  - **Path**: `/character/species/:id`
  - **body**:

  | Key  | Type                                                      | Nullable |
  | ---- | --------------------------------------------------------- | -------- |
  | data | Hard Partial [Character Species](#character-species-type) | `false`  |

- **Response**:

  - **status**: `204`

### Delete Character's Species

- **Request**:

  - **ranged**
  - **Method**: `DELETE`
  - **Path**: `/character/species/:id`

- **Response**:

  - **status**: `204`

### GET List Character's Subspecies

- **Request**:

  - **ranged**
  - **Method**: `GET`
  - **Path**: `/character/subspecies`
  - **query params**: `includes`, `page`, `count`, `sortBy`, `sortDir`, `filterBy`, `q`

- **Response**:

  - **status**: `200`
  - **body**:

  | Key      | Type                                                       | Nullable |
  | -------- | ---------------------------------------------------------- | -------- |
  | **meta** | [ResponseMeta](#responsemeta)                              | `false`  |
  | **data** | List of [Character Subspecies](#character-subspecies-type) | `false`  |

### GET Character's Subspecies

> If character's species does not exists, respond with status code `404`

- **Request**:

  - **Method**: `GET`
  - **Path**: `/character/subspecies/:id`

- **Response**:

  - **status**: `200`
  - **body**:

  | Key      | Type                                               | Nullable |
  | -------- | -------------------------------------------------- | -------- |
  | **data** | [Character Subspecies](#character-subspecies-type) | `true`   |

### Create Character's Subspecies

- **Request**:

  - **Method**: `POST`
  - **Path**: `/character/subspecies`
  - **body**:

  | Key      | Type                                                       | Nullable |
  | -------- | ---------------------------------------------------------- | -------- |
  | **data** | Partial [Character Subspecies](#character-subspecies-type) | `false`  |

- **Response**:

  - **status**: `201`
  - **body**:

  | Key      | Type                                               | Nullable |
  | -------- | -------------------------------------------------- | -------- |
  | **data** | [Character Subspecies](#character-subspecies-type) | `false`  |

### Update Character's Subspecies

- **Request**:

  - **Method**: `PUT`
  - **Path**: `/character/subspecies/:id`
  - **body**:

  | Key  | Type                                                       | Nullable |
  | ---- | ---------------------------------------------------------- | -------- |
  | data | Partial [Character Subspecies](#character-subspecies-type) | `false`  |

- **Response**:

  - **status**: `204`

### Parcial Update Character's Subspecies

- **Request**:

  - **Method**: `PATCH`
  - **Path**: `/character/subspecies/:id`
  - **body**:

  | Key  | Type                                                            | Nullable |
  | ---- | --------------------------------------------------------------- | -------- |
  | data | Hard Partial [Character Subspecies](#character-subspecies-type) | `false`  |

- **Response**:

  - **status**: `204`

### Delete Character's Subspecies

- **Request**:

  - **ranged**
  - **Method**: `DELETE`
  - **Path**: `/character/subspecies/:id`

- **Response**:

  - **status**: `204`
