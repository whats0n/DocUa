$('.js-city-close').on 'click',(e) ->
	block = $(this).closest('.your-city')

	block.addClass 'is-hide' 
	e.stopPropagation()
	false