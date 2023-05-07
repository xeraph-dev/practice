/**
 * @param {IDBDatabase} db
 * @param {HTMLElement?} node
 * @param {string[]} path
 */
function trackTasks(db, node, path = []) {
  if (node === null) return

  if (node.tagName === 'UL') {
    for (const child of node.children) {
      trackTasks(db, child, path)
    }
  }

  if (node.tagName === 'LI') {
    const first = node.firstChild
    const input = node.querySelector('input')

    if (first.nodeType === document.TEXT_NODE) text = first.textContent.trim()
    else text = input.nextSibling.textContent.trim() || input.nextElementSibling.textContent.trim()

    const newPath = [...path, text]

    if (input) {
      const key = newPath.join(' +|+ ')

      const txn = db.transaction('tasks', 'readonly')
      const store = txn.objectStore('tasks')
      const query = store.get(key)

      query.onsuccess = e => {
        input.checked = e.target.result?.value ?? false
      }

      input.disabled = null
      input.onchange = e => {
        const value = e.target.checked
        const txn = db.transaction('tasks', 'readwrite')
        const store = txn.objectStore('tasks')
        store.put({ key, value })
      }
    }

    trackTasks(db, node.querySelector('ul'), newPath)
  }
}

window.onload = () => {
  const openRequest = indexedDB.open('full-stack-practice', 1)

  openRequest.onupgradeneeded = e => {
    let db = event.target.result

    let store = db.createObjectStore('tasks', {
      keyPath: 'key',
    })
  }

  openRequest.onsuccess = e => {
    const db = e.target.result

    trackTasks(db, document.querySelector('#tasks + ul'), [window.location.pathname])
  }
}
