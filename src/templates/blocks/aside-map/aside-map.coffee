initMap = ->
  docMaps.mapOffsetTop = $('.widget-map').offset().top
  @map = new (google.maps.Map)(document.getElementById('map-canvas-right'), mapOptions)
  @mapCss.inner()