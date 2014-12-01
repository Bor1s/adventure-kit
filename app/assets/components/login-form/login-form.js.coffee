Polymer 'login-form',
  created: ->
    this.token = document.getElementsByName('csrf-token')[0].getAttribute('content')

  submitLoginForm: (e, detail, sender)->
    if this.formValid()
      this.sendForm()

  formValid: ->
    emailValidity = this.$.email.checkValidity()
    passwordValidity = this.$.password.checkValidity()
    this.$.email_decorator.isInvalid = !emailValidity
    this.$.password_decorator.isInvalid = !passwordValidity
    emailValidity && passwordValidity

  sendForm: ->
    this.$.form_sender.headers = '{"Accept": "application/json"}'
    this.$.form_sender.go()
