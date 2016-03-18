(->
  $bodyMap = undefined
  $commonPill = undefined
  $skinPill = undefined
  IE = undefined
  detailed = undefined
  gender = undefined
  map = undefined
  otherZoneClickHandler = undefined
  refreshView = undefined
  selectZone = undefined
  selected = undefined
  setGender = undefined
  side = undefined
  toggleDetailed = undefined
  toggleSide = undefined
  unselectZones = undefined
  zones = undefined
  $bodyMap = $('.body-map')
  IE = ! !top.execScript
  $bodyMap.toggleClass 'body-map_ie', IE
  if $bodyMap.length > 0 and $('.body-map__container').length > 0
    $commonPill = $bodyMap.find('[data-zone-id=\'common\']')
    $skinPill = $bodyMap.find('[data-zone-id=\'skin\']')
    gender = 'man'
    side = 'front'
    detailed = false
    map = null
    selected = null
    zones = {} 

    refreshView = -> 
      $el = undefined
      createZone = undefined
      resetCss = undefined
      svgFile = undefined
      svgFileKey = undefined
      zone = undefined
      _i = undefined
      _len = undefined
      _ref = undefined
      if map
        map.remove()
        map = null
      if detailed
        resetCss = 
          top: '-10%'
          left: '-15%'
      else
        resetCss = 
          top: 0
          left: '50%'
      $el = $bodyMap.find('.body-map__main').panElement('destroy').css(resetCss).removeClass('body-map__main_detailed').hide().filter('.body-map__main_' + gender + '_' + side).show().toggleClass('body-map__main_detailed', detailed)
      svgFileKey = '' + gender + '-' + side + (if detailed then '-detailed' else '')
      svgFile = SVG_FILES[svgFileKey]
      map = Raphael($el.find('.body-map__zones')[0])
      map.setViewBox svgFile.viewbox[0], svgFile.viewbox[1], svgFile.viewbox[2], svgFile.viewbox[3], true
      map.setSize '100%', '100%'
      unselectZones()
      zones = {} 

      createZone = (zone) ->
        `var _len`
        `var _i`
        clicking = undefined
        path = undefined
        pathList = undefined
        pathString = undefined
        _i = undefined
        _len = undefined
        pathList = do ->
          `var _ref`
          `var _len`
          `var _i`
          _i = undefined
          _len = undefined
          _ref = undefined
          _results = undefined
          if zone.path
            return [ map.path(zone.path) ]
          else if zone.pathList
            _ref = zone.pathList
            _results = []
            _i = 0
            _len = _ref.length
            while _i < _len
              pathString = _ref[_i]
              _results.push map.path(pathString)
              _i++
            return _results
          else
            throw new Error('invalid zone ' + JSON.stringify(zone))
          return
        while _i < _len
          path = pathList[_i]
          path.attr
            zoneId: zone.id
            'stroke-width': 0
            fill: '#ff4c4c'
            cursor: 'pointer'
            opacity: 0
          path.mouseover ->
            p = undefined
            _j = undefined
            _len1 = undefined
            if zone.id != selected
              _j = 0
              _len1 = pathList.length
              while _j < _len1
                p = pathList[_j]
                p.attr opacity: 0.5
                _j++
            $bodyMap.trigger 'mouseoverZone',
              gender: gender
              side: side
              detailed: detailed
              zoneId: zone.id
          path.mouseout ->
            p = undefined
            _j = undefined
            _len1 = undefined
            if zone.id != selected
              _j = 0
              _len1 = pathList.length
              while _j < _len1
                p = pathList[_j]
                p.attr opacity: 0
                _j++
            $bodyMap.trigger 'mouseoutZone',
              gender: gender
              side: side
              detailed: detailed
              zoneId: zone.id
          clicking = false
          path.mousedown ->
            clicking = true
          path.mousemove ->
            clicking = false
          path.mouseup (e) ->
            $m = undefined
            offset = undefined
            offsetX = undefined
            offsetY = undefined
            if !clicking
              return
            $m = $bodyMap.find('.body-map__main:visible')
            offset = $m.offset()
            offsetX = e.offsetX or e.pageX - (offset.left)
            offsetY = e.offsetY or e.pageY - (offset.top)
            $bodyMap.trigger 'clickZone',
              gender: gender
              side: side
              detailed: detailed
              zoneId: zone.id
              offset:
                left: offsetX
                top: offsetY
              size:
                width: $m.width()
                height: $m.height()
          _i++
        zones[zone.id] = pathList

      _ref = svgFile.zones
      _i = 0
      _len = _ref.length
      while _i < _len
        zone = _ref[_i]
        createZone zone
        _i++
      if detailed
        return $el.panElement()
      return

    unselectZones = ->
      id = undefined
      p = undefined
      pathList = undefined
      _i = undefined
      _len = undefined
      $skinPill.prop 'checked', false
      $commonPill.prop 'checked', false
      for id of zones
        `id = id`
        pathList = zones[id]
        _i = 0
        _len = pathList.length
        while _i < _len
          p = pathList[_i]
          p.attr opacity: 0
          _i++
      selected = null

    selectZone = (id) ->
      unselectZones()
      setTimeout (->
        p = undefined
        _i = undefined
        _len = undefined
        _ref = undefined
        _results = undefined
        switch id
          when 'common'
            return $commonPill.prop('checked', true)
          when 'skin'
            return $skinPill.prop('checked', true)
          else
            _ref = zones[id]
            _results = []
            _i = 0
            _len = _ref.length
            while _i < _len
              p = _ref[_i]
              _results.push p.attr(opacity: 0.5)
              _i++
            return _results
        return
      ), 1
      selected = id

    setGender = ->
      gender = do ->
        switch $bodyMap.find('.body-map__select [name=\'gender\']:checked').val()
          when 'male'
            return 'man'
          when 'female'
            return 'woman'
          else
            throw new Error('invalid gender')
        return
      refreshView()

    toggleSide = ->
      side = if side == 'front' then 'back' else 'front'
      refreshView()

    toggleDetailed = ->
      detailed = !detailed
      $bodyMap.find('.body-map__zoom').toggleClass 'body-map__zoom_out', detailed
      refreshView()

    $bodyMap.find('.body-map__select [name=\'gender\']').change ->
      setGender()
      $bodyMap.trigger 'selectGender', gender: gender
    $bodyMap.find('.body-map__rotate').click ->
      toggleSide()
      $bodyMap.trigger 'selectSide', side: side
    $bodyMap.find('.body-map__zoom').click ->
      toggleDetailed()
      $bodyMap.trigger 'selectDetailed', detailed: detailed
    $bodyMap.on 'selectZone', (e, o) ->
      selectZone o.zoneId

    otherZoneClickHandler = (e) ->
      $bodyMap.trigger 'clickZone',
        zoneId: $(this).data('zoneId')
        gender: gender
        detailed: detailed
        side: side
      e.stopPropagation()
      e.preventDefault()
      false

    $commonPill.click otherZoneClickHandler
    $skinPill.click otherZoneClickHandler
    $bodyMap.on 'clickZone', (event, o) ->
      $c = undefined
      $d = undefined
      _ref = undefined
      if (_ref = o.zoneId) == 'common' or _ref == 'skin' or o.detailed
        $bodyMap.trigger 'selectZone', zoneId: o.zoneId
      else
        toggleDetailed()
        $d = $bodyMap.find('.body-map__main_detailed')
        $c = $d.parent()
        $bodyMap.find('.body-map__main').css
          top: '' + Math.min(0, Math.max($c.height() - $d.height(), -($d.height() - $c.height()) / 2 + (0.5 - (o.offset.top / o.size.height)) * $d.height())) + 'px'
          left: '' + Math.min(0, Math.max($c.width() - $d.width(), -($d.width() - $c.width()) / 2 + (0.5 - (o.offset.left / o.size.width)) * $d.width())) + 'px'
    setGender()
  return
).call this

# ---
# generated by js2coffee 2.1.0
