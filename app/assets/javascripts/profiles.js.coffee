# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

initTokenInput = ->
  input = $("#my-genres")
  input.tokenInput("/genres", {prePopulate: input.data('pre'), propertyToSearch: 'title', preventDuplicates: 'true', theme: 'playhard', hintText: 'Начните вводить название жанра или системы ...', searchingText: 'Ищем ...', noResultsText: 'Ничего не найдено :('})

$ ->
  initTokenInput()
$(document).on 'page:load', ->
  initTokenInput()
