Polymer 'profile-games',
  created: ->
    this.token = document.getElementsByName('csrf-token')[0].getAttribute('content')
    this.games = {}

  domReady: ->
    this.$.games_fetcher.headers = {"Accept": "application/json"}
    this.$.games_fetcher.go()

  handleError: (e, error, xhr)->
    data = JSON.parse(error.xhr.responseText)
    console.log data

  handleSuccess: (e, response)->
    this.games = response.response.games

  showGame: (e, i, element)->
    url = element.attributes['data-game-url'].value
    window.location.href = url

  deleteGame: (e, i, element)->
    cnf = confirm('Удалить?')
    if cnf
      id = element.attributes['data-game-id'].value
      index = null
      game = null

      this.games.forEach (value,idx)->
        if value.id == id
          index = idx
          game = value

      this.games.splice(index, 1)
      this._removeGame(game)

  _removeGame: (game)->
    #Set authenticity_token via headers (Rails check headers as well)
    this.$.destroy_game.headers = {"Accept": "application/json", "X-CSRF-Token": this.token}
    this.$.destroy_game.url = game.destroy_url
    this.$.destroy_game.go()

  handleGameError: (e, error, xhr)->
    data = JSON.parse(error.xhr.responseText)
    console.log data

  handleGameSuccess: (e, response)->
    console.log response
    
