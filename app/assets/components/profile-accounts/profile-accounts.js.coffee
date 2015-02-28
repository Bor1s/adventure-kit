Polymer 'profile-accounts',
  created: ->
    this.token = document.getElementsByName('csrf-token')[0].getAttribute('content')
    this.accounts = {}
    this.lastAccount = false
    this.error_msg = ''

  domReady: ->
    this.$.accounts_fetcher.headers = {"Accept": "application/json"}
    this.$.accounts_fetcher.go()

    if this.error_msg
      this.$.notificator.text = this.error_msg
      this.$.notificator.duration = 5000
      this.$.notificator.show()

  handleError: (e, error, xhr)->
    data = JSON.parse(error.xhr.responseText)
    console.log data

  handleSuccess: (e, response)->
    this.accounts = response.response.profiles
    this.lastAccount = response.response.meta.last_account

  showAccount: (e, i, element)->
    url = element.attributes['data-account-url'].value
    window.location.href = url

  deleteAccount: (e, i, element)->
    cnf = confirm('Удалить?')
    if cnf
      id = element.attributes['data-account-id'].value
      this._removeAccount(id)

  _removeAccount: (accountId)->
    #Set authenticity_token via headers (Rails check headers as well)
    this.$.destroy_account.headers = {"Accept": "application/json", "X-CSRF-Token": this.token}
    this.$.destroy_account.params = {'id': accountId}
    this.$.destroy_account.go()

  handleRemoveAccountError: (e, error, xhr)->
    data = JSON.parse(error.xhr.responseText)
    this.$.notificator.text = data.error
    this.$.notificator.show()

  handleRemoveAccountSuccess: (e, response)->
    # Refetch accounts to know how many of them left
    this.$.accounts_fetcher.go()
    this.$.notificator.text = 'Аккаунт удален из вашего профиля.'
    this.$.notificator.show()
