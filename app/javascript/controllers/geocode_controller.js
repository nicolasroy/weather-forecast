import { Controller } from "@hotwired/stimulus"

// Geocode connects a Mapbox Geocoder to form fields
// and submits the form when a result is selected
export default class extends Controller {
  static targets = ["geocoder", "zipCode", "countryCode"]

  initialize() {
    this.select = this.select.bind(this)
  }

  connect() {
    this.geocoderTarget.addEventListener("retrieve", this.select)
  }

  disconnect() {
    this.geocoderTarget.removeEventListener("retrieve", this.select)
  }

  select(event) {
    const context = event.detail.properties.context
    const zipCode = context?.postcode?.name
    const countryCode = context?.country?.country_code

    this.zipCodeTarget.value = zipCode || this.zipCodeTarget.value
    this.countryCodeTarget.value = countryCode || this.countryCodeTarget.value

    if (zipCode && countryCode) {
      this.element.submit()
    }
  }
}
