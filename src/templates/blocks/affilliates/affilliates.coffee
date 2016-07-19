$('.cla-fillials a').tooltip 
	container: '.main-content' 


$('.info-cla').each ->
	_this  = $(this)
	parent = _this.parent()
	_this.tooltip 
		container: parent
	return


# autocomplete
$(".js-autocomplete-subject").each ->
	_jScrollPane = undefined
	_jScrollPaneAPI = undefined
	_jSheight = 162
	# __response = $.ui.autocomplete::_response

	$.ui.autocomplete.prototype._renderItem = (ul, item) ->
	    highlighted = item.label.split(this.term).join('<span class="is-active">' + this.term +  '</span>')
	    return $("<li></li>").data("item.autocomplete", item).append('<a class="search-select" data-search="' + item.label + '">' + highlighted + '</a>').appendTo(ul);
	# $.ui.autocomplete::_response = (content) ->
	# 	__response.apply this, [ content ]
	# 	@element.trigger 'autocompletesearchcomplete', [ content ]
	# 	return

	availableTags = [
		'Реовазография (РВГ)'
		'Реоэнцофалография (РЭГ)'
		'Ректороманоскопия'
		'Ректосигмоскопия'
		'Ректороманоскопия'
		'Реовазография (РВГ)'
		'Реоэнцофалография (РЭГ)'
		'Ректороманоскопия'
		'Ректосигмоскопия'
		'Ректороманоскопия'
		'Реовазография (РВГ)'
		'Реоэнцофалография (РЭГ)'
		'Ректороманоскопия'
		'Ректосигмоскопия'
		'Ректороманоскопия'
	]

	$('.js-autocomplete-subject').autocomplete
		source: availableTags,
		appendTo: ".tab-content"
		open: ->
			# $('.ui-autocomplete').css('top', $("ul.ui-autocomplete").cssUnit('top')[0] - 8);
			$(this).data('uiAutocomplete').menu.element.addClass 'subject-scroll1'
			if undefined != _jScrollPane
				_jScrollPaneAPI.destroy()
			$('.subject-scroll1 > li').wrapAll $('<ul class="scroll-panel"></ul>').height(_jSheight)
			_jScrollPane = $('.scroll-panel').jScrollPane()
			_jScrollPaneAPI = _jScrollPane.data('jsp')
			return

		close: (event, ui) ->
			_jScrollPaneAPI.destroy()
			_jScrollPane = undefined
			return
		select: (event, ui) -> 
			$(this).val ui.item.label
			false
		source: (request, response) ->
			results = $.ui.autocomplete.filter(availableTags, request.term)
			if !results.length
				$('#no-results').text 'Совпадений не найдено!'
			else
				$('#no-results').empty()
			response results
			return
		# source: (request, response) ->
		# 	$.post '/analysis/search/live', {
		# 		json: partTags
		# 		delay: 1
		# 	}, (data) ->
		# 		response $.map(data, (item) ->
		# 			{
		# 				id: item.num
		# 				label: pn.part
		# 				value: pn.dwg
		# 			}
		# 		)
		# 		return
		# 	return


	# ).bind 'autocompletesearchcomplete', (event, contents) ->
	# 	if contents.length < 1
	# 		$('#results').html 'No Entries Found'
	# 	else
	# 		$('#results').html ''
	# 	return 
	# return
