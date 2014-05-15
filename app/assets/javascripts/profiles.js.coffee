# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
loadChart = ->
  $.ajax
    url: '/profile/heatmap'
    dataType: 'json'
    success: (data)->
      $('#container').highcharts
        chart:
          type: 'heatmap'
          marginTop: 10
          marginBottom: 40
          style:
            fontFamily: "tahoma, arial, verdana, sans-serif, 'Lucida Sans', sans-serif"
            fontSize: '10px'
        title:
          text: null
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
          offset: 0
        colorAxis:
          min: 0,
          minColor: '#FFFFFF',
          maxColor: Highcharts.getOptions().colors[6]
        legend:
          align: 'right'
          layout: 'vertical'
          margin: 0
          verticalAlign: 'top'
          y: 10
        tooltip:
          headerFormat: ''
          pointFormat: "<b>{point.value} игр(ы)</b> на {point.day} {point.human_name}"
          hideDelay: true
          distance: 20
          followPointer: true
        series: [{
          data: data.data,
          nullColor: '#fff',
          borderColor: 'black',
          borderWidth: 0.1,
          allowPointSelect: true,
          cursor: 'pointer',
          states:
            hover:
              color: '#eee'
            select:
              color: '#e11012'
          point:
            events:
              select: (e) ->
                lis = ""
                for g in this.games
                  lis += "<li>#{g.beginning_at} #{g.title}</li>"
                link = "<p><a href='/games/new?date=#{this._full_date}' target='_blank'>Назначить игру</a></p>"
                html = "<h5>#{this.day} #{this.human_name}</h5><ul class='list-unstyled'>#{lis}</ul>#{link}"
                $('#day-info').html(html)
          dataLabels: {
            enabled: true,
            color: '#000',
            style: {
              textShadow: 'none'
              fontSize: '8px'
              fontWeight: 'normal'
            }
          }
        }]


$ ->
  loadChart()
$(document).on 'page:load', ->
  loadChart()
