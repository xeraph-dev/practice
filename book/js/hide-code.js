function hideCode(hide) {
  const els = document.querySelectorAll('a[href$="/solution.html"]')
  for (let el of els) {
    el = el.parentElement.parentElement.parentElement
    if (hide) el.style.display = 'none'
    else el.style.display = null
  }
}

var container = document.querySelector('#menu-bar > .right-buttons')

var label = document.createElement('label')
label.innerText = 'Solutions'

var input = document.createElement('input')
input.type = 'checkbox'
input.id = 'hide-code'
input.hidden = true
input.checked = localStorage.getItem('hide-code') === 'true' ?? true
hideCode(input.checked)
input.onchange = e => {
  localStorage.setItem('hide-code', e.target.checked)
  hideCode(e.target.checked)
}

label.appendChild(input)
container.appendChild(label)
