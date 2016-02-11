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
 	$(".alternative-btn__district").find("span").append('<i class="icon-close js-remove"></i>')

$("#select-area [data-action='reset']").on "click", ->
	$("#select-area").find('.pill').removeClass 'is-active'


$(".alternative-btn__district").on "click", ".js-remove", ->
	inputAlternative = $(this).parents('span')
	inputArea = $("#select-area").find('.is-active').children('span')

	inputAlternative.remove()

	# if inputAlternative.text() == inputArea.text()
	# inputAlternative.text(inputArea.text().find(".is-active :checked").prop("checked", false))	
	





