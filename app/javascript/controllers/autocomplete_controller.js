import Autocomplete from "stimulus-autocomplete"

export default class extends Autocomplete {
  static targets = ["input", "hidden", "results", "form"]

  async doFetch(url) {
    const response = await fetch(url, this.optionsForFetch())
    if (!response.ok) {
      throw new Error(`Server responded with status ${response.status}`)
    }
    return response.json()
  }

  replaceResults(results) {
    const entries = this.normalizeResults(results)
    this.resultsTarget.innerHTML = ""

    entries.forEach((result) => {
      const option = this.resultTemplate(result)
      if (option) {
        this.resultsTarget.appendChild(option)
      }
    })

    this.identifyOptions()

    if (this.options.length) {
      this.open()
    } else {
      this.close()
    }
  }

  normalizeResults(results) {
    if (Array.isArray(results)) return results
    if (results?.results && Array.isArray(results.results)) return results.results

    if (typeof results === "string") {
      try {
        const parsed = JSON.parse(results)
        if (Array.isArray(parsed)) return parsed
        if (parsed?.results && Array.isArray(parsed.results)) return parsed.results
      } catch (error) {
        console.warn("Failed to parse autocomplete results string", error, results)
      }
    }

    return []
  }

  resultTemplate(result) {
    const { title, url } =
      typeof result === "object" && result !== null
        ? result
        : { title: String(result), url: null }

    const option = document.createElement("li")
    option.textContent = title
    option.setAttribute("role", "option")
    option.dataset.autocompleteValue = title
    option.dataset.autocompleteLabel = title
    if (url) option.dataset.autocompleteUrl = url
    option.classList.add("block", "px-4", "py-2", "border", "rounded-md", "hover:bg-gray-50")

    return option
  }

  commit(selected) {
    if (selected.getAttribute("aria-disabled") === "true") return

    const textValue = selected.getAttribute("data-autocomplete-label") || selected.textContent.trim()
    const value = selected.getAttribute("data-autocomplete-value") || textValue
    const url = selected.getAttribute("data-autocomplete-url")

    if (url) {
      window.location.href = url
      this.close()
      return
    }

    this.inputTarget.value = textValue

    if (this.hasHiddenTarget) {
      this.hiddenTarget.value = value
      this.hiddenTarget.dispatchEvent(new Event("input"))
      this.hiddenTarget.dispatchEvent(new Event("change"))
    } else {
      this.inputTarget.value = value
    }

    if (this.hasFormTarget) {
      this.formTarget.requestSubmit()
    }

    this.inputTarget.focus()
    this.hideAndRemoveOptions()
    this.element.dispatchEvent(
      new CustomEvent("autocomplete.change", {
        bubbles: true,
        detail: { value, textValue, selected }
      })
    )
  }
}
