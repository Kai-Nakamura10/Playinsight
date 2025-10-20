import { Controller } from "@hotwired/stimulus"

// Simple show/hide toggler for a target panel
export default class extends Controller {
  static targets = ["panel"]

  toggle() {
    if (!this.hasPanelTarget) return
    this.panelTarget.classList.toggle("hidden")
  }
}

