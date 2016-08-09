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
		highlighted = item.value.split(this.term).join('<span class="is-active">' + this.term +  '</span>')
		return $("<li></li>").data("item.autocomplete", item).append('<a class="search-select" data-search="' + item.value + '">' + highlighted + '</a>').appendTo(ul);
	
	# $.ui.autocomplete::_response = (content) ->
	# 	__response.apply this, [ content ]
	# 	@element.trigger 'autocompletesearchcomplete', [ content ]
	# 	return

	availableTags = [
		{
			id: 1,
			label: 'Реовазография (РВГ)',
			value: 'Реовазография (РВГ)2' },
		{
			id: 2,
			label: 'Реоэнцофалография (РЭГ)',
			value: 'Реоэнцофалография (РЭГ)2' },
		{
			id: 3,
			label: 'Ректороманоскопия',
			value: 'Ректороманоскопия2'} 
		{
			id: 4,
			label: 'Ректороманоскопия',
			value: 'Ректороманоскопия2'} 
		{
			id: 4,
			label: 'Ректороманоскопия',
			value: 'Ректороманоскопия2'} 
		{
			id: 4,
			label: 'Ректороманоскопия',
			value: 'Ректороманоскопия2'} 
		{
			id: 4,
			label: 'Ректороманоскопия',
			value: 'Ректороманоскопия2'} 
	];
		# 'Реовазография (РВГ)'
		# 'Реоэнцофалография (РЭГ)'
		# 'Ректороманоскопия'
		# 'Ректосигмоскопия'
		# 'Ректороманоскопия'
		# 'Реовазография (РВГ)'
		# 'Реоэнцофалография (РЭГ)'
		# 'Ректороманоскопия'
		# 'Ректосигмоскопия'
		# 'Ректороманоскопия'
		# 'Реовазография (РВГ)'
		# 'Реоэнцофалография (РЭГ)'
		# 'Ректороманоскопия'
		# 'Ректосигмоскопия'
		# 'Ректороманоскопия'

	$('.js-autocomplete-subject').autocomplete
		# source: availableTags,
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
			$(this).val ui.item.value 
			false
			
		source: (request, response) ->
			noResult = $('.no-results')  

			$.ajax
				url: '/data/affilliates.json',
				dataType: 'json',
				method: 'GET',
				data: {term: request.term}
				success: (data) ->
					results = $.ui.autocomplete.filter(data.list, request.term)
					
					if !results.length
						noResult.addClass('is-hide')
					else
						noResult.removeClass('is-hide')
					response results
					# response $.map(data.list, (item) ->
					# 	return {
					# 		id: item.id
					# 		label: item.label
					# 		value: item.value 
					# 	}
					# )

			if !($('.js-autocomplete-subject').val().length >= 2)
				noResult.removeClass('is-hide')
				$('.js-rezult-delete').hide()
			else
				$('.js-rezult-delete').show()
				

			# if $('.js-autocomplete-subject').val().length >= 2
			# else
			return

		# source: (request, response) ->
		# source: (request, response) ->
		# 	$.post "/echo/json/", {
		# 		json: partTags,
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

	# ).data("autocomplete")._renderItem = (ul, item) ->
	# 	return $("<li>").data("item.autocomplete", item).append("<a>" + item.url + "</a>").appendTo(ul);

	# 	highlighted = item.value.split(this.term).join('<span class="is-active">' + this.term +  '</span>')
	# 	return $("<li></li>").data("item.autocomplete", item).append('<a class="search-select" data-search="' + item.value + '">' + highlighted + '</a>').appendTo(ul);

	# ).bind 'autocompletesearchcomplete', (event, contents) ->
	# 	if contents.length < 1
	# 		$('#results').html 'No Entries Found'
	# 	else
	# 		$('#results').html ''
	# 	return 
	# return
	$('.js-rezult-delete').on 'click', (event) ->
		autocompleteInput = $(this).siblings('.js-autocomplete-subject')
		rezult = $(this).siblings('.no-results')

		$(this).hide()
		rezult.removeClass('is-hide')
		autocompleteInput.val(' ') 
		event.stopPropagation()
		false
	
