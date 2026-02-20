import { Controller } from "@hotwired/stimulus"

// 재사용 가능한 닫기 컨트롤러
// data-controller="dismiss"
// data-action="click->dismiss#close" (닫기 버튼에 연결)
// data-dismiss-auto-delay-value="5000" (선택: ms 단위 자동 닫힘, 없으면 수동만)
export default class extends Controller {
  static values = {
    autoDelay: { type: Number, default: 0 }
  }

  connect() {
    this.autoCloseTimer = null
    if (this.autoDelayValue > 0) {
      this.autoCloseTimer = setTimeout(() => this.close(), this.autoDelayValue)
    }
  }

  disconnect() {
    if (this.autoCloseTimer) {
      clearTimeout(this.autoCloseTimer)
    }
  }

  close() {
    if (this.autoCloseTimer) {
      clearTimeout(this.autoCloseTimer)
      this.autoCloseTimer = null
    }
    this.element.style.transition = "opacity 0.2s ease-out, transform 0.2s ease-out"
    this.element.style.opacity = "0"
    this.element.style.transform = "translateX(1rem)"
    setTimeout(() => this.element.remove(), 200)
  }
}
