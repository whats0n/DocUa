docMaps =
  icon1: exports ? 'i/pin.png'
  icon2: exports ? 'i/pin-active.png'
  addNewMarker: ''
  city: ''
  pageName: ''
  mapOffsetTop: 0
  canAnimateTop: true
  popupMarker: ''
  pageName: ''
  markersList: []
  allItemsList: []
  map: {}
  geocoder: {}
  cardId: 0
  domain: ''
  initialize: (allItemsList, pageName, city, domain) ->
    @allItemsList = allItemsList
    @city = city
    @domain = domain
    @pageName = pageName
    @geocoder = new (google.maps.Geocoder)
    latlng = new (google.maps.LatLng)(-50.446, -30.515)
    mapOptions =
      zoom: 10
      center: latlng

    if @pageName == 'map'
      @mapCss.bigMap()
      @map = new (google.maps.Map)(document.getElementById('map-canvas-big'), mapOptions)
      @listeners.common @map
      @newScope()
    else
      docMaps.mapOffsetTop = $('.widget-map').offset().top
      @map = new (google.maps.Map)(document.getElementById('map-canvas-right'), mapOptions)
      if @pageName == 'doctorInner' or @pageName == 'clinicInner'
        @mapCss.inner()
      else
        @mapCss.index()
        $(window).scroll ->
          docMaps.mapCss.index()
        @listeners.common @map
      @newScope()
      @mapModal()

  newScope: (list) ->
    if list
      @allItemsList = list
    if @pageName == 'doctorInner'
      @addNewMarker = @addMarker.inner()
      @addNewMarker()
    else
      @addNewMarker = @addMarker.clinics()
      @addNewMarker()

  scrollInit: () ->
    if @scrollApi
      @scrollApi.destroy()
      @scrollApi = ''
    scrollObj = $('.short-list__items-wrapper')
    scrollObj.width($('.big-map__widget').width())
    scrollObj.height(@mapHeight - $('.short-list__header').outerHeight(true))
    @scrollApi = scrollObj.jScrollPane(
      verticalGutter: 0
      verticalDragMaxHeight: 30
    ).data().jsp

  loadDoctors: (filter, filterValue) ->
    $('.short-list__items').html('')
    $.ajax
      url: 'https://' + docMaps.domain + '/api/doctor/doctors?' + filter + '=' + filterValue
      data: {}
      success: (data) ->
        for i in [0..data.length - 1]
          d = data[i]
          tpl = '<li class="short-list__item"> <div class="male short-list__image"><img src="' + 'https://' + docMaps.domain + d.image + '" alt=""> </div>' +
            '<div class="short-list__item-content"><a href="/doctor-consultation.html" title="' + d.name + '" class="short-list__title">' + d.name + '</a>' +
            '<div class="short-list__label">' + d.specialty + '</div> <div class="rating"> <div class="rating__stars"> <div class="rating__stars-bg"> </div> <div style="width: ' + d.rating * 20 + '%;" class="rating__stars-overlay"> </div> </div> <div class="rating__value value">' + d.rating + ' </div> </div> </div> </li>'
          $('.short-list__items').append(tpl)
        docMaps.scrollInit()
          
  mapModal: ->
    geocoder = new (google.maps.Geocoder)
    latlng = new (google.maps.LatLng)(-50.446, -30.515)
    mapOptions =
      zoom: 10
      center: latlng
    map= new (google.maps.Map)(document.getElementById('modal-map'), mapOptions)

    $('#clinic-location-map').on 'shown.bs.modal', (e) ->
      google.maps.event.trigger(map, "resize")
      index = docMaps.findMarker('id', $(e.relatedTarget).closest("[data-id]").data('id'))

      addInfo = {}
      if docMaps.markersList[index].addInfo.affilate
        addInfo.address = docMaps.markersList[index].addInfo.affilate.address
      else
        addInfo.address = docMaps.markersList[index].addInfo.address

      docMaps.popupMarker = new (google.maps.Marker)(
        map: map
        icon: docMaps.icon2
        position: docMaps.markersList[index].position)
      docMaps.fitMap [docMaps.popupMarker], map, 14

    $('#clinic-location-map').on 'hidden.bs.modal', (e) ->
      docMaps.popupMarker.setMap null

  mapCss:
    index: -> #clinics and doctors list side map
      navbarHeight = $('.navbar-main').outerHeight()

      if docMaps.mapOffsetTop - $(window).scrollTop() < 0
        $('#map-canvas-right, .widget-map').height($(window).height() - navbarHeight - 40)
        $('.widget-map').css
          width: $('.widget-map').width()
          position: 'fixed'

        if $('html').height() <= $(window).scrollTop() + $(window).height() + $('.row.footer').outerHeight(true) + $('.row-blog').outerHeight(true)
          docMaps.canAnimateTop = true
          $('aside').height($('aside').prev().height())
          $('.widget-map').css
            position: 'absolute'
            bottom: 10
            top: 'auto'
        else
          if docMaps.canAnimateTop
            docMaps.canAnimateTop = false
            $('.widget-map').animate
              top: navbarHeight + 20
        google.maps.event.trigger(docMaps.map, "resize")
      else
        mapHeight = $(window).height() - ($('.widget-map').offset().top - $(window).scrollTop()) - 20
        docMaps.canAnimateTop = true
        $('#map-canvas-right, .widget-map').height(mapHeight)
        $('.widget-map').css
          position: 'static'
          top: 'auto'

    inner: -> #one clinic or one doctor side map
      if docMaps.pageName == 'clinicInner'
        $('#map-canvas-right, .widget-map').height(600)
      else
        $('#map-canvas-right, .widget-map').height($('.card').outerHeight())

    bigMap: ->
      docMaps.mapHeight = $(window).height() - $('header.header').outerHeight(true) - $('.header__nav').outerHeight(true)
      docMaps.scrollInit()
      $('#map-canvas-big').height(docMaps.mapHeight)


  addMarker:
    clinics: () ->
      clinicIndex = 0
      affilateIndex = -1
      return ->
        if clinicIndex < @allItemsList.length

          addInfo = {}
          if clinicIndex == 0
            addInfo.active = true
          else
            addInfo.active = false

          addInfo.name = @allItemsList[clinicIndex].name
          addInfo.id = clinics[clinicIndex].id
          addInfo.image = @allItemsList[clinicIndex].image
          if @allItemsList[clinicIndex].affilates
            if affilateIndex == -1
              affilateIndex = 0

            addInfo.affilate = @allItemsList[clinicIndex].affilates[affilateIndex]
            address = @allItemsList[clinicIndex].affilates[affilateIndex].address

            if affilateIndex == @allItemsList[clinicIndex].affilates.length - 1
              affilateIndex = -1
              clinicIndex += 1
            else
              affilateIndex += 1
          else
            address = @allItemsList[clinicIndex].address
            addInfo.directions = @allItemsList[clinicIndex].directions
            addInfo.address = @allItemsList[clinicIndex].address
            addInfo.reviews = @allItemsList[clinicIndex].reviews
            addInfo.rating = @allItemsList[clinicIndex].rating
            clinicIndex += 1

          address += ' ' + @city
          @geocoder.geocode {'address': address}, (results, status) ->
            if status == google.maps.GeocoderStatus.OK
              if addInfo.active and not docMaps.pageName == 'map'
                icon = docMaps.icon2
              else
                icon = docMaps.icon1
              marker = new (google.maps.Marker)(
                map: docMaps.map
                icon: icon
                addInfo: addInfo
                position: results[0].geometry.location)
              docMaps.markersList.push marker
              docMaps.listeners.marker(marker, docMaps.map)
              if addInfo.active
                docMaps.map.setCenter marker.getPosition()
              docMaps.addNewMarker()
            else
              console.log 'Geocode was not successful for the following reason: ' + status

    inner: () ->
      index = 0
      return ->
        if index < @allItemsList.length
          addInfo = @allItemsList[index]
          @geocoder.geocode {'address': addInfo.address + ' ' + @city}, (results, status) ->
            if status == google.maps.GeocoderStatus.OK
              marker = new (google.maps.Marker)(
                map: docMaps.map
                icon: docMaps.icon1
                addInfo: addInfo
                position: results[0].geometry.location)
              docMaps.markersList.push marker
              docMaps.listeners.marker(marker, docMaps.map)
              docMaps.addNewMarker()
            else
              console.log 'Geocode was not successful for the following reason: ' + status
          index++
        else
          docMaps.fitMap docMaps.markersList, docMaps.map

  sideMarkerActivate: (marker, map) ->
    docMaps.resetMarkers()
    marker.setIcon docMaps.icon2
    docMaps.fitMap [marker], map

    if marker.addInfo.affilate
      if docMaps.pageName == 'clinics'
        offsetTop = $("[data-id='" + marker.addInfo.affilate.id + "']").offset().top
      else
        offsetTop = $("[data-id='" + marker.addInfo.affilate.id + "']").closest('.card').offset().top
    else
      offsetTop = $("[data-id='" + marker.addInfo.id + "']").offset().top
    yPos = offsetTop - $('.navbar-main').outerHeight() - 20
    $('html,body').animate {scrollTop: yPos}, 'slow'

  #resetMarkers
  resetMarkers: ->
    $.each docMaps.markersList, (index, value) ->
      docMaps.markersList[index].setIcon docMaps.icon1

  showInfoWindow: (map, marker, tpl)->
    contentString = '<div class="map-marker-content">' + tpl + '</div>'
    infoWindow = new (google.maps.InfoWindow)(
      content: contentString
      maxWidth: 200
      zIndex: 10011
    )
    $('.marker-window').remove()
    infoWindow.open(map, marker)
    setTimeout (->
      gmEl = $('.map-marker-content').closest('.gm-style-iw')
      gmEl.parent().addClass('marker-window')
      $('.marker-window').clone().insertAfter($('.marker-window'))
      $('.marker-window').first().remove()
      $('.marker-window .gm-style-iw').css('max-width': 220)
      $('.marker-window .gm-style-iw>div').eq(0).css('max-width': 220)
#      $('.marker-window').show()
#      $('.marker-window').prependTo('.big-map__container')
    ), 500


  listeners:
    marker: (marker, map) ->
      if docMaps.pageName == 'map'
        if marker.addInfo.affilate
          rating = marker.addInfo.affilate.rating
          address = marker.addInfo.affilate.address
          reviews = marker.addInfo.affilate.reviews
        else
          rating = marker.addInfo.rating
          address = marker.addInfo.address
          reviews = marker.addInfo.reviews

      #marker click
      google.maps.event.addListener marker, 'click', ->
        if docMaps.pageName == 'map'
          docMaps.showInfoWindow map, marker, '<div class="image"><img src="' + marker.addInfo.image + '" class="marker-logo"></div> <a href="/clinic-inner.html" class="title">' + marker.addInfo.name + '</a> <div class="card__address">' +
              '<span>' + address + '</span></div> <div class="rating"> <div class="rating__stars"> <div class="rating__stars-bg"></div> <div style="width: ' + rating * 20 + '%;" class="rating__stars-overlay"></div> </div> <div class="rating__value value">' + rating + '</div> </div><a href="#" class="marker-review"> ' + reviews + ' отзыва</a><a href="#clinic-request" data-toggle="mod al" class="btn btn-success">Записаться в клинику</a>'
          docMaps.loadDoctors('affiliate', 28)
        else if docMaps.pageName == 'doctorInner'
          $('#clinic-location-map').modal()
        else
          docMaps.sideMarkerActivate marker, map

    common: (map) ->
      google.maps.event.addListenerOnce map, 'idle', ->
        setTimeout (->
          $('.finder-map').prependTo('.big-map__container')
        ), 1500

      $("body").on "click", ".marker-window >div:last", (e) ->
        $('.marker-window').remove()

      # Card mouseover
      $("body").on "mouseover", ".card", ->
        if docMaps.cardId != $(@).data('id') and docMaps.markersList.length > 0
          docMaps.resetMarkers()
          if docMaps.pageName == 'clinics'
            if $(@).find('.small-card').length > 0
              index = docMaps.findMarker('id', $(@).find('.small-card').eq(0).data('id'))
            else
              index = docMaps.findMarker('id', $(@).closest('.card').data('id'))
          else if docMaps.pageName == 'doctors'
            if $(@).find('.card__job').length > 0
              index = docMaps.findMarker('id', $(@).find('.card__job').eq(0).data('id'))
            else
              index = docMaps.findMarker('id', $(@).closest('.card').data('id'))

          if $(@).find('.small-card').length > 0
            list = 	docMaps.markersList.slice(index, index + ($(@).find('.small-card').length))
          else if $(@).find('.card__job').length > 0
            list = 	docMaps.markersList.slice(index, index + ($(@).find('.card__job').length))
          else
            list = []
            list.push docMaps.markersList[index]

          docMaps.fitMap list, map
          docMaps.cardId = $(@).data('id')

      $(window).resize ->
        if docMaps.pageName == 'map'
          docMaps.mapCss.bigMap()
        else
          if docMaps.pageName == 'doctorInner' or docMaps.pageName == 'clinicInner'
            docMaps.mapCss.inner()
          else
            docMaps.mapCss.index()

  findMarker: (key, value) ->
    i = 0
    index = -1
    while index == -1 or i < docMaps.markersList.length - 1
      if docMaps.markersList[i].addInfo.affilate
        if docMaps.markersList[i].addInfo.affilate[key] == value
          index = i
      else
        if docMaps.markersList[i].addInfo[key] == value
          index = i
      i++
    if index == -1
      console.log('Not found marker key: ' + key + ', value: ' + value)
    return index

  #All affilates fit to screen
  fitMap: (currentMarkers, map, zoom) ->
#    docMaps.resetMarkers()
    map.panTo currentMarkers[0].getPosition()
    currentMarkers[0].setIcon docMaps.icon2
#    bounds = new google.maps.LatLngBounds()
#    i = 0
#    while i < currentMarkers.length
#      bounds.extend currentMarkers[i].getPosition()
#      if docMaps.pageName != 'doctorInner'
#        currentMarkers[i].setIcon docMaps.icon2
#      i++
#
#    map.fitBounds(bounds)
    if not zoom
      zoom = 12
    map.setZoom zoom
