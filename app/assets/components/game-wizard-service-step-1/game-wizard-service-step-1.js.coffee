Polymer 'game-wizard-service-step-1',
  created: ->
    this.game =
      title: ''
      description: ''

    this.token = document.getElementsByName('csrf-token')[0].getAttribute('content')
    this.step = 1

  domReady: ->
    that = this
    that._title = document.querySelector('#title')
    that._title_decorator = document.querySelector('#title_decorator')
    that._description = document.querySelector('#description')
    that._description_decorator = document.querySelector('#description_decorator')
    that._pages_container = document.querySelector('#game-wizard-steps')

    document.querySelector('#step1-submit').addEventListener 'click', ->
      that.sendForm()

  isFormValid: ->
    titleValidity = this._title.checkValidity()
    descriptionValidity = this._description.checkValidity()

    this._title_decorator.isInvalid = !titleValidity
    this._description_decorator.isInvalid = !descriptionValidity
    titleValidity && descriptionValidity

  sendForm: ->
    d = new FormData()
    d.append('authenticity_token', this.token)
    d.append('step', this.step)
    d.append('cache_key', this._pages_container._cache_key || '')
    d.append('game[title]', this.game.title)
    d.append('game[description]', this.game.description)

    this.$.dispatcher.headers = {"Accept": "application/json"}
    this.$.dispatcher.contentType = null
    this.$.dispatcher.body = d
    this.$.dispatcher.go()

  handleError: (e, error, xhr)->
    data = JSON.parse(error.xhr.responseText)

    #Cleanup old error attached to field
    this._cleanupOldErrors()

    for k in Object.keys(data.errors)
      #Setting new error to field
      this["_#{k}"].setCustomValidity(data.errors[k].toString())
      this["_#{k}_decorator"].error = data.errors[k].toString()
    this.isFormValid()

  handleSuccess: (e, data)->
    this._pages_container._cache_key = data.response.cache_key
    this._pages_container.selected += 1

  _cleanupOldErrors: ->
    this._title.setCustomValidity('')
    this._description.setCustomValidity('')

    titleValidity = this._title.checkValidity()
    descriptionValidity = this._description.checkValidity()

    this._title_decorator.isInvalid = !titleValidity
    this._description_decorator.isInvalid = !descriptionValidity
