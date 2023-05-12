# Server setup

## Tasks

- [ ] Setup the server project
- [ ] Define [Controllers features](#controllers-features) meta types
  - [ ] [Paging Meta Type](#paging-meta-type)
  - [ ] [Sorting Meta Type](#sorting-meta-type)
  - [ ] [Filtering Meta Type](#filtering-meta-type)
  - [ ] [Range Meta Type](#range-meta-type)

## Restful knowledge

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

> These are all the status codes you will need in the most common projects.
>
> Documentation: <https://developer.mozilla.org/en-US/docs/Web/HTTP/Status>

### Methods table

| Method     | Status Code    | When                                                           |
| ---------- | -------------- | -------------------------------------------------------------- |
| **GET**    | `200`          | Read a resource or a list of resources                         |
| **POST**   | `201`          | Create a new resource                                          |
| **PUT**    | `201` \| `204` | Complete update of a resource or create it if it doesn't exist |
| **PATCH**  | `204`          | Update parts of a resource                                     |
| **DELETE** | `204`          | Delete a resources                                             |

> Most **CRUD** implementations use **POST** to create and PUT to update, o just **POST** for both operations.
>
> This standard es a bit more detailed. It is also more correct to use **PATCH** for a partial update of a resource.
>
> For example: user never updates auto-generated fields and in most cases only updates one or two field)

> These are all the methods you will need in the most common projects.
>
> Documentation: <https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods>

### Endpoint conventions

> It is highly recommended to version the **API** so all routes should be based on the path `/api/<version>` or the subdomain `api.<domain>/<version>`.
>
> It is important to version the API so that you can make major changes without affecting existing clients.

> Like tables, all paths that represent a table in the database must also be plural.
>
> **Base path format**:
>
> - `/<type>` where `<type>` is the name of the type in lowercase and plural
> - If type is part of another, `/<main-type>/<type>` where `<main-type>` is the name of the main type in lowercase
>
> **Examples**:
>
> - `Character` **->** `/characters`
> - `CharacterType` **->** `/character/types`

### Endpoint types table

| Type                             | Path                      | Method   | Permissions   | Request               | Response                                         | Status code                                                                                     |
| -------------------------------- | ------------------------- | -------- | ------------- | --------------------- | ------------------------------------------------ | ----------------------------------------------------------------------------------------------- |
| Get `<Type>` List                | `<base>`                  | `GET`    |               |                       | List of `<Type>`                                 | `200` for successful responses                                                                  |
| Get `<Type>`                     | `<base>/:id`              | `GET`    |               |                       | `<Type>`                                         | `200` for successful responses <br> `404` if entity does not exist                              |
| Get ranged `<Type>` List         | `<base>/<range>`          | `GET`    |               |                       | List of `<Type>`                                 | `200` for successful responses                                                                  |
| Get deleted `<Type>` List        | `<base>/deleted`          | `GET`    | **protected** |                       | List of `<Type>` marked as **deleted**           | `200` for successful responses                                                                  |
| Get ranged deleted `<Type>` List | `<base>/deleted/<ranged>` | `GET`    | **protected** |                       | List of `<Type>` marked as **deleted**           | `200` for successful responses                                                                  |
| Create `<Type>`                  | `<base>`                  | `POST`   | **protected** | Partial `<Type>`      | `<Type>`                                         | `201` for successful creation <br> `400` for bad request body <br> `409` if entity exists       |
| Put `<Type>`                     | `<base>/:id`              | `PUT`    | **protected** | Partial `<Type>`      | `<Type>` for creation <br> empty body for update | `201` for successful creation <br> `204` for successful update <br> `400` for bad request body  |
| Update `<Type>`                  | `<base>/:id`              | `PATCH`  | **protected** | Hard Partial `<Type>` |                                                  | `204` for successful update <br> `404` if entity does not exist <br> `400` for bad request body |
| Delete `<Type>`                  | `<base>/:id`              | `DELETE` | **protected** |                       |                                                  | `204` for successful deletes <br> `404` if entity does not exist                                |
| Delete ranged `<Type>` List      | `<base>/<ranged>`         | `DELETE` | **protected** |                       |                                                  | `204` for successful deletes <br> `404` if entity does not exist                                |
| Purge `<Type>`                   | `<base>/purge/:id`        | `DELETE` | **protected** |                       |                                                  | `204` for successful purge <br> `404` if entity does not exist                                  |
| Purge ranged `<Type>` List       | `<base>/purge/<ranged>`   | `DELETE` | **protected** |                       |                                                  | `204` for successful purge                                                                      |

> - `<base>` is the path explained in [Endpoint standards](#endpoint-standards)
> - `<range>` is the [Range](#range) implementation
> - **Response** column is the **data** property for the [ResponseSuccess Type](../2-models-and-types/task.md#responsesuccess-type). Empty cell means an empty body in the response.
> - List of `<Type>` means, an array of `<Type>` elements
> - Partial `<Type>` means, the type but without auto-generated fields (all common fields except the **name** field)
> - Hard Partial `<Type>` means, same of Partial but any property is required

> **[Status Codes](#status-code-table) conventions**
>
> - All **protected** routes respond `401` if requests do not have valid credentials
> - All **protected** routes respond `403` if the credentials are valid but do not have permission to access the current route
> - All routes return `500` if an unknown error occurs
> - All routes by default respond `501` if are not fully implemented
> - All routes respond `405` if the requested method is not implemented in the accessed route
> - Otherwise, it returns the specified status code

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

## Controllers features

### Paging

Use `page` and `count` query params for pagination.
In SQL `page` is `OFFSET` and `count` is `LIMIT`

#### Paging Meta Type

| Key       | Type      | Comment                |
| --------- | --------- | ---------------------- |
| **total** | `Integer` | Total count of records |
| **page**  | `Integer` | Current page           |
| **count** | `Integer` | Record count           |

### Sorting

Use `sortBy` and `sortDir` for sorting.
In SQL `sortBy` is `ORDER BY` and `sortDir` is `ASC` or `DESC` after `ORDER BY`.

> - `sortBy` can also contain multiple elements separated by comma, SQL allow it (ex: `sortBy`=**status**,**name**)
> - you can define a default `sortBy` (ex: in [Character](../2-models-and-types/task.md#character-model), `.name` will be the default `sortBy`).
> - the default `sortDir` is `ASC`
> - If the user sends multiple `sortBy` and a `sortDir` query params, it means that `sortDir` is used for all `sortBy`

#### Sorting Meta Type

| Key     | Type                                   |
| ------- | -------------------------------------- |
| **by**  | `String`                               |
| **dir** | [Sort Direction](#sort-direction-enum) |

#### Sort Direction Enum

- `ASC`
- `DESC`

### Filtering

Use `filterBy` and `q` for filtering.
In SQL you can to filter with `WHERE`, `AND`, and `OR` keywords.

> - `filterBy` is used for dynamically filtering
> - you can define a default `filterBy` (ex: in [Character](../2-models-and-types/task.md#character-model), `.name` will be the default `filterBy`)
> - `filterBy` also can be separated by comma for multiple filtering (ex: `filterBy`=**status**,**name** and `q`=`Alive`,`Rick`)
> - If the user sends multiple `filterBy` and a `q` query params, it means that `q` is used for all `filterBy`

#### Filtering Meta Type

| Key    | Type      |
| ------ | --------- |
| **by** | `Integer` |
| **q**  | `Integer` |

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
- Skip non-existent identifiers. Don't return an error, if there is no valid id, just return an empty list.

#### Range Meta Type

| Key      | Type      |
| -------- | --------- |
| **from** | `Integer` |
| **to**   | `Integer` |

### Includes query param

- The `includes` query params will be used to include the entity of a reference.
- Also can contains multiple includes separated by comma.

- In endpoint `GET Character List` `includes`=**species,type** will include [Character Species](../2-models-and-types/task.md#character-species-model) and [Character Type](../2-models-and-types/task.md#character-type-model) in the response. By default, all reference fields are null.
