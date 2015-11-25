$.fn.panElement = (arg) ->
	return $(@).data("panElement", off).off "mousedown" if arg is "destroy"
	@each ->
		$el = $(@)
		return if $el.data "panElement"
		$el.data "panElement", on
		$el.on "mousedown", (downEvent) ->
			startX = downEvent.pageX
			startY = downEvent.pageY
			startTop = parseFloat $el.css("top").replace "px", ""
			startLeft = parseFloat $el.css("left").replace "px", ""
			minTop = $el.parent().height() - $el.height()
			minLeft = $el.parent().width() - $el.width()
			downEvent.preventDefault()
			downEvent.stopPropagation()
			$el.css cursor: "move"
			$("body").on "mousemove", moveHandler = (moveEvent) ->
				deltaX = moveEvent.pageX - startX
				deltaY = moveEvent.pageY - startY
				$el.css
					top: "#{Math.min 0, Math.max minTop, startTop + deltaY}px"
					left: "#{Math.min 0, Math.max minLeft, startLeft + deltaX}px"
				moveEvent.preventDefault()
				moveEvent.stopPropagation()
			$("body").one "mouseup", ->
				$("body").off "mousemove", moveHandler
				$el.css cursor: ""		
	@
