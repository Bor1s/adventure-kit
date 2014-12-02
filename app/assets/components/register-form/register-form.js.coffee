Polymer 'register-form',
  created: ->
    this.token = document.getElementsByName('csrf-token')[0].getAttribute('content')
    this.passwordValue = ''
    this.passwordConfirmValue = ''

  submitForm: (e, detail, sender)->
    this.sendForm()

  isFormValid: ->
    emailValidity = this.$.email.checkValidity()
    passwordValidity = this.$.password.checkValidity()
    passwordConfirmValidity = this.$.password_confirmation.checkValidity()

    this.$.email_decorator.isInvalid = !emailValidity
    this.$.password_decorator.isInvalid = !passwordValidity
    this.$.password_confirmation_decorator.isInvalid = !passwordConfirmValidity
    emailValidity && passwordValidity && passwordConfirmValidity

  sendForm: ->
    d = new FormData()
    d.append('authenticity_token', this.token)
    d.append('user[accounts_attributes][0][email]', this.emailValue)
    d.append('user[accounts_attributes][0][password]', this.passwordValue)
    d.append('user[accounts_attributes][0][password_confirmation]', this.passwordConfirmValue)

    this.$.form_sender.headers = {"Accept": "application/json"}
    this.$.form_sender.contentType = null
    this.$.form_sender.body = d
    this.$.form_sender.go()

  handleError: (e, error, xhr)->
    data = JSON.parse(error.xhr.responseText)

    #Cleanup old error attached to field
    this._cleanupOldErrors()

    for k in Object.keys(data.errors)
      #Setting new error to field
      this.$[k].setCustomValidity(data.errors[k].toString())
      this.$["#{k}_decorator"].error = data.errors[k].toString()
    this.isFormValid()

  handleSuccess: (e, response)->
    window.location.assign('/events')

  _cleanupOldErrors: ->
    this.$.email.setCustomValidity('')
    this.$.password.setCustomValidity('')
    this.$.password_confirmation.setCustomValidity('')

    emailValidity = this.$.email.checkValidity()
    passwordValidity = this.$.password.checkValidity()
    passwordConfirmValidity = this.$.password_confirmation.checkValidity()

    this.$.email_decorator.isInvalid = !emailValidity
    this.$.password_decorator.isInvalid = !passwordValidity
    this.$.password_confirmation_decorator.isInvalid = !passwordConfirmValidity

