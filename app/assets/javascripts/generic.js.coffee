initTokenInput = ->
  input = $("#tags")
  input.select2
    tokenSeparators: [' ']
    placeholder: 'Один или больше тегов, например (D&D4ed Fallout)'
    tags: true
    createSearchChoice: (term, data)->
      existing_term = data.filter (d)-> d.text == term
      if existing_term.length == 0
        {id: "#{term}_new", text: term}
    query: (query)->
      _data = results: []
      $.ajax
        url: '/tags'
        dataType: 'json'
        data:
          q: query.term
        success: (data)->
          for d in data
            _data.results.push {id: d.id, text: d.text }
          query.callback(_data)

  input.select2 'data', input.data('pre')

initPicker = ->
  $('.calendar').on 'click', (e)->
    e.preventDefault()
    e.stopPropagation()
    _picker = $(this).parent().parent().find('.dtpicker')
    _picker.datetimepicker
      lang: 'ru'
      format: 'd-m-Y H:i'
      dayOfWeekStart: 1
    _picker.datetimepicker('show')

initCocoonPicker = ->
  $('.events').on 'cocoon:after-insert', ->
    initPicker()

#Do not allow to remove last standing event
checkLastEventCannotBeRemoved = ->
  if $('.nested-fields').filter(':visible').length == 1
    $('.nested-fields .remove_fields').hide()
  else
    $('.nested-fields .remove_fields').show()

cocoonEvents = ->
  $('.events').on 'cocoon:after-insert', ->
    checkLastEventCannotBeRemoved()

  $('.events').on 'cocoon:after-remove', ->
    checkLastEventCannotBeRemoved()

# Page load
$ ->
  $('img').tooltip()
  initTokenInput()
  initPicker()
  initCocoonPicker()
  checkLastEventCannotBeRemoved()
  cocoonEvents()

# Turbolinks ajax body reload
$(document).on 'page:load', ->
  $('img').tooltip()
  initTokenInput()
  initPicker()
  initCocoonPicker()
  checkLastEventCannotBeRemoved()
  cocoonEvents()

