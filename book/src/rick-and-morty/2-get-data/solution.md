# My solution in JavaScript

## Script to get the data

**File**: `<root>/database/download.mjs`

### _Base file with all the imports and variables that I will use._

```javascript
import { existsSync, mkdirSync, writeFileSync } from 'node:fs'
import { dirname, join } from 'node:path'
import { fileURLToPath } from 'node:url'

const __dirname = dirname(fileURLToPath(import.meta.url))

Array.prototype.last = function () {
  return this[this.length - 1]
}

const BASE_API = 'https://rickandmortyapi.com/api'

const API = {
  character: `${BASE_API}/character`,
  location: `${BASE_API}/location`,
  episode: `${BASE_API}/episode`,
}

const PATHS = {
  characters: join(__dirname, 'characters.json'),
  locations: join(__dirname, 'locations.json'),
  episodes: join(__dirname, 'episodes.json'),
  images: join(__dirname, 'images', 'characters'),
}

if (!existsSync(PATHS.images)) mkdirSync(PATHS.images, { recursive: true })
```

### _`getItems` function to recursively fetch all records_

```javascript
const getItems = async (url, results = []) => {
  console.log('Fetching', url)
  const items = await fetch(url).then(res => res.json())
  results = results.concat(items.results)

  if (items.info.next) return getItems(items.info.next, results)
  return results
}
```

### _`saveImage` function to download character's image_

```javascript
const saveImage = async url => {
  if (!url) return ''
  console.log('Saving image', url)
  const imagePath = join(PATHS.images, url.split('/').last())
  const image = await fetch(url)
    .then(res => res.arrayBuffer())
    .then(Buffer.from)
  writeFileSync(imagePath, image, 'binary')
  return imagePath
}
```

### _Using the `getItems` function to download the character dataset and images_

```javascript
getItems(API.character).then(async data => {
  const db = []
  for await (const { url: _, ...row } of data) {
    db.push({
      ...row,
      origin: row.origin && row.origin.url !== '' ? row.origin.url.split('/').last() : '',
      location: row.location && row.location.url !== '' ? row.location.url.split('/').last() : '',
      episode: row.episode ? row.episode.map(e => e.split('/').last()) : '',
      image: await saveImage(row.image),
    })
  }

  writeFileSync(PATHS.characters, JSON.stringify(db, null, 2), 'utf8')
})
```

### _Using the `getItems` function to download the episode dataset_

```javascript
getItems(API.episode).then(data => {
  const db = data.map(({ url: _, ...row }) => ({
    ...row,
    characters: row.characters.map(c => c.split('/').last()),
  }))

  writeFileSync(PATHS.episodes, JSON.stringify(db, null, 2), 'utf8')
})
```

### _Using the `getItems` function to download the location dataset_

```javascript
getItems(API.location).then(data => {
  const db = data.map(({ url: _, ...row }) => ({
    ...row,
    residents: row.residents.map(r => r.split('/').last()),
  }))

  writeFileSync(PATHS.locations, JSON.stringify(db, null, 2), 'utf8')
})
```

## Script to get stats

**File**: `<root>/database/stats.mjs`

### _Stats object variable and import json files_

```javascript
import characters from './characters.json' assert { type: 'json' }
import locations from './locations.json' assert { type: 'json' }
import episodes from './episodes.json' assert { type: 'json' }

let stats = {
  characters: {
    names: [],
    namesRepeated: new Set(),
    statuses: new Set(),
    genders: new Set(),
    species: new Set(),
    types: new Set(),
    nameIsUnique: true,
    statusCanBeNull: false,
    genderCanBeNull: false,
    speciesCanBeNull: false,
    typeCanBeNull: false,
    locationCanBeNull: false,
    originCanBeNull: false,
    imageCanBeNull: false,
  },
  locations: {
    names: [],
    namesRepeated: new Set(),
    types: new Set(),
    dimensions: new Set(),
    nameIsUnique: true,
    typeCanBeNull: false,
    dimensionCanBeNull: false,
  },
  episodes: {
    names: [],
    namesRepeated: [],
    nameIsUnique: true,
    episodeIsUnique: false,
  },
}
```

### _Compute characters stats_

```javascript
characters.map(c => {
  if (stats.characters.names.includes(c.name)) {
    stats.characters.namesRepeated.add(c.name)
    stats.characters.nameIsUnique = false
  } else stats.characters.names.push(c.name)

  if (!c.status) stats.characters.statusCanBeNull = true
  else stats.characters.statuses.add(c.status)
  if (!c.gender) stats.characters.genderCanBeNull = true
  else stats.characters.genders.add(c.gender)
  if (!c.species) stats.characters.speciesCanBeNull = true
  else stats.characters.species.add(c.species)
  if (!c.type) stats.characters.typeCanBeNull = true
  else stats.characters.types.add(c.type)

  if (!c.image) stats.characters.imageCanBeNull = true
  if (!c.location) stats.characters.locationCanBeNull = true
  if (!c.origin) stats.characters.originCanBeNull = true
})
```

### _Compute locations stats_

```javascript
locations.map(c => {
  if (stats.locations.names.includes(c.name)) {
    stats.locations.namesRepeated.add(c.name)
    stats.locations.nameIsUnique = false
  } else stats.locations.names.push(c.name)

  if (!c.type) stats.locations.typeCanBeNull = true
  else stats.locations.types.add(c.type)
  if (!c.dimension) stats.locations.dimensionCanBeNull = true
  else stats.locations.dimensions.add(c.dimension)
})
```

### _Compute episodes stats_

```javascript
episodes.map(c => {
  if (stats.episodes.names.includes(c.name)) {
    stats.episodes.namesRepeated.add(c.name)
    stats.episodes.nameIsUnique = false
  } else stats.episodes.names.push(c.name)

  if (!c.episode) stats.episodes.episodeCanBeNull = true
})
```

### _Show characters stats_

```javascript
console.table({
  'Names repeated': stats.characters.namesRepeated.size,
  'Name is Unique?': stats.characters.nameIsUnique,
  Statuses: [...stats.characters.statuses].join(', '),
  Genders: [...stats.characters.genders].join(', '),
  Species: stats.characters.species.size,
  Types: stats.characters.types.size,
  'Status can be null?': stats.characters.statusCanBeNull,
  'Gender can be null?': stats.characters.genderCanBeNull,
  'Species can be null?': stats.characters.speciesCanBeNull,
  'Type can be null?': stats.characters.typeCanBeNull,
  'Location can be null?': stats.characters.locationCanBeNull,
  'Origin can be null?': stats.characters.originCanBeNull,
  'Image can be null?': stats.characters.imageCanBeNull,
})
```

### _Characters stats output_

| Question                  | Answer                              |
| ------------------------- | ----------------------------------- |
| **Names repeated**        | `46`                                |
| **Name is Unique?**       | `false`                             |
| **Statuses**              | `Alive, unknown, Dead`              |
| **Genders**               | `Male, Female, unknown, Genderless` |
| **Species**               | `10`                                |
| **Types**                 | `169`                               |
| **Status can be null?**   | `false`                             |
| **Gender can be null?**   | `false`                             |
| **Species can be null?**  | `false`                             |
| **Type can be null?**     | `true`                              |
| **Location can be null?** | `true`                              |
| **Origin can be null?**   | `true`                              |
| **Image can be null?**    | `false`                             |

### _Show locations stats_

```javascript
console.table({
  'Names repeated': stats.locations.namesRepeated.size,
  'Name is Unique?': stats.locations.nameIsUnique,
  Types: stats.locations.types.size,
  Dimensions: stats.locations.dimensions.size,
  'Type can be null?': stats.locations.typeCanBeNull,
  'Dimension can be null?': stats.locations.dimensionCanBeNull,
})
```

### _Locations stats output_

| Question                   | Answer |
| -------------------------- | ------ |
| **Names repeated**         | `0`    |
| **Name is Unique?**        | `true` |
| **Types**                  | `45`   |
| **Dimensions**             | `33`   |
| **Type can be null?**      | `true` |
| **Dimension can be null?** | `true` |

### _Show episodes stats_

```javascript
console.table({
  'Names repeated': stats.episodes.namesRepeated.size ?? 0,
  'Name is Unique?': stats.episodes.nameIsUnique,
  'Episode can be null?': stats.episodes.episodeIsUnique,
})
```

### _Episodes stats output_

| Question                 | Answer  |
| ------------------------ | ------- |
| **Names repeated**       | `0`     |
| **Name is Unique?**      | `true`  |
| **Episode can be null?** | `false` |
