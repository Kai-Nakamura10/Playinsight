import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "indicator", "trigger"]

  connect() {
    this.updateState()
  }

  toggle() {
    if (!this.hasContentTarget) return

    this.contentTarget.classList.toggle("hidden")
    this.updateState()
  }

  updateState() {
    if (!this.hasContentTarget) return

    const expanded = !this.contentTarget.classList.contains("hidden")
    if (this.hasTriggerTarget) {
      this.triggerTarget.setAttribute("aria-expanded", expanded ? "true" : "false")
    }
    if (this.hasIndicatorTarget) {
      this.indicatorTarget.textContent = expanded ? "-" : "+"
    }
  }
}
