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


	picker.toggleClass 'is-open'	


	$('.js-datepicker').datepick 
		dateFormat: 'd MM'
		rangeSelect: true
		monthsToShow: [
			1
			2
		]
		showTrigger: '#calImg'
		showOtherMonths: true
		selectOtherMonths: true
		changeMonth: false
		altField: '.date-footer__text'
		altFormat: 'd MM'
		# clearText: '.js-date-clear'
		# defaultClass: '.is-active'
		# defaultDate: +7	
		# defaultDate: +14	
		# selectDate: +7 
		# onSelect: -> 
			# $('.js-datepicker').datepick 'setDate', +7
		onShow: ->
			setTimeout (-> 
				$(document).find('.js-datepicker .datepick-today').addClass 'today-active'
			), 1000
		# 	$('.js-clone-date').datepick 'setDate', date

			# $(@).find('.datepick-month').children('td').addClass 'sss'

		# onDate: (date, current) ->
	# $('.js-datepicker').datepick 


			 

		# defaultDate: +7



$(".js-date-close").on "click",  ->	
	value = $('.date-footer__text').val()
	$(".date-wrap").removeClass "is-open"
	$('.js-clone-date').text(value)
	


# $(".js-date-clear").on "click",  ->	
# 	$('.js-datepicker').DatePickerClear()
# 	$('.date-footer__text').empty()

$(".date-header__item").on "click",  ->	
	Picker =  $('.js-datepicker').datepick()
	today = Picker.find('.datepick-today').text()
	day = 7
	today7 = parseInt(today) + day
	
	
	console.log(today7)




	# today.addClass ('is-active')
	# today



	$(@).addClass 'active'

	alert(today7)



