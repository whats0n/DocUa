$("#select-area").on "change", "input", ->
	
	if $(this).prop('checked')
		$(this).parents('label').addClass 'is-active'
	else
		$(this).parents('label').removeClass 'is-active'

$("#select-area").on "click", ".js-btn-clone", ->
	item = $('.is-active').children('span')
	itemParent = item.parent('.is-active')

	$(".alternative-btn__district").empty()

 if item.siblings("input:checkbox:checked")
 	item.clone().appendTo(".alternative-btn__district")

 	# $("#select-area li label").removeClass 'is-active'





  # console.log(item)