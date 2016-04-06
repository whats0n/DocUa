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



  # begin new js block
# $ ->
#   t = undefined
#   e = undefined
#   n = undefined
#   i = undefined
#   o = undefined
#   r = undefined
#   s = undefined
#   a = undefined
#   l = undefined
#   c = undefined
#   u = undefined
#   d = undefined
#   h = undefined
#   p = undefined
#   f = undefined
#   m = undefined
#   g = undefined
#   t = $('.body-map')
#   i = ! !top.execScript
#   t.toggleClass('body-map_ie', i)
#   t.length > 0 and $('.body-map__container').length > 0 and e = t.find('[data-zone-id=\'common\']')
#   n = t.find('[data-zone-id=\'skin\']')
#   r = 'man'
#   h = 'front'
#   o = !1
#   s = null
#   u = null
#   g = {}

#   l = ->
#     `var e`
#     `var n`
#     `var i`
#     `var a`
#     `var l`
#     `var c`
#     `var d`
#     `var p`
#     `var f`
#     e = undefined
#     n = undefined
#     i = undefined
#     a = undefined
#     l = undefined
#     c = undefined
#     d = undefined
#     p = undefined
#     f = undefined
#     s and s.remove()
#     s = null

#     if o 
#       i = 
#         top: '-10%'
#         left: '-15%' 
#     else
#       i = 
#         top: 0
#         left: '50%'
#     e = t.find('.body-map__main').panElement('destroy').css(i).removeClass('body-map__main_detailed').hide().filter('.body-map__main_' + r + '_' + h).show().toggleClass('body-map__main_detailed', o)
#     l = '' + r + '-' + h + (if o then '-detailed' else '')
#     a = SVG_FILES[l]
#     s = Raphael(e.find('.body-map__zones')[0])
#     s.setViewBox(a.viewbox[0], a.viewbox[1], a.viewbox[2], a.viewbox[3], !0)
#     s.setSize('100%', '100%')
#     m()
#     g = {}

#     n = (e) ->
#       `var n`
#       `var i`
#       `var a`
#       `var l`
#       `var c`
#       `var d`
#       n = undefined
#       i = undefined
#       a = undefined
#       l = undefined
#       c = undefined
#       d = undefined
#       a = do ->
#         `var t`
#         `var n`
#         `var i`
#         `var o`
#         t = undefined
#         n = undefined
#         i = undefined
#         o = undefined
#         if e.path
#           return [ s.path(e.path) ]
#         if e.pathList
#           i = e.pathList
#           o = []
#           t = 0
#           n = i.length
#           while n > t
#             l = i[t]
#             o.push(s.path(l))
#             t++
#           return o
#         throw new Error('invalid zone ' + JSON.stringify(e))
#         return

#       c = 0
#       d = a.length
#       while d > c
#         i = a[c]
#         i.attr(
#           zoneId: e.id
#           'stroke-width': 0
#           fill: '#ff4c4c'
#           cursor: 'pointer'
#           opacity: 0)
#         i.mouseover(->
#           `var n`
#           `var i`
#           `var s`
#           n = undefined
#           i = undefined
#           s = undefined
#           if e.id != u
#             i = 0
#             s = a.length
#             while s > i
#               n = a[i]
#               n.attr(opacity: .5)
#               i++
#           t.trigger 'mouseoverZone',
#             gender: r
#             side: h
#             detailed: o
#             zoneId: e.id
#         )
#         i.mouseout(->
#           `var n`
#           `var i`
#           `var s`
#           n = undefined
#           i = undefined
#           s = undefined
#           if e.id != u
#             i = 0
#             s = a.length
#             while s > i
#               n = a[i]
#               n.attr(opacity: 0)
#               i++
#           t.trigger 'mouseoutZone',
#             gender: r
#             side: h
#             detailed: o
#             zoneId: e.id
#         )
#         n = !1
#         i.mousedown(->
#           n = !0
#         )
#         i.mousemove(->
#           n = !1
#         )
#         i.mouseup((i) ->
#           `var s`
#           `var a`
#           `var l`
#           `var c`
#           s = undefined
#           a = undefined
#           l = undefined
#           c = undefined
#           if n
#             return s = t.find('.body-map__main:visible')
#             a = s.offset()
#             l = i.offsetX or i.pageX - (a.left)
#             c = i.offsetY or i.pageY - (a.top)
#             t.trigger('clickZone',
#               gender: r
#               side: h
#               detailed: o
#               zoneId: e.id
#               offset:
#                 left: l
#                 top: c
#               size:
#                 width: s.width()
#                 height: s.height())

#           return
#         )
#         c++
#       g[e.id] = a

# f = a.zones
# d = 0
# p = f.length
# while p > d
#   c = f[d]
#   n(c)
#   d++
# if o then e.panElement() else undefined

# m = ->
#     `var t`
#     `var i`
#     `var o`
#     `var r`
#     `var s`
#     t = undefined
#     i = undefined
#     o = undefined
#     r = undefined
#     s = undefined
#     n.prop('checked', !1)
#     e.prop('checked', !1)
#     for t of g
#       `t = t`
#       o = g[t]
#       r = 0
#       s = o.length
#       while s > r
#         i = o[r]
#         i.attr(opacity: 0)
#         r++
#     u = null

# c = (t) ->
#     m()
#     setTimeout((->
#       `var i`
#       `var o`
#       `var r`
#       `var s`
#       `var a`
#       i = undefined
#       o = undefined
#       r = undefined
#       s = undefined
#       a = undefined
#       switch t
#         when 'common'
#           return e.prop('checked', !0)
#         when 'skin'
#           return n.prop('checked', !0)
#         else
#           s = g[t]
#           a = []
#           o = 0
#           r = s.length
#           while r > o
#             i = s[o]
#             a.push(i.attr(opacity: .5))
#             o++
#           return a
#       return
#     ), 1)
#     u = t

# d = ->
#     r = do ->
#       switch t.find('.body-map__select [name=\'gender\']:checked').val()
#         when 'male'
#           return 'man'
#         when 'female'
#           return 'woman'
#         else
#           throw new Error('invalid gender')
#       return

#     l()

# f = ->
#     h = if 'front' == h then 'back' else 'front'
#     l()

# p = ->
#     o = !o
#     t.find('.body-map__zoom').toggleClass('body-map__zoom_out', o)
#     l()

# t.find('.body-map__select [name=\'gender\']').change(->
#     d()
#     t.trigger('selectGender', gender: r)
#   )
# t.find('.body-map__rotate').click(->
#   f()
#   t.trigger('selectSide', side: h)
# )
# t.find('.body-map__zoom').click(->
#   p()
#   t.trigger('selectDetailed', detailed: o)
# )
# t.on('selectZone', (t, e) ->
#   c e.zoneId
# )

# a = (e) -> 
#   t.trigger('clickZone',
#     zoneId: $(this).data('zoneId')
#     gender: r
#     detailed: o
#     side: h)
#   e.stopPropagation()
#   e.preventDefault()
#   !1

#   e.click(a)
#   n.click(a)
#   t.on('clickZone', (e, n) ->
#     `var i`
#     `var o`
#     `var r`
#     i = undefined
#     o = undefined
#     r = undefined
#     if 'common' == (r = n.zoneId) or 'skin' == r or n.detailed then t.trigger('selectZone', zoneId: n.zoneId) else p()
#     o = t.find('.body-map__main_detailed')
#     i = o.parent()
#     t.find('.body-map__main').css(
#       top: '' + Math.min(0, Math.max(i.height() - o.height(), -(o.height() - i.height()) / 2 + (.5 - (n.offset.top / n.size.height)) * o.height())) + 'px'
#       left: '' + Math.min(0, Math.max(i.width() - o.width(), -(o.width() - i.width()) / 2 + (.5 - (n.offset.left / n.size.width)) * o.width())) + 'px')
#   )
#   d()

#   return

  # end new js block





# ---
# generated by js2coffee 2.1.0
