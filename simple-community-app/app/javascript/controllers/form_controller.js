import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["email", "password", "passwordConfirmation", "title", "body"]

  connect() {
    this.element.addEventListener('submit', this.handleSubmit.bind(this))
  }

  validateEmail(event) {
    const input = event.target
    const value = input.value.trim()
    
    if (!value) {
      this.showError(input, '이메일을 입력하세요')
    } else if (!this.isValidEmail(value)) {
      this.showError(input, '올바른 이메일 형식이 아닙니다')
    } else {
      this.clearError(input)
    }
  }

  validatePassword(event) {
    const input = event.target
    const value = input.value
    
    if (!value) {
      this.showError(input, '비밀번호를 입력하세요')
    } else if (value.length < 6) {
      this.showError(input, '비밀번호는 최소 6자 이상이어야 합니다')
    } else {
      this.clearError(input)
      
      // 비밀번호 확인 필드도 함께 검증
      if (this.hasPasswordConfirmationTarget && this.passwordConfirmationTarget.value) {
        this.validatePasswordMatch({ target: this.passwordConfirmationTarget })
      }
    }
  }

  validatePasswordMatch(event) {
    const input = event.target
    const value = input.value
    
    if (!value) {
      this.showError(input, '비밀번호 확인을 입력하세요')
    } else if (this.hasPasswordTarget && value !== this.passwordTarget.value) {
      this.showError(input, '비밀번호가 일치하지 않습니다')
    } else {
      this.clearError(input)
    }
  }

  validateRequired(event) {
    const input = event.target
    const value = input.value.trim()
    
    if (!value) {
      const fieldName = input.getAttribute('placeholder') || '필드'
      this.showError(input, `${fieldName}를 입력하세요`)
    } else {
      this.clearError(input)
    }
  }

  clearErrorOnInput(event) {
    const input = event.target
    if (input.value.trim()) {
      this.clearError(input)
    }
  }

  handleSubmit(event) {
    let hasError = false
    const form = event.target

    // 이메일 검증
    if (this.hasEmailTarget) {
      const email = this.emailTarget.value.trim()
      if (!email) {
        this.showError(this.emailTarget, '이메일을 입력하세요')
        hasError = true
      } else if (!this.isValidEmail(email)) {
        this.showError(this.emailTarget, '올바른 이메일 형식이 아닙니다')
        hasError = true
      }
    }

    // 비밀번호 검증
    if (this.hasPasswordTarget) {
      const password = this.passwordTarget.value
      if (!password) {
        this.showError(this.passwordTarget, '비밀번호를 입력하세요')
        hasError = true
      } else if (password.length < 6 && this.hasPasswordConfirmationTarget) {
        this.showError(this.passwordTarget, '비밀번호는 최소 6자 이상이어야 합니다')
        hasError = true
      }
    }

    // 비밀번호 확인 검증
    if (this.hasPasswordConfirmationTarget) {
      const passwordConfirmation = this.passwordConfirmationTarget.value
      if (!passwordConfirmation) {
        this.showError(this.passwordConfirmationTarget, '비밀번호 확인을 입력하세요')
        hasError = true
      } else if (this.hasPasswordTarget && passwordConfirmation !== this.passwordTarget.value) {
        this.showError(this.passwordConfirmationTarget, '비밀번호가 일치하지 않습니다')
        hasError = true
      }
    }

    // 제목 검증
    if (this.hasTitleTarget && !this.titleTarget.value.trim()) {
      this.showError(this.titleTarget, '제목을 입력하세요')
      hasError = true
    }

    // 내용 검증
    if (this.hasBodyTarget && !this.bodyTarget.value.trim()) {
      this.showError(this.bodyTarget, '내용을 입력하세요')
      hasError = true
    }

    if (hasError) {
      event.preventDefault()
      return false
    }

    // 제출 버튼 비활성화
    this.disableSubmitButton(form)
  }

  disableSubmitButton(form) {
    const submitButton = form.querySelector('input[type="submit"], button[type="submit"]')
    if (submitButton) {
      submitButton.disabled = true
      const originalText = submitButton.value || submitButton.textContent
      
      if (submitButton.tagName === 'INPUT') {
        submitButton.value = '처리 중...'
      } else {
        submitButton.textContent = '처리 중...'
      }

      setTimeout(() => {
        submitButton.disabled = false
        if (submitButton.tagName === 'INPUT') {
          submitButton.value = originalText
        } else {
          submitButton.textContent = originalText
        }
      }, 3000)
    }
  }

  showError(input, message) {
    const formGroup = input.closest('div')
    let errorDiv = formGroup.querySelector('.error-message')
    
    if (!errorDiv) {
      errorDiv = document.createElement('div')
      errorDiv.className = 'error-message text-red-600 text-sm mt-1'
      formGroup.appendChild(errorDiv)
    }
    
    errorDiv.textContent = message
    input.classList.add('border-red-500', 'focus:border-red-500', 'focus:ring-red-200')
    input.classList.remove('border-gray-300', 'focus:border-indigo-500', 'focus:ring-indigo-200')
  }

  clearError(input) {
    const formGroup = input.closest('div')
    const errorDiv = formGroup.querySelector('.error-message')
    
    if (errorDiv) {
      errorDiv.remove()
    }
    
    input.classList.remove('border-red-500', 'focus:border-red-500', 'focus:ring-red-200')
    input.classList.add('border-gray-300', 'focus:border-indigo-500', 'focus:ring-indigo-200')
  }

  isValidEmail(email) {
    const re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    return re.test(email)
  }
}
