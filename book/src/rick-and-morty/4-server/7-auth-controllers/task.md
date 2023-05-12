# Auth Controllers

> Draft

## Tasks

- `/auth` routes: [Authentication](#authentication)
  - [ ] `/in` - [Sign In](#sign-in)
  - [ ] `/out` - [Sign Out](#sign-out)
  - [ ] `/refresh` - [Refresh Token](#refresh-token)
  - [ ] `/challenge` - [Request Challenge](#request-challenge)
- [ ] [Authorization](#authorization)

## Some things to consider

> To avoid confusion about **Authentication** and **Authorization**:
>
> - Authentication means that the user logs into the server and receives a token to use for authorization
> - Authorization means that the endpoints being accessed are only available to specific roles

> I recommend using cookies when interacting only with a web client.
> If you have more type of clients it is better to use [Bearer Authentication](https://datatracker.ietf.org/doc/html/rfc6750)
>
> Maybe you can implement both and decide which one to use based on the user agent.

## Authentication

### Sign In

### Sign Out

### Refresh Token

### Request Challenge

## Authorization

Implement authorization to all responses with **request**.**protected**.

> Is a good idea also has user roles like **admin**, **editor**, **user**. For example
>
> - **admin** can manage [User](#user-model)s but **editor** and **user** can't
> - **editor** and **admin** can manage the creation, update, and deletion of entities but **user** can't
> - **user** can only read entities that are not [User](#user-model)s and its own [User](#user-model) information
>
> The roles are not limited to that, you can define some role for specific tasks if you want, the limit is your need.
