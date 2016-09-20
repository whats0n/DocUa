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

# $(".alternative-block__enter-text").each ->
# 	$(@).val ''

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

# autocomplete for input
$('.js-clinic-autocomplete').each ->	
	_jScrollPane = undefined
	_jScrollPaneAPI = undefined
	_jSheight = 200

	jQuery.ui.autocomplete::_resizeMenu = ->
		ul = @menu.element
		ul.outerWidth @element.outerWidth()
		return
	$(this).autocomplete
		minLength: 2,
		appendTo: ".application"
		open: ->
			# $('.ui-autocomplete').css('top', $("ul.ui-autocomplete").cssUnit('top')[0] - 8);
			$(this).data('uiAutocomplete').menu.element.addClass 'subject-scroll'
			if undefined != _jScrollPane
				_jScrollPaneAPI.destroy()
			$('.subject-scroll > li').wrapAll $('<ul class="scroll-panel"></ul>').height(_jSheight)
			_jScrollPane = $('.scroll-panel').jScrollPane()
			_jScrollPaneAPI = _jScrollPane.data('jsp')
			return
		# close: (event, ui) ->
		# 	_jScrollPaneAPI.destroy()
		# 	_jScrollPane = undefined
		# 	return
		source: (request, response) ->
			$.ajax
				url: '/analysis/search/live/clinic-profile.json',
				dataType: 'json',
				method: 'GET',
				data: request
				success: (data) -> 
					response $.map(data.profile, (item) ->
						return {
							value: item.value 
							label: item.label 
						}
					) 
	
#datetimepicker
$('.js-clinic-datepicker').datetimepicker  
	format: "dd MM yyyy - hh:ii",
	weekStart: 1,
	todayBtn:  0,
	autoclose: 1

$('.js-datepicker-trigger').on 'click', ->
	$('.js-clinic-datepicker').datetimepicker('show')