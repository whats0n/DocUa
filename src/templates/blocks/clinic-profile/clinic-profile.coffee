$("#select-area").on "change", "input", ->
	spanText = $(this).siblings('span').text()

	if $(this).prop('checked')
		$(this).parents('label').addClass 'is-active'
		$(this).siblings('span').attr 'data-place', spanText
		
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
	inputAreaText = $("#select-area").find('.is-active').children('span')
	data1 = inputAlternative.data("place")
	$item = $("#select-area").find('.is-active').children('span[data-place=\'' + data1 + '\']')
		# inputAreaText.data('place', data1)
	# $(+'[data-=\'' +  + '\']')

	# inputArea = $("#select-area").find('.is-active').children('span')
	# 
	inputAlternative.remove()

	$item.siblings('input').prop("checked", false).parents('.pill').removeClass('is-active')

	# console.log(data1)



	# if inputAlternative.text() == inputArea.text()
		# $("#select-area").find(".is-active :checked").prop("checked", false)




# data-picker
$(".js-btn-picker").on "click",  ->
	picker = $(this).siblings(".date-wrap")

	picker.toggleClass 'is-active'	
	
$(".js-datepicker").datepicker
	altField: ".date-footer__text"
	selectOtherMonths: true 
	dateFormat: true
	numberOfMonths: [ 
		1 
		2
	]
	monthNames: [
		'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь',
	'Октябрь', 'Ноябрь', 'Декабрь'
	]
	dayNamesMin: [ 
		'ВС','ПН','ВТ','СР','ЧТ','ПТ','СБ'
	]
	firstDay: 1


