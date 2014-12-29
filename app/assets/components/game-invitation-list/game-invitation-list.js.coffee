Polymer 'game-invitation-list',
  created: ->
    this.accounts = {}
    this.invitees = []

  domReady: ->
    that = this
    this.$.accounts_fetcher.go()
    this.$.invitation_selector.addEventListener 'core-activate', (e)->
      that.invitees = that.$.invitation_selector.selected

  getInvitees: ->
    this.invitees

  handleSuccess: (e, data)->
    this.accounts = data.response.accounts

  handleError: (e, data)->
    console.log 'error', data
