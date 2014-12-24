Polymer 'game-service',
  created: ->
    this.games = {}

  ready: ->
    that = this
    document.querySelector('#game_drawer').addEventListener 'change', (e)->
      that.fetchGames(e, this)

  domReady: ->
    # Default filter to send on page load
    this.optionsToSend = 'my,realtime,upcoming'
    this.$.dispatcher.go()

  handleError: (e, error, xhr)->
    data = JSON.parse(error.xhr.responseText)
    console.log data

  handleSuccess: (e, data)->
    #Bind games back to view
    this.games = data.response.events

    # Show toast if no games found
    document.querySelector('#no_games_toast').show() unless data.response.events.length > 0

  sendData: (optionValues)->
    this.optionsToSend = optionValues
    this.$.dispatcher.go()

  fetchGames: (e, game_drawer)->
    # Get values from all 'checked' radio buttons and push them into array
    # to send via AJAX 
    allRadioGroups = game_drawer.querySelectorAll('paper-radio-group')
    otherRadioGroups = []
    for i in allRadioGroups
      otherRadioGroups.push(i) unless i == e.target.parentElement
    filterOptions = for otherRadioGroup in otherRadioGroups
      for radio in otherRadioGroup.querySelectorAll('paper-radio-button[aria-checked="true"]')
        radio.attributes.name.value
    filterOptions.push(e.target.attributes.name.value)

    this.sendData(filterOptions)

