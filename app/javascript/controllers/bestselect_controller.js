import { Controller } from "@hotwired/stimulus"

// Controls answer selection and shows correct/incorrect feedback
export default class extends Controller {
  static targets = ["result", "answer", "explanation"]
  static values = {
    currentId: String
  }

  connect() {
    console.log("Stimulus connect. currentId:", this.currentIdValue)
    // Clear any stale state on connect
    if (this.hasResultTarget) this.resultTarget.textContent = ""
    // Hide explanation initially
    if (this.hasExplanationTarget)
      this.explanationTarget.classList.add("hidden")
  }

  choose(event) {
    const el = event.currentTarget
    const isCorrect = String(el.dataset.bestselectCorrectValue) === "true"
    const choiceId = el.dataset.choiceId  // ← ★ 追加：回答IDを取得

    // ====== UI: 正解/不正解の表示 ======
    if (this.hasResultTarget) {
      this.resultTarget.classList.remove("text-green-700", "text-red-700")
      this.resultTarget.textContent = isCorrect ? "正解" : "不正解"
      this.resultTarget.classList.add(isCorrect ? "text-green-700" : "text-red-700")
    }

    // ====== UI: 正解なら解説表示 ======
    if (this.hasExplanationTarget) {
      if (isCorrect) {
        this.explanationTarget.classList.remove("hidden")
      } else {
        this.explanationTarget.classList.add("hidden")
      }
    }

    // ====== Rails に回答履歴を送信 ======
    this.saveAnswer(choiceId)
  }

  saveAnswer(choiceId) {
    fetch(`/bestselects/${this.currentIdValue}/answer`, {
      method: "POST",
      headers: {
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
        "Content-Type": "application/json"
      },
      body: JSON.stringify({ choice_id: choiceId })
    })
    .then(res => res.json())
    .then(data => {
      console.log("回答が保存されました:", data)
      setTimeout(() => {
        window.location.reload()
      }, 2000)
    })
    .catch(err => console.error("回答保存エラー:", err))
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
