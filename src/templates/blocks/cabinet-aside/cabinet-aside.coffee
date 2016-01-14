$('.js-add-tel').click ->
	$('.add-tel').addClass 'is-active'
	return

$('.js-field-cild').click ->
	$(this).siblings('.section-choice').toggleClass 'is-open'
	return




$('.js-child').click ->
	id = $(this).data('id')
	item = $('.item__mod')
	elFields = $('.js-group')
	elField = $('.js-group[data-field="' + id + '"]')
	elChild = $(this)
	elChildren = $('.js-child')


	if !$(this).hasClass 'is-active'
		elFields.removeClass 'is-open'
		elChildren.removeClass 'is-active'
		item.addClass 'is-open'
		elChild.addClass 'is-active'
		elField.addClass 'is-open'
		if $(this).data('id') == 0
			item.removeClass 'is-open'


	$(this).parent('.section-choice').removeClass 'is-open'
	$(this).parent('.section-choice').siblings('.js-field-cild').text($(this).text())


$('.js-remove-parent').each ->
	elBtn = $(this)

	elBtn.find('.js-remove-item').click ->
		item = $('.content-favorites__item')
		elTotal = elBtn.find(item).length
		
		$(this).closest(item).remove()
		console.log(elBtn.find(item).length)
		if elTotal == 1
			elBtn.remove()
		false
		return



		
	
		
	 