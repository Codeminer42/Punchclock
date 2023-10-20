import { Controller } from "@hotwired/stimulus";


export default class extends Controller {
  static targets = [ "template", "formContent" ]

  add(e) {
    e.preventDefault()

    const content = this.templateTarget.innerHTML.replace(/NEW_RECORD/g, new Date().getTime().toString())
    this.formContentTarget.insertAdjacentHTML('beforebegin', content)
  }

  remove(e) {
    e.preventDefault()

    console.log("REMOVE")
  }
}
