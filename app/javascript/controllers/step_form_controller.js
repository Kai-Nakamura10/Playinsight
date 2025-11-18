import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["step", "nextButton", "prevButton", "progress"]
  static values = { index: Number }

  connect() {
    this.indexValue = 0
    this.showCurrentStep()
  }

  next(event) {
    if (!this.stepsValid()) { event.preventDefault(); return }
    this.indexValue++
    this.showCurrentStep()
  }

  prev(event) {
    event.preventDefault()
    this.indexValue--
    this.showCurrentStep()
  }

  showCurrentStep() {
    this.stepTargets.forEach((el, i) => el.classList.toggle("hidden", i !== this.indexValue))
    this.prevButtonTargets.forEach(btn => btn.disabled = this.indexValue === 0)
      this.nextButtonTargets.forEach(btn => btn.classList.toggle("hidden", this.indexValue >= this.stepTargets.length - 1))
      const percent = ((this.indexValue + 1) / this.stepTargets.length) * 100
      this.progressTargets.forEach(el => el.style.width = `${percent}%`)
  }

  stepsValid() {
    // basic client checks before moving on (optional)
    return true
  }
}