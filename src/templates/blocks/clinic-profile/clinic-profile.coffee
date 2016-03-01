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
			format: 'D MMMM',
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


	# $('.js-datepicker').on 'hideCalendar.daterangepicker', (ev, picker) ->
	# 	alert()

	

	# $('.ranges li').on 'click', ->
	# 	parent = $('.ranges li').parents('.daterangepicker')
	# 	# alert()
	# 	# setTimeout ->
	# 	# 	parent.addClass 'open'
	# 	# 	, 1000
	# 	$('.ranges li').removeClass 'active'
	
	# 	if !$('.ranges li').hasClass 'active'
	# 		$(@).addClass "active"
	# 	else
	# 		$('.ranges li').removeClass 'active'

		
