Polymer 'paper-game',
  created: ->
    this.data = {}

  ready: ->
    #Go to game page
    that = this
    this.shadowRoot.querySelector('core-image').addEventListener 'click', ->
      window.location.href = that.data.url
