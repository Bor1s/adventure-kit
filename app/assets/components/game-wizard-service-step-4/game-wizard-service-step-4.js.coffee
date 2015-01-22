Polymer 'game-wizard-service-step-4',
  created: ->
    this.token = document.getElementsByName('csrf-token')[0].getAttribute('content')
    this.step = 4
    this.fileData = ''
    this.gameCreated = false

  domReady: ->
    that = this

    #Handle form submit
    document.querySelector('#step4-submit').addEventListener 'click', ->
      that.sendForm()

    #Handle prev button
    document.querySelector('#step4-prev').addEventListener 'click', ->
      that.rollBack()

    that.handleImageUpload()

  _pages_container: ->
    document.querySelector('#game-wizard-steps')

  _image_uploader: ->
    document.querySelector('file-input')

  rollBack: ->
    this._pages_container().selected -= 1

  sendForm: ->
    d = new FormData()
    d.append('authenticity_token', this.token)
    d.append('step', this.step)
    d.append('cache_key', this._pages_container()._cache_key || '')
    d.append('game[poster]', this.fileData || '')

    this.$.dispatcher.headers = {"Accept": "application/json"}
    this.$.dispatcher.contentType = null
    this.$.dispatcher.body = d
    this.$.dispatcher.go()

  handleError: (e, error, xhr)->
    data = JSON.parse(error.xhr.responseText)
    error_keys = Object.keys(data.errors)
    console.log error_keys

  handleSuccess: (e, data)->
    this.gameCreated = true

    #Game property already exists via component attributes,
    #so we assign id right to game
    this.game.id = data.response.cache_key

  handleImageUpload: ()->
    that = this
    that._image_uploader().addEventListener 'change', (event)->
      validFiles = event.detail.valid
      if validFiles.length
        reader = new FileReader()
        reader.onload = (e)->
          previewArea = document.querySelector('#poster-preview')
          previewArea.innerHTML = ''
          img = new Image()
          img.src = reader.result
          previewArea.appendChild(img)
          that.fileData = reader.result

        #actually read file
        reader.readAsDataURL(validFiles[0])
      else
        console.log 'file not supported'
