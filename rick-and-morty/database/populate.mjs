// @ts-check

import { DateTime } from 'luxon'
import { dirname, join } from 'node:path'
import { fileURLToPath } from 'node:url'
import sqlite3 from 'sqlite3'

import characters from './characters.json' assert { type: 'json' }
import episodes from './episodes.json' assert { type: 'json' }
import locations from './locations.json' assert { type: 'json' }

const __dirname = dirname(fileURLToPath(import.meta.url))
const db = new sqlite3.Database(join(__dirname, 'database.db'), err => {
  if (err) return console.error(err.message)
  console.log('Connected to the SQlite database.')
})

/**
 * format date to sqlite ISO String with UTC time zone
 * @param {string} date
 * @returns {string}
 */
function formatDate(date) {
  return DateTime.fromJSDate(new Date(date)).toUTC().toFormat('yyyy-LL-dd HH:mm:ss')
}

/**
 * split episode string into [season, episode] object
 * @param {string} str
 * @returns {[number, number]}
 */
function parseEpisode(str) {
  let season = ''
  let episode = ''
  let isSeason = false
  let isEpisode = false
  for (const c of str) {
    if (c === 'S') isSeason = true
    if (c === 'E') isEpisode = true
    if (['S', 'E'].includes(c)) continue
    if (isEpisode) episode += c
    else if (isSeason) season += c
  }

  return [parseInt(season), parseInt(episode)]
}

;(function populateCharacters() {
  const speciess = new Set()
  const types = new Set()
  /** @type {{[key: string]: string[]}} */
  const episodes = {}

  const rows = characters
    .map(
      ({ id, name, status, gender, species, type, origin, location, image, episode, created }) => {
        if (species) speciess.add(species)
        if (type) types.add(type)
        episodes[id] = episode
        return [
          id,
          JSON.stringify(name),
          JSON.stringify(status),
          JSON.stringify(gender),
          [...speciess].indexOf(species),
          type ? [...types].indexOf(type) + 1 : 'NULL',
          location || 'NULL',
          origin || 'NULL',
          JSON.stringify(image),
          +true, // from_api
          JSON.stringify(formatDate(created)), // created_at
        ].join(',')
      }
    )
    .map(row => `(${row})`)
    .join(',')

  const speciesRow = [...speciess]
    .map((name, index) => [index + 1, JSON.stringify(name)].join(','))
    .map(row => `(${row})`)
    .join(',')
  const typesRows = [...types]
    .map((name, index) => [index + 1, JSON.stringify(name)].join(','))
    .map(row => `(${row})`)
    .join(',')

  const sqlSpecies = `INSERT INTO character_species (id, name) VALUES ${speciesRow} ON CONFLICT DO NOTHING;`
  const sqlTypes = `INSERT INTO character_types (id, name) VALUES ${typesRows} ON CONFLICT DO NOTHING;`
  const sql = `INSERT INTO characters (id,name,status,gender,species_id,type_id,location_id,origin_id,image,from_api,created_at) VALUES ${rows} ON CONFLICT DO NOTHING;`

  db.run(sqlSpecies, function (err) {
    if (err) return console.error(err.message)
    console.log(`Character species rows inserted ${this.changes}`)
  })

  db.run(sqlTypes, function (err) {
    if (err) return console.error(err.message)
    console.log(`Character types rows inserted ${this.changes}`)
  })

  db.run(sql, function (err) {
    if (err) return console.error(err.message)
    console.log(`Characters rows inserted ${this.changes}`)
  })

  const episodesRows = Object.entries(episodes)
    .map(([cid, eids]) => eids.map(eid => [cid, eid].join(',')).map(row => `(${row})`))
    .join(',')

  const sqlEpisodes = `INSERT INTO characters_episodes (character_id,episode_id) VALUES ${episodesRows} ON CONFLICT DO NOTHING;`

  db.run(sqlEpisodes, function (err) {
    if (err) return console.error(err.message)
    console.log(`Characters episodes rows inserted ${this.changes}`)
  })
})()
;(function populateLocations() {
  const types = new Set()
  const dimensions = new Set()

  const rows = locations
    .map(({ id, name, type, dimension, created }) => {
      if (type) types.add(type)
      if (dimension) dimensions.add(dimension)
      return [
        id,
        JSON.stringify(name),
        type ? [...types].indexOf(type) + 1 : 'NULL',
        dimension ? [...dimensions].indexOf(dimension) + 1 : 'NULL',
        +true, // from_api
        JSON.stringify(formatDate(created)), // created_at
      ].join(',')
    })
    .map(row => `(${row})`)
    .join(',')

  const typesRows = [...types]
    .map((name, index) => [index + 1, JSON.stringify(name)].join(','))
    .map(row => `(${row})`)
    .join(',')
  const dimensionsRows = [...dimensions]
    .map((name, index) => [index + 1, JSON.stringify(name)].join(','))
    .map(row => `(${row})`)
    .join(',')

  const sqlTypes = `INSERT INTO location_types (id, name) VALUES ${typesRows} ON CONFLICT DO NOTHING;`
  const sqlDimensions = `INSERT INTO location_dimensions (id, name) VALUES ${dimensionsRows} ON CONFLICT DO NOTHING;`
  const sql = `INSERT INTO locations (id,name,type_id,dimension_id,from_api,created_at) VALUES ${rows} ON CONFLICT DO NOTHING;`

  db.run(sqlTypes, function (err) {
    if (err) return console.error(err.message)
    console.log(`Location types rows inserted ${this.changes}`)
  })

  db.run(sqlDimensions, function (err) {
    if (err) return console.error(err.message)
    console.log(`Location dimensions rows inserted ${this.changes}`)
  })

  db.run(sql, function (err) {
    if (err) return console.error(err.message)
    console.log(`Locations rows inserted ${this.changes}`)
  })
})()
;(function populateEpisodes() {
  const rows = episodes
    .map(({ id, name, episode: episodeString, air_date, created }) => {
      const [season, episode] = parseEpisode(episodeString)
      return [
        id,
        JSON.stringify(name),
        season,
        episode,
        JSON.stringify(formatDate(air_date)),
        +true, // from_api
        JSON.stringify(formatDate(created)), // created_at
      ].join(',')
    })
    .map(row => `(${row})`)
    .join(',')

  const sql = `INSERT INTO episodes (id,name,season,episode,air_date,from_api,created_at) VALUES ${rows} ON CONFLICT DO NOTHING;`
  db.run(sql, function (err) {
    if (err) return console.error(err.message)
    console.log(`Episodes rows inserted ${this.changes}`)
  })
})()

db.close(err => {
  if (err) return console.error(err.message)
  console.log('Close the database connection.')
})
