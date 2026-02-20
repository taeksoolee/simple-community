import { Controller } from "@hotwired/stimulus"

const STORAGE_KEY = "theme"

export default class extends Controller {
  static values = {
    dark: Boolean
  }

  connect() {
    const stored = localStorage.getItem(STORAGE_KEY)
    const prefersDark = window.matchMedia("(prefers-color-scheme: dark)").matches
    this.dark = stored === "dark" || (!stored && prefersDark)
    document.documentElement.classList.toggle("dark", this.dark)
  }

  toggle() {
    this.dark = !this.dark
    document.documentElement.classList.toggle("dark", this.dark)
    localStorage.setItem(STORAGE_KEY, this.dark ? "dark" : "light")
  }
}
