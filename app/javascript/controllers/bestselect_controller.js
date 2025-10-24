import { Controller } from "@hotwired/stimulus"

// Controls answer selection and shows correct/incorrect feedback
export default class extends Controller {
  static targets = ["result", "answer", "explanation"]
  static values = { 
    currentId: Number
  }

  connect() {
    // Clear any stale state on connect
    if (this.hasResultTarget) this.resultTarget.textContent = ""
    // Hide explanation initially
    if (this.hasExplanationTarget) this.explanationTarget.classList.add("hidden")
  }

  choose(event) {
    const el = event.currentTarget
    const isCorrect = String(el.dataset.bestselectCorrectValue) === "true"

    // Visual feedback in result area
    if (this.hasResultTarget) {
      this.resultTarget.classList.remove(
        "text-green-700",
        "text-red-700"
      )
      this.resultTarget.textContent = isCorrect ? "正解" : "不正解"
      this.resultTarget.classList.add(isCorrect ? "text-green-700" : "text-red-700")
    }

    // Show explanation only when correct
    if (this.hasExplanationTarget) {
      if (isCorrect) {
        this.explanationTarget.classList.remove("hidden")
      } else {
        this.explanationTarget.classList.add("hidden")
      }
    }
  }

  reset() {
    if (this.hasResultTarget) {
      this.resultTarget.textContent = ""
      this.resultTarget.classList.remove("text-green-700", "text-red-700")
    }
    if (this.hasExplanationTarget) {
      this.explanationTarget.classList.add("hidden")
    }
  }
}
