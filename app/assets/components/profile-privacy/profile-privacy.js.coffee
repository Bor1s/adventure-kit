Polymer 'profile-privacy',
  created: ->
    this.token = document.getElementsByName('csrf-token')[0].getAttribute('content')
    this.accounts = {}

  accountsChanged: ->
    this.async(this.initCheckboxes, [])

  domReady: ->
    this.$.accounts_fetcher.headers = {"Accept": "application/json"}
    this.$.accounts_fetcher.go()

  sendForm: (url, data)->
    d = new FormData()
    d.append('authenticity_token', this.token)
    d.append('account[open_to_others]', data)
    this.$.form_sender.url = url
    this.$.form_sender.headers = {"Accept": "application/json"}
    this.$.form_sender.contentType = null
    this.$.form_sender.body = d
    this.$.form_sender.go()

  handleSuccess: (e, response)->
    this.accounts = response.response.accounts

  handleError: (e, error, xhr)->
    data = JSON.parse(error.xhr.responseText)

  handleUpdateSuccess: (e, resp, xhr)->
    account = resp.response.account || resp.response.plain_account
    if account.open_to_others
      this.$.notificator.text = 'Аккаунт открыт для других пользователей.'
    else
      this.$.notificator.text = 'Аккаунт скрыт от других пользователей.'
    this.$.notificator.show()

  handleUpdateError: (e, error, xhr)->
    data = JSON.parse(error.xhr.responseText)
    this.$.notificator.text = data.error
    this.$.notificator.show()

  initCheckboxes: ->
    that = this
    for c in this.shadowRoot.querySelectorAll('paper-checkbox')
      c.addEventListener 'change', (e)->
        that.sendForm(e.target.getAttribute('data-url'), e.target.checked)
