window.onload = () => {
  var container = document.querySelector('#menu-bar > .right-buttons')

  var label = document.createElement('label')
  label.innerText = 'Solutions'
  label.id = 'hide-code'

  var input = document.createElement('input')
  input.type = 'checkbox'
  input.hidden = true
  input.checked = localStorage.getItem('hide-code') === 'true' ?? true
  input.onchange = e => {
    localStorage.setItem('hide-code', e.target.checked)
  }

  label.appendChild(input)
  container.appendChild(label)
}
