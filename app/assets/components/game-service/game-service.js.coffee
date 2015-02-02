Polymer 'game-service',
  created: ->
    this.games = {}
    this.searchText = ''

  searchTextChanged: (attrName, oldVal, newVal)->
    filterOptions = []
    for radio in document.querySelector('#game_drawer').querySelectorAll('paper-radio-button[aria-checked="true"]')
      filterOptions.push(radio.attributes.name.value)
    this.sendData(filterOptions)

  ready: ->
    that = this

    # Listening for search input text changes
    document.querySelector('#game_drawer').addEventListener 'change', (e)->
      that.fetchGames(e, this)

  domReady: ->
    that = this
    document.querySelector('#search').addEventListener 'input', (e)->
      that.searchText = e.target.value

    # Default filter to send on page load
    this.optionsToSend = 'upcoming,my'
    this.$.dispatcher.go()

  handleError: (e, error, xhr)->
    data = JSON.parse(error.xhr.responseText)
    console.log data

  handleSuccess: (e, data)->
    #Bind games back to view
    this.games = data.response.games

    # Show toast if no games found
    document.querySelector('#no_games_toast').show() unless data.response.games.length > 0

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

