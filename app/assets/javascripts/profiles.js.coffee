# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
loadChart = ->
  $.ajax
    url: '/profile/my_games'
    dataType: 'json'
    success: (data)->
      $('#container').highcharts
        chart:
          type: 'heatmap'
          marginTop: 40
          marginBottom: 40
        title:
          text: data.title
        xAxis:
          type: 'category'
          tickLength: 0
          lineWidth: 0
          labels:
            step: data.step
        yAxis:
          categories: data.days
          lineWidth: 0
          title: null
          gridLineWidth: 0
          offset: 10
        colorAxis:
          minColor: '#FFFFFF'
          maxColor: Highcharts.getOptions().colors[0]
        legend:
          align: 'right'
          layout: 'vertical'
          margin: 0
          verticalAlign: 'top'
          y: 25
          symbolHeight: 320
        tooltip:
          formatter: ->
            "<b>#{this.point.name} #{this.point.day}</b><br />Игр: #{(this.point.value + 0)}<br />"
        series: [{
                borderWidth: 0.2,
                data: data.data,
                nullColor: '#fff',
                events:
                  click: (e) ->
                    window.location.href = "/games/new?date=#{e.point._full_date}"
                dataLabels: {
                  enabled: true,
                  color: '#000',
                  style: {
                    textShadow: 'none'
                    fontSize: '9px'
                  }
                }
            }]


$ ->
  loadChart()
$(document).on 'page:load', ->
  loadChart()
