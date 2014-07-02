# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  $('#events-carousel').carousel()
  loadScript()
$(document).on 'page:load', ->
  $('#events-carousel').carousel()
  loadScript()

window.initMap = ()->
  if $('#event-map').length > 0
    lat = $('#event-map').data('lat')
    lng = $('#event-map').data('lng')
    myLatlng = new google.maps.LatLng(parseFloat(lat),parseFloat(lng))
    mapOptions =
      center: myLatlng
      zoom: 8
    map = new google.maps.Map(document.getElementById("event-map"), mapOptions)

    # Place a draggable marker on the map
    marker = new google.maps.Marker
      position: myLatlng
      map: map
      draggable: true
      animation: google.maps.Animation.DROP
      title: "Drag me!"

    setCoordinates = (latLng)->
      $('#game_location_attributes_text_coordinates').val(latLng)

    fnDragend = (event)->
      setCoordinates(event.latLng.toUrlValue())

    fnResize = (event)->
      map.setCenter(marker.getPosition())

    fnClick = (event)->
      marker.setPosition(event.latLng)
      setCoordinates(event.latLng.toUrlValue())

    google.maps.event.addListener(marker, 'dragend', fnDragend)
    google.maps.event.addDomListener(window, 'resize', fnResize)
    google.maps.event.addListener(map, 'click', fnClick)

loadScript = ()->
  script = document.createElement('script')
  script.type = 'text/javascript'
  script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp&callback=initMap&key=AIzaSyC5qjp9_GkTBzAyMQZbw28ALlmj9liuYoA'
  document.body.appendChild(script)

