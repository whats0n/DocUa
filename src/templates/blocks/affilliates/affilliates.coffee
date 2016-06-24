$('.cla-fillials a').tooltip 
	container: '.main-content' 


$('.info-cla').each ->
	_this  = $(this)
	parent = _this.parent()
	_this.tooltip 
		container: parent
	return



$(".js-autocomplete-subject").each ->
	_jScrollPane = undefined
	_jScrollPaneAPI = undefined
	_jSheight = 162

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
		open: ->
			$('.ui-autocomplete').css('top', $("ul.ui-autocomplete").cssUnit('top')[0] - 2);
			$(this).data('uiAutocomplete').menu.element.addClass 'subject-scroll'
			if undefined != _jScrollPane
				_jScrollPaneAPI.destroy()
			$('.subject-scroll > li').wrapAll $('<div class="scroll-panel"></div>').height(_jSheight)
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
