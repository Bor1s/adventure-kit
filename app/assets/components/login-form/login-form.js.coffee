Polymer 'login-form',
  validate: (e, detail, sender)->
    this.$.email_decorator.isInvalid = !this.$.email.validity.valid
