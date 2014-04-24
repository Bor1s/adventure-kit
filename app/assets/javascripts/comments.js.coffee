# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#$(document).on 'page:load', ->

$ ->
  $("#new_comment").on "ajax:success", (e, data, status, xhr) ->
    $("#comment_message").val('')

$(document).on 'page:load', ->
  $("#new_comment").on "ajax:success", (e, data, status, xhr) ->
    $("#comment_message").val('')
