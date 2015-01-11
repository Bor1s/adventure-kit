Polymer 'game-wizard-service-step-3',
  created: ->
    this.token = document.getElementsByName('csrf-token')[0].getAttribute('content')
    this.step = 3

  domReady: ->
    that = this
    document.querySelector('#step3-submit').addEventListener 'click', ->
      that.sendForm()

  _pages_container: ->
    document.querySelector('#game-wizard-steps')

  _events_container: ->
    document.querySelector('game-events')

  sendForm: ->
    d = new FormData()
    d.append('authenticity_token', this.token)
    d.append('step', this.step)
    d.append('cache_key', this._pages_container()._cache_key || '')

    #Insert
    game_events = document.querySelector('game-events')
    events = game_events.events
    removed_events = game_events.removed_events
    for e in events
      #Hack for Rails to gently avoid strong params
      d.append("game[events_ui_ids][]", e.id)
      if e.new
        d.append("game[events_attributes][#{e.id}][beginning_at]", e.beginning_at)
      else
        d.append("game[events_attributes][#{e.id}][beginning_at]", e.beginning_at)
        d.append("game[events_attributes][#{e.id}][id]", e.id)

    for e in removed_events
      d.append("game[events_attributes][#{e.id}][id]", e.id)
      d.append("game[events_attributes][#{e.id}][_destroy]", '1')

    this.$.dispatcher.headers = {"Accept": "application/json"}
    this.$.dispatcher.contentType = null
    this.$.dispatcher.body = d
    this.$.dispatcher.go()

  handleError: (e, error, xhr)->
    data = JSON.parse(error.xhr.responseText)
    error_keys = Object.keys(data.errors)

    #If general error (no event sent at all)
    if data.errors.events_attributes
      console.log 'For new game at least one event must be set up!'
    else
      this._cleanupOldErrors(error_keys)
      for k in error_keys
        #Setting new error to field
        this._events_container().shadowRoot.querySelector("#beginning_at_#{k}").setCustomValidity(data.errors[k].toString())
        this._events_container().shadowRoot.querySelector("#beginning_at_decorator_#{k}").error = data.errors[k].toString()
      this.isFormValid(error_keys)

  handleSuccess: (e, data)->
    this._pages_container()._cache_key = data.response.cache_key
    this._pages_container().selected += 1

  _cleanupOldErrors: (error_keys)->
    for k in error_keys
      this._events_container().shadowRoot.querySelector("#beginning_at_#{k}").setCustomValidity('')
      validity = this._events_container().shadowRoot.querySelector("#beginning_at_#{k}").checkValidity()
      this._events_container().shadowRoot.querySelector("#beginning_at_decorator_#{k}").isInvalid = !validity

  isFormValid: (error_keys)->
    for k in error_keys
      validity = this._events_container().shadowRoot.querySelector("#beginning_at_#{k}").checkValidity()
      this._events_container().shadowRoot.querySelector("#beginning_at_decorator_#{k}").isInvalid = !validity
