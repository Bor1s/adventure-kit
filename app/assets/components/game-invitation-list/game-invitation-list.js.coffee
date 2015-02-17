Polymer 'game-invitation-list',
  created: ->
    this.users = {}
    this.invitees = []

  domReady: ->
    that = this
    this.$.users_fetcher.headers = '{"Accept": "application/json"}'
    this.$.users_fetcher.go()
    this.$.invitation_selector.addEventListener 'core-activate', (e)->
      that.invitees = that.$.invitation_selector.selected

  getInvitees: ->
    this.invitees

  handleSuccess: (e, data)->
    this.users = data.response.users

  handleError: (e, data)->
    console.log 'error', data
