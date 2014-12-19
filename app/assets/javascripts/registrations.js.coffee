# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('#login').click ->
    document.querySelector('#login-collapse').toggle()
    document.querySelector('#register-collapse').opened = false

  $('#register').click ->
    document.querySelector('#register-collapse').toggle()
    document.querySelector('#login-collapse').opened = false
