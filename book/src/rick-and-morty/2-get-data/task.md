# Get Data

> This step is not required in most real projects, but it is a useful practice because in some situations it is necessary to do a thorough investigation of a production database to understand how the project works.
>
> If you want a more realistic experience, you can skip this step and make your own data based on the schema provided in the next step.

As mentioned in the overview, we first need to clone the entire database. To do this, I recommend a scripting language like [python](python.org), [javascript](https://javascript.info/), [ruby](https://www.ruby-lang.org/en/), [lua](https://www.lua.org/) or any other language you want. The most important requirement for this task is that you should write it in a single small file and without other files and folders like `node_modules` (they are just scripts).

## Tasks

- [ ] [Script to get the data](#script-to-get-the-data)
  - [ ] Download characters dataset
    - [ ] Download characters images
  - [ ] Download locations dataset
  - [ ] Download episodes dataset
- [ ] [Script to get some useful stats](#script-to-get-stats)
  - Characters dataset
    - [ ] Names repeated (useless but maybe you are interested on it)
    - [ ] Statuses (useful to know if you need an enum or a table)
    - [ ] Genders (useful to know if you need an enum or a table)
    - [ ] Species (useful to know if you need an enum or a table)
    - [ ] types (useful to know if you need an enum or a table)
    - [ ] Name is unique?
    - [ ] Status can be null?
    - [ ] Gender can be null?
    - [ ] Species can be null?
    - [ ] Type can be null?
    - [ ] Location can be null?
    - [ ] Origin can be null?
    - [ ] Image can be null?
  - Locations dataset
    - [ ] Names repeated (useless but maybe you are interested on it)
    - [ ] Types (useful to know if you need an enum or a table)
    - [ ] Dimensions (useful to know if you need an enum or a table)
    - [ ] Name is unique?
    - [ ] Type can be null?
    - [ ] Dimension can be null?
  - Episodes dataset
    - [ ] Names repeated (useless but maybe you are interested on it)
    - [ ] Name is unique?
    - [ ] Episode is unique?

## Script to get the data

In this task, we will create a small script to recursively get all the data from the API and store it in a [json](http://json.org/) file.

If you read the original API, you will notice that the characters also have an image, we also need to download it, and override the URL for the file system path of the downloaded image. I recommend having an images folder at the root of the project and inside a characters folder that will contain all downloaded images. This format is useful for scaling, at this point we know that in the project plan (see summary) we need to implement a **Users** feature, maybe the user also needs to have an image.

## Script to get stats

In this task, we will create another small script to get some statistics from the downloaded data, such as whether the name field is unique, or whether a field can be null. It will be useful to define the database schema later (since we are using an existing database, we need to learn how it is structured).
