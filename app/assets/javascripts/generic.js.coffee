initTokenInput = ->
  input = $("#tags")
  input.tokenInput("/genres", {prePopulate: input.data('pre'), propertyToSearch: 'title', preventDuplicates: 'true', theme: 'playhard', hintText: 'Начните вводить название жанра или системы ...', searchingText: 'Ищем ...', noResultsText: 'Ничего не найдено :('})

$ ->
  initTokenInput()
$(document).on 'page:load', ->
  initTokenInput()
