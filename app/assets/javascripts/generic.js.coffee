initTokenInput = ->
  input = $("#tags")
  input.select2
    tokenSeparators: [' ']
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

$ ->
  initTokenInput()
$(document).on 'page:load', ->
  initTokenInput()
