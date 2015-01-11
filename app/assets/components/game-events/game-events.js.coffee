Polymer 'game-events',
  created: ->
    this.events = []
    this.removed_events = []

  eventsChanged: ->
    this.async(this.initDatepicker, [])

  domReady: ->
    #If url is empty it means that we creating new game with new events
    #so we must activate datepicker only on add_event input field
    if this.url == ''
      this.initDatepicker()
    else
      this.$.events_fetcher.go()

  addEvent: ->
    #Check that input value has proper format
    if (/\d+-\d+-\d+\s\d+:\d+/).test(this.$.new_beginning_at.value)
      this.events.push({id: new Date().getTime().toString(), new: true, beginning_at: this.$.new_beginning_at.value})
    this.$.new_beginning_at.value = ''

  removeEvent: (e)->
    eventId = e.target.attributes['data-event-id'].value
    _new = e.target.attributes['data-new'].value
    this.removed_events.push({id: eventId, deleted: true}) unless _new == 'true'
    this.events = this.events.filter (e)-> e.id != eventId

  handleError: (e, error, xhr)->
    data = JSON.parse(error.xhr.responseText)
    console.log data

  handleSuccess: (e, data)->
    this.events = data.response.events

  initDatepicker: ->
    $(this.shadowRoot.querySelectorAll('.calendar')).datetimepicker(
      lang: 'ru'
      defaultDate: new Date()
      format: 'd-m-Y H:i'
      dayOfWeekStart: 1
    )
