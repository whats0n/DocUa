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

$(".alternative-block__enter-text").each ->
	$(@).val ''

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

# Clone specialization
$("#select-specialization").on "click", "li a", ->
	item = $(@)

	$('.alternative-btn__specialization span').empty()
	$('.alternative-btn__specialization span').text(item.text())
	$('.js-remove' ).addClass 'is-active'
	$('.js-btn-special').text('Выбрана специальность')
	# return $("#select-specialization").modal "hide"

$(".js-remove").on "click", ->
	$(this).siblings("span").empty()
	$(this).removeClass 'is-active'
	$('.js-btn-special').text('Выберите специальность')
	return false


# data-picker

$ ->
	
	$('.js-datepicker').daterangepicker
		autoUpdateInput: true,
		alwaysShowCalendars: true,
		# autoUpdateInput: true,
		startDate: moment(),
		opens: "left",
		applyClass: "apply-btn"
		cancelClass: "cancel-btn"
		ranges:
			'Последние :': [
			]
			'7 дней': [
				moment()
				moment().add(6, 'days')
			]
			'14 дней': [
				moment()
				moment().add(13, 'days')
			]
			'30 дней': [
				moment()
				moment().add(29, 'days') 
			]
		locale:
			format: 'DD MMMM',
			separator: ' - ',
			applyLabel: 'Подтвердить',
			cancelLabel: 'Отменить',
			daysOfWeek: [
				'ВC'
				'ПН'
				'ВТ'
				'СР'
				'ЧТ'
				'ПТ'
				'СБ'
			]
			monthNames: [
				'Январь'
				'Февраль'
				'Март'
				'Апрель'
				'Май'
				'Июнь'
				'Июль'
				'Август'
				'Сентябрь'
				'Октябрь'
				'Ноябрь'
				'Декабрь'
			]
			firstDay: 1


		# $('.js-datepicker').on 'showCalendar.daterangepicker', (ev, picker) ->

	$('.ranges li').on 'click', ->
		parent = $('.ranges li').parents('.daterangepicker')
		# alert()
		setTimeout ->
			parent.addClass 'open'
			, 1000
		$('.ranges li').removeClass 'active'
	
		if !$('.ranges li').hasClass 'active'
			$(@).addClass "active"
		else
			$('.ranges li').removeClass 'active'

		








# 	$('.js-datepicker').daterangepicker
# 		initialText: 'Select period...',
# 		verticalOffset: 20,
# 		applyOnMenuSelect: false,
# 		clearButtonText: 'Отменить',
# 		applyButtonText: 'Подтвердить',
# 		dateFormat: "d MM",
# 		# altField:  ".js-date-range",
			
# 			# end: ".js-input",
# 		datepickerOptions:
# 			numberOfMonths : 2,
# 			maxDate: null,
# 			showOtherMonths: true,
# 			selectOtherMonths: true,
# 			firstDay: 1,
# 			navigationAsDateFormat: true,
# 			altField: ".js-date-range",
# 			altFormat: "d MM"
# 			# onSelect: ->
# 			# 	date = JSON.stringify($(".js-datepicker").daterangepicker("getRange"))
# 			# 	setTimeout(console.log(date), 2000)
				

# 			# onSelect: (dateText, inst) ->
# 				# date = $('.js-datepicker').daterangepicker('getRange')
# 				# day = date.getDate()
# 				# month = date.getMonth() + 1
# 				# year = date.getFullYear()
# 				# alert day + '-' + month + '-' + year
# 				# alert(date)
# 				# return

# 		presetRanges: [
# 			{
# 				text: 'Последние: '
				
# 			}
# 			{
# 				text: '7 дней'
# 				dateStart: ->
# 					moment()	
# 				dateEnd: ->
# 					moment().add 'days', 6
# 			}
# 			{
# 				text: '14 дней'
# 				dateStart: ->
# 					moment()
# 				dateEnd: ->
# 					moment().add 'days', 13
# 			}
# 			{
# 				text: '30 дней'
# 				dateStart: ->
# 					moment()
# 				dateEnd: ->
# 					moment().add 'days', 29
# 			}
# 		]
# 		# onChange: ->
# 		# 	date = JSON.stringify($('.js-datepicker').daterangepicker('getRange'))
# 		# 	alert(date)
# 		# onSelect: ->
# 		# 	alert()



# 		# getRange: ->

# 	return

# # add prev-btn and input
# $ ->
# 	prev = $('.ui-datepicker-prev').clone()
# 	next = $('.ui-datepicker-next').clone()

# 	prev.appendTo '.ui-corner-right'
# 	prev.addClass 'btn-prev'

# 	next.appendTo '.ui-corner-left'
# 	next.addClass 'btn-next'
	
# 	$('<input class="js-date-range ui-button-text"></input>').appendTo '.comiseo-daterangepicker-buttonpanel'

# # trigger btn-prev
# $ ->
# 	$('.btn-prev').click ->
# 		$('.ui-datepicker-prev').trigger 'click'

# # trigger btn-next
# $ ->
# 	$('.btn-next').click ->
# 		$('.ui-datepicker-next').trigger 'click'


# # selected button
# $ ->
# 	$('.ui-menu-item').on 'click', ->
# 		$('.ui-menu-item').removeClass 'is-active'

# 		if !$('.ui-menu-item').hasClass 'is-active'
# 			$(@).addClass "is-active"
# 		else
# 			$('.ui-menu-item').removeClass 'is-active'
# 		return false
# $ ->
# 	$('.ui-priority-secondary').on 'click', ->
# 		$('.ui-menu-item').removeClass 'is-active'



# $ ->
# 	$(document).on 'click', (e)->

# 		if $('.comiseo-daterangepicker-triggerbutton').hasClass('.comiseo-daterangepicker-active')
# 			return false 
# 			alert()
# 		else
# 			$('.js-datepicker').daterangepicker 'close'
# 		e.stopPropagation()
		

	# dateFormat: 'd MM'
	# rangeSelect: true
	# monthsToShow: [
	# 	1
	# 	2
	# ]
	# showTrigger: '#calImg'
	# showOtherMonths: true
	# selectOtherMonths: true
	# changeMonth: false
	# altField: '.date-footer__text'
	# altFormat: 'd MM'
	# onShow: ->
	# 	setTimeout (-> 
	# 		$(document).find('.js-datepicker .datepick-today').addClass 'today-active'
	# 	), 1000
	


# # close window
# $(".js-date-close").on "click",  ->	
# 	value = $('.date-footer__text').val()
# 	$(".date-wrap").removeClass "is-open"
# 	$('.js-clone-date').text(value)
	

# # clear 
# # $(".js-date-clear").on "click",  ->	
# # 	$('.js-datepicker').DatePickerClear()
# # 	$('.date-footer__text').empty()

# #change days
# $(".date-header__item").on "click",  ->	
# 	Picker =  $('.js-datepicker').datepick()
# 	today = Picker.find('.datepick-today').text()
# 	day = 7
# 	today7 = parseInt(today) + day


# 	$(@).addClass 'active'

# 	# alert(today7)



