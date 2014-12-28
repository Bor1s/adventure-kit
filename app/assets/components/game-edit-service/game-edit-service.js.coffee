Polymer 'game-edit-service',
  created: ->
    this.game = {}

  ready: ->
    that = this

  domReady: ->
    # Default filter to send on page load
    this.$.dispatcher.go()

  handleError: (e, error, xhr)->
    data = JSON.parse(error.xhr.responseText)
    console.log data

  handleSuccess: (e, data)->
    #Bind game back to view
    this.game = data.response.game
    pages = document.querySelector('#game-wizard-steps')
    pages._cache_key = data.response.cache_key
