# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  loadRadar()
$(document).on 'page:load', ->
  loadRadar()

window.initRadar = ()->
  if $('#event-radar').length > 0
    mapOptions =
      zoom: 8
    infowindow = new google.maps.InfoWindow()
    map = new google.maps.Map(document.getElementById('event-radar'), mapOptions)
    mc = new MarkerClusterer(map)
    setMarkersForCurrentLocation(map, mc, infowindow)

loadRadar = ()->
  if $('#event-radar').length > 0
    script = document.createElement('script')
    script.type = 'text/javascript'
    script.id = 'event-radar-script'
    script.src = 'https://maps.googleapis.com/maps/api/js?v=3.exp&language=ru&callback=initRadar&key=AIzaSyC5qjp9_GkTBzAyMQZbw28ALlmj9liuYoA'
    document.body.appendChild(script)
  else
    $('#event-radar-script').remove()

setMarkersForCurrentLocation = (map, mc, infowindow)->
  lat = $('#event-radar').data('lat')
  lng = $('#event-radar').data('lng')

  if navigator.geolocation
    navigator.geolocation.getCurrentPosition(
      (position)->
        _coords = new google.maps.LatLng(position.coords.latitude, position.coords.longitude)
        map.setCenter(_coords)
        loadGames(map, mc, infowindow)
      ()->
        _coords = new google.maps.LatLng(parseFloat(lat),parseFloat(lng))
        map.setCenter(_coords)
        loadGames(map, mc, infowindow)
    )
  else
    _coords = new google.maps.LatLng(parseFloat(lat),parseFloat(lng))
    map.setCenter(_coords)
    loadGames(map, mc, infowindow)

loadGames = (map, mc, infowindow)->
  $.ajax
    url: '/locations'
    dataType: 'json'
    data:
      lat: map.getCenter().lat()
      lng: map.getCenter().lng()
    success: (data)->
      markers = []
      for d in data
        _marker = new google.maps.Marker
          position: new google.maps.LatLng(parseFloat(d.lat),parseFloat(d.lng))
          map: map
        markers.push _marker

        #Add info window
        google.maps.event.addListener(_marker, 'click', ()->
          infowindow.setContent("<div><a href='#{d.url}'>#{d.title}</a></div>")
          infowindow.open(map,_marker)
        )
      mc.addMarkers(markers)
      renderNearbyGames(data)

renderNearbyGames = (data)->
  $('#nearby-events').html('')
  html = ''
  for d in data
    html += "<div><a href='#{d.url}'>#{d.title}</a></div>"
  $('#nearby-events').html(html)
