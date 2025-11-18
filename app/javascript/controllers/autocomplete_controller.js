import Autocomplete from "stimulus-autocomplete"

export default class extends Autocomplete {

  resultTemplate(result) {
    const li = document.createElement("li")
    li.textContent = result
    return li
  }

  valueTemplate(result) {
    return result
  }
}