import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static classes = [ "selectDay" ]
  static targets = [ "selectedDays", "deactivatable" ]
  static values = { selectedDays: Array }

  connect() {
    this.disableForm()
  }

  selectDay({ currentTarget: dayElement, params: { day } }) {
    if (this.selectedDaysValue.some(element => element == day)) {
      dayElement.classList.remove(this.selectDayClass)
      this.selectedDaysValue = this.selectedDaysValue.filter(element => element != day)
    } else {
      dayElement.classList.add(this.selectDayClass)
      this.selectedDaysValue = [day, ...this.selectedDaysValue]
    }
  }

  selectedDaysValueChanged() {
    this.selectedDaysTarget.value = this.selectedDaysValue

    if (this.selectedDaysValue.length) {
      this.enableForm()
    } else {
      this.disableForm()
    }
  }

  disableForm() {
    this.deactivatableTargets.forEach(element => element.disabled = true)
  }

  enableForm() {
    this.deactivatableTargets.forEach(element => element.disabled = false)
  }
}
