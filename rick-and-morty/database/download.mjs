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

const getItems = async (url, results = []) => {
  console.log('Fetching', url)
  const items = await fetch(url).then(res => res.json())
  results = results.concat(items.results)

  if (items.info.next) return getItems(items.info.next, results)
  return results
}

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

getItems(API.episode).then(data => {
  const db = data.map(({ url: _, ...row }) => ({
    ...row,
    characters: row.characters.map(c => c.split('/').last()),
  }))

  writeFileSync(PATHS.episodes, JSON.stringify(db, null, 2), 'utf8')
})

getItems(API.location).then(data => {
  const db = data.map(({ url: _, ...row }) => ({
    ...row,
    residents: row.residents.map(r => r.split('/').last()),
  }))

  writeFileSync(PATHS.locations, JSON.stringify(db, null, 2), 'utf8')
})
