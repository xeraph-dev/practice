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

episodes.map(c => {
  if (stats.episodes.names.includes(c.name)) {
    stats.episodes.namesRepeated.add(c.name)
    stats.episodes.nameIsUnique = false
  } else stats.episodes.names.push(c.name)

  if (!c.episode) stats.episodes.episodeCanBeNull = true
})

console.log('')
console.log('Characters stats')
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

console.log('----------------------------')

console.log('Locations stats')
console.table({
  'Names repeated': stats.locations.namesRepeated.size,
  'Name is Unique?': stats.locations.nameIsUnique,
  Types: stats.locations.types.size,
  Dimensions: stats.locations.dimensions.size,
  'Type can be null?': stats.locations.typeCanBeNull,
  'Dimension can be null?': stats.locations.dimensionCanBeNull,
})

console.log('----------------------------')

console.log('Episodes stats')
console.table({
  'Names repeated': stats.episodes.namesRepeated.size ?? 0,
  'Name is Unique?': stats.episodes.nameIsUnique,
  'Episode can be null?': stats.episodes.episodeIsUnique,
})
console.log('')
