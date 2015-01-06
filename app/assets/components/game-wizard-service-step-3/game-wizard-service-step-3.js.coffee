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

  handleSuccess: (e, data)->
    this._pages_container()._cache_key = data.response.cache_key
    this._pages_container().selected += 1
