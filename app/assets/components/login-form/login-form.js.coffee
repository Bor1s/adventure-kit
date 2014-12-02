Polymer 'login-form',
  created: ->
    this.token = document.getElementsByName('csrf-token')[0].getAttribute('content')

  submitLoginForm: (e, detail, sender)->
    this.sendForm()

  isFormValid: ->
    emailValidity = this.$.email.checkValidity()
    passwordValidity = this.$.password.checkValidity()

    this.$.email_decorator.isInvalid = !emailValidity
    this.$.password_decorator.isInvalid = !passwordValidity
    emailValidity && passwordValidity

  sendForm: ->
    this.$.form_sender.headers = '{"Accept": "application/json"}'
    this.$.form_sender.go()

  handleError: (e, error)->
    data = JSON.parse(error.xhr.responseText)

    #Cleanup old error attached to field
    this._cleanupOldErrors()

    for k in Object.keys(data.error)
      #Setting new error to field
      this.$[k].setCustomValidity(data.error[k].toString())
      this.$["#{k}_decorator"].error = data.error[k].toString()
    this.isFormValid()

  handleSuccess: (e, response)->
    window.location.assign('/events')

  _cleanupOldErrors: ->
    this.$.email.setCustomValidity('')
    this.$.password.setCustomValidity('')
    emailValidity = this.$.email.checkValidity()
    passwordValidity = this.$.password.checkValidity()
    this.$.email_decorator.isInvalid = !emailValidity
    this.$.password_decorator.isInvalid = !passwordValidity

