# Project Setup and download data

## Overview

This project is to practice being a full-stack developer by doing a simple but complete project that will include:

- Database administration - You will write the database schema, manage migrations and learn some important concepts when working with SQL.
- Back-end - You will write a web server following some best practices and learn how to structure a restful api for simple but powerful access, graphql for mobile deviced or client with limited access, and grpc inter-server communitation.
- Front-end - After building the back-end you will write a simple front-end similar to the [Rick and Morty api](https://rickandmortyapi.com/) but with an administration page and more useful stuff.

I choose the [Rick and Morty api](https://rickandmortyapi.com/) because it's a good database that allows you to learn about SQL references. And the most important reason: it already exists, you don't need to create a database from scratch (is very difficult to create a lot of consistent data)

To also practice with git, I recommend making each feature in a separate branch and each part of a feature in a separate commit, and when you complete a whole page, merge the branch into the development branch.

Yo can to use [httpie](https://httpie.io/) to test your api manually

It is highly recommended that you do a documentation of your API, [Swagger](https://swagger.io/) is a very good option to do it.

## Minimal script client for the Rick and Morty API

Create a script to clone the entire [Rick and Morty api](https://rickandmortyapi.com/) and store it to a [.csv](https://en.wikipedia.org/wiki/Comma-separated_values) file for later use. You can use any language and library that you want but I recommend use the same language that you will use in the project.

Remember that some API responses are urls to another endpoint with more data, instead of storing the url, fetch the id of that data and save it.

For images, also save it to a folder and in the row field store the file system path of the image. The path should look like <image root path>/characters/<character id>.jpeg

## Resources

- [REST API Tutorial](https://restfulapi.net/)
- [HTTP response status codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status)
- [httpie - A simple yet powerful command-line HTTP and API testing client for the API era](https://httpie.io/)
- [Swagger - API Development for Everyone](https://swagger.io/)
- [Learn SQL: Types of relations](https://www.sqlshack.com/learn-sql-types-of-relations/)
- [Database Normalization](https://www.guru99.com/database-normalization.html)