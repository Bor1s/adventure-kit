Polymer 'users-service',
  created: ->
    this.users = []
    this.searchText = ''
    this.isHidden = true
    this.page = 1
    this.resetPages = false

  searchTextChanged: (attrName, oldVal, newVal)->
    this.fetchUsers()

  domReady: ->
    that = this
    # Listening for search input text changes
    document.querySelector('#search').addEventListener 'input', (e)->
      that.resetUsersPaging()
      that.searchText = e.target.value

    # Listening for load more link click
    document.querySelector('#loadMore').addEventListener 'click', (e)->
      that.page += 1
      that.resetPages = false
      that.fetchUsers()

    # Default filter to send on page load
    this.$.dispatcher.go()

  handleError: (e, error, xhr)->
    data = JSON.parse(error.xhr.responseText)
    console.log data

  handleSuccess: (e, data)->
    #Bind users back to view
    if this.resetPages
      this.users = data.response.users
    else
      this.users = this.users.concat(data.response.users)

    if data.response.meta.can_load_more
      this.isHidden = false
    else
      this.isHidden = true

    # Show toast if no games found
    document.querySelector('#no_users_toast').show() unless data.response.users.length > 0

  fetchUsers: ->
    this.$.dispatcher.go()

  resetUsersPaging: ->
    # When user changes search criteria
    # we should reset page to 1
    this.resetPages = true
    this.page = 1
