# Server

> **Draft**

## Tasks

- [ ] [Models](#models)
  - [ ] [User Model](#user-model)
  - [ ] [Character Model](#character-model)
  - [ ] [Character Species Model](#character-species-model)
  - [ ] [Character Type Model](#character-type-model)
  - [ ] [Location Model](#location-model)
  - [ ] [Location Type Model](#location-type-model)
  - [ ] [Location Dimension Model](#location-dimension-model)
  - [ ] [Episode Model](#episode-model)
- [ ] [Controllers](#controllers)
  - [ ] `/images`, static route to serve character's images
  - [ ] `/users` routes:
    - [ ] [Get User List](#get-user-list)
    - [ ] [Get User](#get-user)
    - [ ] [Create User](#create-user)
    - [ ] `/:id` routes:
      - [ ] [Update User](#update-user)
      - [ ] [Patch User](#patch-user)
      - [ ] [Delete User](#delete-user)
  - [ ] `/characters` routes:
    - [ ] [Get Character List](#get-character-list)
    - [ ] [Get Character](#get-character)
    - [ ] [Create Character](#create-character)
    - [ ] `/:id` routes:
      - [ ] [Update Character](#update-character)
      - [ ] [Patch Character](#patch-character)
      - [ ] [Delete Character](#delete-character)
  - [ ] `/character`
    - [ ] `/species` routes:
      - [ ] [Get Character Species List](#get-character-species-list)
      - [ ] [Get Character Species](#get-character-species)
      - [ ] [Create Character Species](#create-character-species)
      - [ ] `/:id` routes:
        - [ ] [Update Character Species](#update-character-species)
        - [ ] [Patch Character Species](#patch-character-species)
        - [ ] [Delete Character Species](#delete-character-species)
    - [ ] `/types` routes:
      - [ ] [Get Character Type List](#get-character-type-list)
      - [ ] [Get Character Type](#get-character-type)
      - [ ] [Create Character Type](#create-character-type)
      - [ ] `/:id` routes:
        - [ ] [Update Character Type](#update-character-type)
        - [ ] [Patch Character Type](#patch-character-type)
        - [ ] [Delete Character Type](#delete-character-type)
  - [ ] `/locations` routes:
    - [ ] [Get Location List](#get-locations-list)
    - [ ] [Get Location](#get-locations)
    - [ ] [Create Location](#create-locations)
    - [ ] `/:id` routes:
      - [ ] [Update Location](#update-locations)
      - [ ] [Patch Location](#patch-locations)
      - [ ] [Delete Location](#delete-locations)
  - [ ] `/location`
    - [ ] `/type` routes:
      - [ ] [Get Location Type List](#get-locations-type-list)
      - [ ] [Get Location Type](#get-locations-type)
      - [ ] [Create Location Type](#create-locations-type)
      - [ ] `/:id` routes:
        - [ ] [Update Location Type](#update-locations-type)
        - [ ] [Patch Location Type](#patch-locations-type)
        - [ ] [Delete Location Type](#delete-locations-type)
    - [ ] `/dimension` routes:
      - [ ] [Get Location Dimension List](#get-location-dimension-list)
      - [ ] [Get Location Dimension](#get-location-dimension)
      - [ ] [Create Location Dimension](#create-location-dimension)
      - [ ] `/:id` routes:
        - [ ] [Update Location Dimension](#update-location-dimension)
        - [ ] [Patch Location Dimension](#patch-location-dimension)
        - [ ] [Delete Location Dimension](#delete-location-dimension)
  - [ ] `/episodes` routes:
    - [ ] [Get Episode List](#get-episode-list)
    - [ ] [Get Episode](#get-episode)
    - [ ] [Create Episode](#create-episode)
    - [ ] `/:id` routes:
      - [ ] [Update Episode](#update-episode)
      - [ ] [Patch Episode](#patch-episode)
      - [ ] [Delete Episode](#delete-episode)
  - [ ] [Implement to all list responses](#implement-to-all-list-responses)
    - [ ] [Pagination](#paging)
    - [ ] [Sorting](#sorting)
    - [ ] [Filtering](#filtering)
    - [ ] [Range](#range)
  - [ ] [Implement includes query param to all responses with optional references](#includes-query-param)
- [ ] [Implement authentication routes](#authentication)
  - `/sign` routes:
    - [ ] `/in` - [Sign In](#sign-in)
    - [ ] `/out` - [Sign Out](#sign-out)
    - [ ] `/refresh` - [Refresh Sign](#refresh-sign)
    - [ ] `/challenge` - [Sign Challenge](#sign-challenge)
- [ ] [Implement authorization to all responses with it as a requirement](#authorization)

## Some things to consider

> All API routes are under `/api/<version>` or as subdomain `api.<domain>/<version>`.
> It's important versioning the API to be able to make breaking changes without affecting current clients
>
> In this practice you can use `/api/v1` as the root of all api endpoints.
> The endpoints don't contain this fragment in their path to avoid redundancy.

> To avoid confusion about **Authentication** and **Authorization**:
>
> - Authentication means that the user logs into the server and receives a token to use for authorization
> - Authorization means that the endpoints being accessed are only available to specific roles

> I recommend using cookies when interacting only with a web client.
> If you have more type of clients it is better to use [Bearer Authentication](https://datatracker.ietf.org/doc/html/rfc6750)
>
> Maybe you can implement both and decide which one to use based on the user agent.

### Status Code table

| Status Code                                                         | When                                                                                                     |
| ------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------- |
| [200](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/200) | All endpoints succeeded unless you specify another status code (ex: `201` for creation)                  |
| [201](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/201) | Endpoint ends without errors and creates a new entity successfully <br> _Useful when creating an entity_ |
| [204](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/204) | Endpoint ends without error but response is empty <br> _Useful when updating or deleting an entity_      |
| [400](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/400) | User sends wrong request body or query parameter                                                         |
| [401](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/401) | The request to a protected endpoint does not have valid authentication credentials                       |
| [403](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/403) | User sends request with invalid authentication credentials to a protected endpoint                       |
| [404](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/404) | User tries to access to a non-defined endpoint                                                           |
| [405](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/405) | User tries to access to a non-defined method                                                             |
| [409](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/409) | The user submits a form and the data exists in the database. <br> _Useful when preventing duplicates_    |
| [500](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/500) | An unexpected error occurs on the server.                                                                |
| [501](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status/501) | Endpoint is not implemented <br> _Useful to define all endpoints what will be implemented_               |

## Models

> All fields that ends with **\_id** need to have a field with the same name but without the **\_id** and it's nullable
>
> For example:
>
> | Key          | Type      | Nullable |
> | ------------ | --------- | -------- |
> | **id**       | `Integer` | `false`  |
> | **field_id** | `Integer` | `false`  |
>
> In code the model is:
>
> | Key          | Type      | Nullable |
> | ------------ | --------- | -------- |
> | **id**       | `Integer` | `false`  |
> | **field_id** | `Integer` | `false`  |
> | **field**    | `<Type>`  | `true`   |

### Common fields for all Models

> - Set **id** and **name** as the first fields and the **rest** of the fields as the last fields of all models
> - Empty models only have common fields

| Key               | Type       | Nullable | Reference           |
| ----------------- | ---------- | -------- | ------------------- |
| **id**            | `Integer`  | `false`  |                     |
| **name**          | `String`   | `false`  |                     |
| **created_by_id** | `Integer`  | `false`  | [user](#user-model) |
| **updated_by_id** | `Integer`  | `false`  | [user](#user-model) |
| **deleted_by_id** | `Integer`  | `true`   | [user](#user-model) |
| **created_at**    | `DateTime` | `false`  |                     |
| **updated_at**    | `DateTime` | `false`  |                     |
| **deleted_at**    | `DateTime` | `true`   |                     |

### User Model

| Key | Type | Nullable |
| --- | ---- | -------- |

### Character Model

| Key             | Type                                       | Nullable | Reference                                     |
| --------------- | ------------------------------------------ | -------- | --------------------------------------------- |
| **status**      | [Character Status](#character-status-enum) | `false`  |                                               |
| **gender**      | [Character Gender](#character-gender-enum) | `false`  |                                               |
| **species_id**  | `Integer`                                  | `false`  | [Character Species](#character-species-model) |
| **type_id**     | `Integer`                                  | `true`   | [Character Type](#character-type-model)       |
| **location_id** | `Integer`                                  | `true`   | [Location](#location-model)                   |
| **origin_id**   | `Integer`                                  | `true`   | [Location](#location-model)                   |
| **image**       | `String`                                   | `false`  |                                               |
| **from_api**    | `Boolean`                                  | `false`  |                                               |

### Character Status Enum

- `Alive`
- `Dead`
- `unknown`

### Character Gender Enum

- `Female`
- `Male`
- `Genderless`
- `unknown`

### Character Species Model

| Key | Type | Nullable |
| --- | ---- | -------- |

### Character Type Model

| Key | Type | Nullable |
| --- | ---- | -------- |

### Location Model

| Key              | Type      | Nullable | Reference                                       |
| ---------------- | --------- | -------- | ----------------------------------------------- |
| **type_id**      | `Integer` | `true`   | [Location Type](#location-type-model)           |
| **dimension_id** | `Integer` | `true`   | [Location Dimension](#location-dimension-model) |
| **from_api**     | `Boolean` | `false`  |                                                 |

### Location Type Model

| Key | Type | Nullable |
| --- | ---- | -------- |

### Location Dimension Model

| Key | Type | Nullable |
| --- | ---- | -------- |

### Episode Model

| Key          | Type       | Nullable |
| ------------ | ---------- | -------- |
| **season**   | `Integer`  | `false`  |
| **episode**  | `Integer`  | `false`  |
| **air_date** | `DateTime` | `false`  |
| **from_api** | `Boolean`  | `false`  |

## Implement to all list responses

All responses that respond to a list of records must implement these features.

### Paging

Use `page` and `count` query params for pagination.
In SQL `page` is `OFFSET` and `count` is `LIMIT`

#### Paging Meta Type

| Key       | Type      | Nullable | Comment                |
| --------- | --------- | -------- | ---------------------- |
| **total** | `Integer` | `false`  | Total count of records |
| **page**  | `Integer` | `false`  | Current page           |
| **count** | `Integer` | `false`  | Record count           |

### Sorting

Use `sortBy` and `sortDir` for sorting.
In SQL `sortBy` is `ORDER BY` and `sortDir` is `ASC` or `DESC` after `ORDER BY`.

> - `sortBy` can also contain multiple elements separated by comma, SQL allow it (ex: `sortBy`=**status**,**name**)
> - you can define a default `sortBy` (ex: in [Character](#character-model), `.name` will be the default `sortBy`).
> - the default `sortDir` is `ASC`
> - If the user sends multiple `sortBy` and a `sortDir` query params, it means that `sortDir` is used for all `sortBy`

#### Sorting Meta Type

| Key     | Type                                   | Nullable | Comment |
| ------- | -------------------------------------- | -------- | ------- |
| **by**  | `String`                               | `false`  |         |
| **dir** | [Sort Direction](#sort-direction-enum) | `false`  |         |

#### Sort Direction Enum

- `ASC`
- `DESC`

### Filtering

Use `filterBy` and `q` for filtering.
In SQL you can to filter with `WHERE`, `AND`, and `OR` keywords.

> - `filterBy` is used for dynamically filtering
> - you can define a default `filterBy` (ex: in [Character](#character-model), `.name` will be the default `filterBy`)
> - `filterBy` also can be separated by comma for multiple filtering (ex: `filterBy`=**status**,**name** and `q`=`Alive`,`Rick`)
> - If the user sends multiple `filterBy` and a `q` query params, it means that `q` is used for all `filterBy`

#### Filtering Meta Type

| Key    | Type      | Nullable | Comment |
| ------ | --------- | -------- | ------- |
| **by** | `Integer` | `false`  |         |
| **q**  | `Integer` | `false`  |         |

### Range

The property **ranged** in the response means that you need to define other endpoint like `<root endpoint>/:range` where `range` will be the range applied to the data.

> This feature is optional
>
> Ranges are useful for databases with ordered entities, but if you use `uuid` as `PRIMARY KEY` you cannot use this feature directly.
> May need to define another field that allows this feature.

#### Range features:

- separate by comma to select specific entities or add more ranges. Examples:
  - `1,2,3` will select the entities `1`, `2`, and `3`
  - `1..3` will select the entities `1`, `2`, and `3`
  - `1,3..5` will select the entities `1`, `3`, `4`, and `5`
- dot dot (or slice range) to select a list of elements from `start` to `end`. Examples:
  - `1..3` will select the entities `1`, `2` and `3`
  - `..3` will select the entities lower and equal than `3`
  - `3..` will select the entities greater and equal than `3`
  - `..` will select all entities, useless for the end user. It's the default when user calls the `<root endpoint>`
- In `DELETE` endpoints, ranged allows to delete multiple data at same time. **_By careful_**.

#### Range Meta Type

| Key      | Type      | Nullable | Comment |
| -------- | --------- | -------- | ------- |
| **from** | `Integer` | `false`  |         |
| **to**   | `Integer` | `false`  |         |

### Includes query param

The `includes` query params will be used to include the entity of a reference.
Also can contains multiple includes separated by comma.

- In endpoint [GET Character List](#get-character-list) `includes`=**species,type** will include [Character Species](#character-species-model) and [Character Type](#character-type-model) in the response. By default, all reference fields are null.

## Responses Types

### ResponseMeta Type

| Key           | Type                                   | Nullable |
| ------------- | -------------------------------------- | -------- |
| **paging**    | [Paging Meta](#paging-meta-type)       | `false`  |
| **sorting**   | [Sorting Meta](#sorting-meta-type)     | `false`  |
| **filtering** | [Filtering Meta](#filtering-meta-type) | `false`  |
| **range**     |                                        |          |

### ResponseError Type

- When status code is user error (4xx) or server error (5xx)

| Key        | Type      | Nullable | Comment                                                                                                    |
| ---------- | --------- | -------- | ---------------------------------------------------------------------------------------------------------- |
| **status** | `Integer` | `false`  | Status code of the response                                                                                |
| **error**  | `String`  | `false`  | Error message based on status code (ex: for 400, **error**=`"Bad Request"``)                               |
| **reason** | `String`  | `false`  | The main reason of the error (ex: for 400 and bad ranged input, **reason**=`"Invalid ranged query param"`) |
| **form**   | `Object`  | `true`   | If the endpoint will respond to a form, use this property to specify the error of each field individually  |

### ResponseSuccess Type

- When status code is success 2xx

| Key      | Type                               | Nullable | Comment                           |
| -------- | ---------------------------------- | -------- | --------------------------------- |
| **meta** | [ResponseMeta](#responsemeta-type) | `true`   | Only used when **data** is a list |
| **data** | `<Type>`                           | `false`  | The **data** to be served         |

## Controllers

> **Response**.**data** is the **data** property for the [ResponseSuccess Type](#responsesuccess-type)

> - List of `<Type>` means, an array of `<Type>` elements
> - Partial `<Type>` means, the type but without auto-generated fields (all common fields except the **name** field)
> - Hard Partial `<Type>` means, same of Partial but any property is required

### Get User List

- **Request**:

  - **ranged**
  - **Method**: `GET`
  - **Path**: `/users`
  - **query params**: `includes`, `page`, `count`, `sortBy`, `sortDir`, `filterBy`, `q`

- **Response**:

  - **status**: `200`
  - **data**: List of [User](#user-model)

### Get User

- **Request**:

  - **Method**: `POST`
  - **Path**: `/users`
  - **query params**: `includes`
  - **body**: Partial [User](#user-model)

- **Response**:

  - **status**: `201`
  - **data**: [User](#user-type)

### Create User

### Update User

### Patch User

### Delete User

### Get Character List

- **Request**:

  - **ranged**
  - **Method**: `GET`
  - **Path**: `/characters`
  - **query params**: `includes`, `page`, `count`, `sortBy`, `sortDir`, `filterBy`, `q`

- **Response**:

  - **status**: `200`
  - **data**: List of [Character](#character-model)

### Get Character

### Create Character

### Update Character

### Patch Character

### Delete Character

### Get Character Species List

- **Request**:

  - **ranged**
  - **Method**: `GET`
  - **Path**: `/character/species`
  - **query params**: `includes`, `page`, `count`, `sortBy`, `sortDir`, `filterBy`, `q`

- **Response**:

  - **status**: `200`
  - **data**: List of [Character Species](#character-species-model)

### Get Character Species

### Create Character Species

### Update Character Species

### Patch Character Species

### Delete Character Species

### Get Character Type List

- **Request**:

  - **ranged**
  - **Method**: `GET`
  - **Path**: `/character/types`
  - **query params**: `includes`, `page`, `count`, `sortBy`, `sortDir`, `filterBy`, `q`

- **Response**:

  - **status**: `200`
  - **data**: List of [Character Type](#character-type-model)

### Get Character Type

### Create Character Type

### Update Character Type

### Patch Character Type

### Delete Character Type

### Get Location List

- **Request**:

  - **ranged**
  - **Method**: `GET`
  - **Path**: `/locations`
  - **query params**: `includes`, `page`, `count`, `sortBy`, `sortDir`, `filterBy`, `q`

- **Response**:

  - **status**: `200`
  - **data**: List of [Location](#location-model)

### Get Location

### Create Location

### Update Location

### Patch Location

### Delete Location

### Get Location Type List

- **Request**:

  - **ranged**
  - **Method**: `GET`
  - **Path**: `/location/types`
  - **query params**: `includes`, `page`, `count`, `sortBy`, `sortDir`, `filterBy`, `q`

- **Response**:

  - **status**: `200`
  - **data**: List of [Location Type](#location-type-model)

### Get Location Type

### Create Location Type

### Update Location Type

### Patch Location Type

### Delete Location Type

### Get Location Dimension List

- **Request**:

  - **ranged**
  - **Method**: `GET`
  - **Path**: `/location/dimensions`
  - **query params**: `includes`, `page`, `count`, `sortBy`, `sortDir`, `filterBy`, `q`

- **Response**:

  - **status**: `200`
  - **data**: List of [Location Dimension](#location-dimension-model)

### Get Location Dimension

### Create Location Dimension

### Update Location Dimension

### Patch Location Dimension

### Delete Location Dimension

### Get Episode List

- **Request**:

  - **ranged**
  - **Method**: `GET`
  - **Path**: `/episodes`
  - **query params**: `includes`, `page`, `count`, `sortBy`, `sortDir`, `filterBy`, `q`

- **Response**:

  - **status**: `200`
  - **data**: List of [Episode](#episode-model)

### Get Episode

### Create Episode

### Update Episode

### Patch Episode

### Delete Episode

## Authentication

### Sign In

### Sign Out

### Refresh Sign

### Challenge

## Authorization

Implement authorization to all responses with it as a requirement.

> Is a good idea also has user roles like **admin**, **editor**, **user**. For example
>
> - **admin** can manage [User](#user-model)s but **editor** and **user** can't
> - **editor** and **admin** can manage the creation, update, and deletion of entities but **user** can't
> - **user** can only read entities that are not [User](#user-model)s and its own [User](#user-model) information
>
> The roles are not limited to that, you can define some role for specific tasks if you want, the limit is your need.
