# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).on 'page:load', ->
  editComment()
  saveComment()
  cancelComment()

$ ->
  editComment()
  saveComment()
  cancelComment()

editComment = ->
  $('.message-editable').focus ()->
    area = $("<textarea class='form-control editable-comment' id=#{$(this).attr('id')}>#{$(this).text()}</textarea>")
    $(this).hide()
    area.insertAfter($(this))
    $("a[data-comment-id=#{$(this).attr('id')}]").show()

saveComment = ->
  $('.save-message').click (e)->
    e.preventDefault()
    gameId = $(this).data('game-id')
    commentId = $(this).data('comment-id')
    textarea = $("textarea[id=#{commentId}]")
    p = $("p[id=#{commentId}]")
    links = $("a[data-comment-id=#{commentId}]").show()
    $.ajax
      url: "/games/#{gameId}/comments/#{commentId}"
      data:
        comment:
          message: textarea.val()
      type: 'PUT'
      success: (data)->
        p.text(data.message)
        textarea.remove()
        p.show()
        links.hide()

cancelComment = ->
  $('.cancel-message').click (e)->
    e.preventDefault()
    commentId = $(this).data('comment-id')
    $("textarea[id=#{commentId}]").remove()
    $("p[id=#{commentId}]").show()
    $("a[data-comment-id=#{commentId}]").hide()
    $(this).hide()
