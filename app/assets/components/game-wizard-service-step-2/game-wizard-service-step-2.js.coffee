Polymer 'game-wizard-service-step-2',
  created: ->
    this.token = document.getElementsByName('csrf-token')[0].getAttribute('content')
    this.step = 2

  domReady: ->
    that = this
    #Private/Public game type checkboxes handler
    that._game_privacy().addEventListener 'change', (e)->
      if e.target.attributes.name.value == 'private'
        that.game.private_game = true
      else
        that.game.private_game = false

    #Private/Public game type checkboxes handler
    that._game_location().addEventListener 'change', (e)->
      if e.target.attributes.name.value == 'online'
        that.game.online_game = true
      else
        that.game.online_game = false

    #Handle submit form button
    document.querySelector('#step2-submit').addEventListener 'click', ->
      that.sendForm()

  _pages_container: ->
    document.querySelector('#game-wizard-steps')
  _game_privacy: ->
    document.querySelector('#game-privacy')
  _game_location: ->
    document.querySelector('#game-location')
  _players_amount_selector: ->
    document.querySelector('#players-amount')
  _address: ->
    document.querySelector('#address')
  _address_decorator: ->
    document.querySelector('#address_decorator')
  _online_info: ->
    document.querySelector('#online_info')
  _online_info_decorator: ->
    document.querySelector('#online_info_decorator')

  getPlayersAmount: ->
    #Return players amount value from dropdown field
    this._players_amount_selector().selected

  getOnlineInfo: ->
    this._online_info().value

  getAddress: ->
    this._address().value

  isFormValid: ->
    if this.game.online_game
      onlineInfoValidity = this._online_info().checkValidity()
      this._online_info_decorator().isInvalid = ! onlineInfoValidity
      onlineInfoValidity
    else
      addressValidity = this._address().checkValidity()
      this._address_decorator().isInvalid = !addressValidity
      addressValidity

  sendForm: ->
    d = new FormData()
    d.append('authenticity_token', this.token)
    d.append('step', this.step)
    d.append('cache_key', this._pages_container()._cache_key || '')

    #Set fields for public/private game
    if this.game.private_game
      invitees = document.querySelector('game-invitation-list').getInvitees()
      d.append('game[private_game]', true)
      for i in invitees
        d.append('game[invitees][]', i)
    else
      d.append('game[private_game]', false)
      d.append('game[players_amount]', this.getPlayersAmount())

    #Set fields for online/location-based game
    if this.game.online_game
      d.append('game[online_game]', true)
      d.append('game[online_info]', this.getOnlineInfo())
    else
      d.append('game[online_game]', false)
      d.append('game[address]', this.getAddress())

    this.$.dispatcher.headers = {"Accept": "application/json"}
    this.$.dispatcher.contentType = null
    this.$.dispatcher.body = d
    this.$.dispatcher.go()

  handleError: (e, error, xhr)->
    data = JSON.parse(error.xhr.responseText)

    #Cleanup old error attached to field
    this._cleanupOldErrors()

    for k in Object.keys(data.errors)
      #Set new error to field if it exists
      if this["_#{k}"]
        this["_#{k}"]().setCustomValidity(data.errors[k].toString())
        this["_#{k}_decorator"]().error = data.errors[k].toString()
    this.isFormValid()

  handleSuccess: (e, data)->
    this._pages_container()._cache_key = data.response.cache_key
    this._pages_container().selected += 1

  _cleanupOldErrors: ->
    if this.game.online_game
      this._online_info().setCustomValidity('')
      onlineInfoValidity = this._online_info().checkValidity()
      this._online_info_decorator().isInvalid = ! onlineInfoValidity
    else
      this._address().setCustomValidity('')
      addressValidity = this._address().checkValidity()
      this._address_decorator().isInvalid = !addressValidity

