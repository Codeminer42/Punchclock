function Langs() {
  this.data = []

  this.add = function(item) {
    this.data.push(item)
  }

  this.remove = function(item) {
    const index = this.data.indexOf(item)

    this.data.splice(index, 1)

    return this.data
  }

  this.includes = function(item) {
    return this.data.includes(item)
  }

  this.getLanguages = function() {
    return [...this.data]
  }
}

function InputField() {
  this.input = document.getElementById('search-input-field')
  this.input.addEventListener('keyup', function (event) {
    if (event.key == " ") {
      refresh()
    }
  })

  this.getValues = function () {
    return this.input.value.trim().split(" ")
  }

  this.setValue = function(value) {
    this.input.value = value
  }

  this.hide = function() {
    this.input.style.visibility = 'hidden'
  }

  this.clear = function() {
    this.setValue("")
  }

  this.setFocus = function() {
    this.input.focus()
  }
}

function PillsDisplayer() {
  this.pills = document.getElementById('languages-list')

  this.refresh = function(languages) {
    this.pills.innerHTML = ""

    languages.forEach((l) => this.pills.append(new Pill(l)))
  }
}

function Pill(lang) {
  let pill = document.createElement('span')
  pill.classList.add('lang-pill')

  let span = document.createElement('span')
  span.innerText = lang

  const deleteButton = document.createElement('span')

  deleteButton.innerHTML = 'x'
  deleteButton.classList.add('delete-button')
  deleteButton.setAttribute('data-lang', lang)

  deleteButton.onclick = function (event) {
    const lang = deleteButton.dataset.lang

    objLangs.remove(lang)

    refresh()
  }


  pill.append(span)
  pill.append(deleteButton)

  return pill
}

function refresh() {
  objInput
    .getValues()
    .filter((l) => l && !objLangs.includes(l))
    .forEach((l) => objLangs.add(l))

  objInput.clear()

  objDisplayer.refresh(objLangs.getLanguages())
}

document
  .getElementById('filter-button')
  .onclick = function () {
    refresh()

    objInput.hide()
    objInput.setValue(objLangs.getLanguages().toString())
  }

const objLangs = new Langs()
const objInput = new InputField()
const objDisplayer = new PillsDisplayer()

refresh()

objInput.setFocus()
