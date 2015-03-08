Polymer 'game-service',
  created: ->
    this.games = []
    this.searchText = ''
    this.isHidden = true
    this.page = 1
    this.resetPages = false

  searchTextChanged: (attrName, oldVal, newVal)->
    this.fetchGames()

  ready: ->
    that = this
    # Listening for games filter radios changes
    document.querySelector('#game_drawer').addEventListener 'change', (e)->
      that.resetGamesPaging()
      filterOptions = that.pickFilterOptions(e, this)
      that.sendData(filterOptions)

  domReady: ->
    that = this
    # Listening for search input text changes
    document.querySelector('#search').addEventListener 'input', (e)->
      that.resetGamesPaging()
      that.searchText = e.target.value

    # Listening for load more link click
    document.querySelector('#loadMore').addEventListener 'click', (e)->
      that.page += 1
      that.resetPages = false
      that.fetchGames()

    # Default filter to send on page load
    this.optionsToSend = ''
    this.$.dispatcher.go()

  handleError: (e, error, xhr)->
    data = JSON.parse(error.xhr.responseText)
    console.log data

  handleSuccess: (e, data)->
    #Bind games back to view
    if this.resetPages
      this.games = data.response.games
    else
      this.games = this.games.concat(data.response.games)

    if data.response.meta.can_load_more
      this.isHidden = false
    else
      this.isHidden = true

    # Show toast if no games found
    document.querySelector('#no_games_toast').show() unless data.response.games.length > 0

  sendData: (optionValues)->
    this.optionsToSend = optionValues
    this.$.dispatcher.go()

  pickFilterOptions: (e, game_drawer)->
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
    filterOptions

  fetchGames: ->
    filterOptions = []
    for radio in document.querySelector('#game_drawer').querySelectorAll('paper-radio-button[aria-checked="true"]')
      filterOptions.push(radio.attributes.name.value)
    this.sendData(filterOptions)

  resetGamesPaging: ->
    # When user changes search criteria
    # we should reset page to 1
    this.resetPages = true
    this.page = 1
    #this.games = []
