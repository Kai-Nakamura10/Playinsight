import { Controller } from "@hotwired/stimulus"
import Chart from 'chart.js/auto';

// Controls answer selection and shows correct/incorrect feedback
export default class extends Controller {
  static targets = ["result", "answer", "explanation", "chart"]
  static values = {
    bestselectId: String,
    correct: Number,
    total: Number
  }

  initChart() {
    // チャート用のターゲットが無ければ初期化しない
    if (!this.hasChartTarget) return
    const ctx = this.chartTarget
    this.chart = new Chart(ctx, {
      type: "doughnut",
      data: {
        labels: ["正解", "不正解"],
        datasets: [{
          data: [this.correctValue, this.totalValue - this.correctValue],
          backgroundColor: ["#2563eb", "#e5e7eb"]
        }]
      },
      options: { cutout: "65%" }
    })
  }

  connect() {
    console.log("Stimulus connect. bestselectId:", this.bestselectIdValue)
    // Chart.js が読み込まれているか確認
    if (typeof Chart === 'undefined') {
      console.warn('Chart.js is not loaded')
      return
    }

    // Clear any stale state on connect
    if (this.hasResultTarget) this.resultTarget.textContent = ""
    // Hide explanation initially
    if (this.hasExplanationTarget)
      this.explanationTarget.classList.add("hidden")
    // チャートターゲットがあるときのみ初期化
    if (this.hasChartTarget) this.initChart()
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
    fetch(`/bestselects/${this.bestselectIdValue}/answer`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('[name="csrf-token"]').content
      },
      body: JSON.stringify({
        choice_id: choiceId
      })
    })
    .then(async response => {
      const data = await response.json().catch(() => ({}))
      if (!response.ok) {
        console.error('Server error:', data.error || data)
        return
      }
      // 統計を更新
      this.updateChart(data)
    })
    .catch(error => console.error('Network error:', error))
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
  updateChart(responseData) {
    // サーバーから統計データを受け取る
    const correctCount = responseData.correct_count
    const totalCount = responseData.total_count

    // Chartが存在する場合のみ更新
    if (this.hasChartTarget && this.chart) {
      this.chart.data.datasets[0].data = [
        correctCount,
        totalCount - correctCount
      ]
      this.chart.update()
    }

    // 正解率も表示（オプション）
    if (responseData.accuracy_rate) {
      console.log(`正解率: ${responseData.accuracy_rate}%`)
    }
  }
}
