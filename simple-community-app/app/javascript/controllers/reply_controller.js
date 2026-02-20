import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  toggle(event) {
    event.preventDefault()
    const commentId = event.params.id
    const form = document.getElementById(`reply-form-${commentId}`)
    
    if (form) {
      form.classList.toggle('hidden')
      
      // 폼이 보이면 textarea에 포커스
      if (!form.classList.contains('hidden')) {
        const textarea = form.querySelector('textarea')
        if (textarea) {
          textarea.focus()
        }
      }
    }
  }
}
