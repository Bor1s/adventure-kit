Polymer 'profile-menu-switcher',
  domReady: ->
    that = this
    document.querySelector('#profile-menu').addEventListener 'core-select', (e, detail)->
      e.detail.item.dataname = e.detail.item.getAttribute('dataname')
