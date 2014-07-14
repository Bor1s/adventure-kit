# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  loadRadar()
$(document).on 'page:load', ->
  loadRadar()

window.initRadar = ()->
  if $('#event-radar').length > 0
    lat = $('#event-radar').data('lat')
    lng = $('#event-radar').data('lng')
    myLatlng = new google.maps.LatLng(parseFloat(lat),parseFloat(lng))
    mapOptions =
      center: myLatlng
      zoom: 8
    map = new google.maps.Map(document.getElementById('event-radar'), mapOptions)
    mc = new MarkerClusterer(map)

    $.ajax
      url: '/locations'
      dataType: 'json'
      success: (data)->
        markers = []
        for d in data
          _marker = new google.maps.Marker
            position: new google.maps.LatLng(parseFloat(d.lat),parseFloat(d.lng))
            map: map
          markers.push _marker
        mc.addMarkers(markers)

loadRadar = ()->
  if $('#event-radar').length > 0
    script = document.createElement('script')
    script.type = 'text/javascript'
    script.id = 'event-radar-script'
    script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp&language=ru&callback=initRadar&key=AIzaSyC5qjp9_GkTBzAyMQZbw28ALlmj9liuYoA'
    document.body.appendChild(script)
  else
    $('#event-radar-script').remove()

