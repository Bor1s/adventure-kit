Polymer 'profile-general',
  created: ->
    this.token = document.getElementsByName('csrf-token')[0].getAttribute('content')
    this.user = {}
    this.processing = false
    this.timezones = []

  domReady: ->
    this.$.user_fetcher.headers = {"Accept": "application/json"}
    this.$.user_fetcher.go()

  _image_uploader: ->
    this.shadowRoot.querySelector('file-input')

  submitForm: (e, detail, sender)->
    this.sendForm()

  showValidationErrors: ->
    for field in ['nickname', 'bio']
      validity = this.$[field].checkValidity()
      this.$["#{field}_decorator"].isInvalid = !validity
    
    # Have to use shadowRoot search beacuse Polymer has bug with
    # accessing this.$.whatever when element is inside <template if=>
    if this.user.has_plain_account
      for field in ['email', 'password', 'password_confirmation']
        element = this.shadowRoot.querySelector("##{field}")
        validity = element.checkValidity()
        this.shadowRoot.querySelector("##{field}_decorator").isInvalid = !validity

  sendForm: ->
    d = new FormData()
    d.append('authenticity_token', this.token)
    d.append('user[nickname]', this.user.nickname)
    d.append('user[bio]', this.user.bio)
    d.append('user[timezone]', this.user.timezone) if this.user.timezone
    d.append('user[avatar]', this.user.avatar) if this.user.avatar_changed
    if this.user.has_plain_account
      d.append('user[plain_account_attributes][id]', this.user.plain_account.id)
      d.append('user[plain_account_attributes][email]', this.user.plain_account.email)
      d.append('user[plain_account_attributes][password]', this.user.plain_account.password)
      if this.user.plain_account.password_confirmation && this.user.plain_account.password_confirmation.length > 0
        d.append('user[plain_account_attributes][password_confirmation]', this.user.plain_account.password_confirmation)

    this.$.form_sender.headers = {"Accept": "application/json"}
    this.$.form_sender.contentType = null
    this.$.form_sender.body = d
    this.$.form_sender.go()

  handleError: (e, error, xhr)->
    data = JSON.parse(error.xhr.responseText)
    #Cleanup old error attached to field
    this._cleanupOldErrors()
    for k in Object.keys(data.errors)
      #Setting new error to field
      this.shadowRoot.querySelector("##{k}").setCustomValidity(data.errors[k].toString())
      this.shadowRoot.querySelector("##{k}_decorator").error = data.errors[k].toString()
    this.showValidationErrors()

  handleSuccess: (e, response)->
    this.$.dataStatus.show()
    this._cleanupOldErrors()
    #Reset password fields
    if this.user.has_plain_account
      this.user.plain_account.password = ''
      this.user.plain_account.password_confirmation = ''

  handleUserSuccess: (e, response)->
    this.user = response.response.user
    this.timezones = response.response.meta.timezones
    this.handleImageUpload() #Enable avatar uploader only if user data fetched

  handleUserError: (e, error, xhr)->
    console.log error

  handleImageUpload: ()->
    that = this
    that._image_uploader().addEventListener 'change', (event)->
      validFiles = event.detail.valid
      if validFiles.length
        reader = new FileReader()
        reader.onload = (e)->
          previewArea = that.shadowRoot.querySelector('#avatar-preview')
          previewArea.innerHTML = ''
          img = new Image()
          img.src = reader.result
          previewArea.appendChild(img)
          that.user.avatar = validFiles[0]
          that.user.avatar_changed = true
        #actually read file
        reader.readAsDataURL(validFiles[0])
      else
        console.log 'file not supported'

  _cleanupOldErrors: ->
    for field in ['nickname', 'bio']
      this.$[field].setCustomValidity('')
      validity = this.$[field].checkValidity()
      this.$["#{field}_decorator"].isInvalid = !validity

    if this.user.has_plain_account
      for field in ['email', 'password', 'password_confirmation']
        element = this.shadowRoot.querySelector("##{field}")
        element.setCustomValidity('')
        validity = element.checkValidity()
        this.shadowRoot.querySelector("##{field}_decorator").isInvalid = !validity
    

