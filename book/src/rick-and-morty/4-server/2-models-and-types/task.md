# Models and Types

## Tasks

- [ ] Define [Responses Types](#responses-types)
  - [ ] Define [ResponseMeta Type](#responsemeta-type)
  - [ ] Define [ResponseError Type](#responseerror-type)
  - [ ] Define [ResponseSuccess Type](#responsesuccess-type)
- [ ] Define [Models](#models)
  - [ ] [User model](#user-model)
  - [ ] [Character Model](#character-model)
  - [ ] [Character Species Model](#character-species-model)
  - [ ] [Character Type Model](#character-type-model)
  - [ ] [Location Model](#location-model)
  - [ ] [Location Type Model](#location-type-model)
  - [ ] [Location Dimension Model](#location-dimension-model)
  - [ ] [Episode Model](#episode-model)
- [ ] Add `/images` static route to serve character's images

## Responses Types

### ResponseMeta Type

| Key           | Type                                   |
| ------------- | -------------------------------------- |
| **paging**    | [Paging Meta](#paging-meta-type)       |
| **sorting**   | [Sorting Meta](#sorting-meta-type)     |
| **filtering** | [Filtering Meta](#filtering-meta-type) |
| **range**     | [Renge](#range-meta-type)              |

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

## Model conventions

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

## Models

### User model

> This model is temporary, to do less refactoring in the future.

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
