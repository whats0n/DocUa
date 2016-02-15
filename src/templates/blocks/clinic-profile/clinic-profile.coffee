$("#select-area").on "change", "input", ->
	spanText = $(this).siblings('span').text()
	spanMain = $(this).parents('label').siblings()

	if 	spanMain.is('ul')
		spanMain.parent().addClass 'is-main-disrtict'

	if $(this).prop('checked')
		$(this).parents('label').addClass 'is-active'
		$(this).siblings('span').attr 'data-place', spanText
		$('.js-btn-text').text('Добавьте район')

	
	else
		$(this).parents('label').removeClass 'is-active'
		$('.js-btn-text').text('Выберете район')

# clone
$("#select-area").on "click", ".js-btn-clone", ->
	item = $('.is-active').children('span')
	itemParent = item.parent('.is-active')

	$(".alternative-btn__district").empty() 

 if item.siblings("input:checkbox:checked")
 	item.clone().appendTo(".alternative-btn__district")
 	$(".alternative-btn__district").find("span").append('<i class="icon-close js-remove"></i>')
 	
# reset
$("#select-area [data-action='reset']").on "click", ->
	$("#select-area").find('.pill').removeClass 'is-active'
	$('.js-btn-text').text('Выберете район')

# remove item
$(".alternative-btn__district").on "click", ".js-remove", ->
	inputAlternative = $(this).parents('span')
	data1 = inputAlternative.data("place")
	$item = $("#select-area").find('.is-active').children('span[data-place=\'' + data1 + '\']')
	$itemParent = $item.closest('.pill-group')
	

	inputAlternative.remove()

	$item.siblings('input').prop("checked", false).parents('.pill').removeClass('is-active')

	if $itemParent.hasClass 'is-main-disrtict'
		$itemParent.find(".pill :checked").prop("checked", false)

	if !$("#select-area").find('.is-active').hasClass 'is-active'
		$('.js-btn-text').text('Выберете район')

	




# data-picker
# $(".js-btn-picker").on "click",  ->
# 	picker = $(this).siblings(".date-wrap")

# 	picker.toggleClass 'is-active'	

# data-picker
$(".js-btn-picker").on "click",  ->
	picker = $(this).siblings(".date-wrap")


	picker.toggleClass 'is-active'	

	
	# now4.setDate(now3.getDate()+30)
	# Date(now3).addClass 'is-today'
	# if picker.hasClass 'is-active'
	# $(".js-datepicker").each ->
	# 	now3 = new Date
	# 	now4 = now3.getMonth()+1
	# 	today = now3.getDate()

		# alert(now4)
		# .parent().addClass ('is-today')
		# now3.getDate()
	$(".js-datepicker").DatePicker
		flat: true
		mode: 'range' 
		date: [
		    new Date 
		    new Date 
		]
		starts: 1
		calendars: 2
		format: 'd B'
		onChange: (formated)  ->
			$('.date-footer__text').get(0).innerHTML = formated.join(' - ')
		# else
		# 	$(".js-datepicker").DatePicker


$(".js-date-close").on "click",  ->	
	value = $('.date-footer__text').text()
	$(".date-wrap").removeClass "is-active"
	$('.js-clone-date').text(value)

$(".date-header__item").on "click",  ->	
	today = $(".datepicker").find('.datepickerToday')
	$(@).addClass 'active'

	# if $(@).hasClass 'active'
		
		# alert(today.setDate today.getDate() + 7 )
		# (today.getDate())+ 7





# $(".js-datepicker").datepicker
# 	altField: ".date-footer__text"
# 	selectOtherMonths: true 
# 	dateFormat: true
# 	numberOfMonths: [ 
# 		1 
# 		2
# 	]
# 	monthNames: [
# 		'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август', 'Сентябрь',
# 	'Октябрь', 'Ноябрь', 'Декабрь'
# 	]
# 	dayNamesMin: [ 
# 		'ВС','ПН','ВТ','СР','ЧТ','ПТ','СБ'
# 	]
# 	firstDay: 1


