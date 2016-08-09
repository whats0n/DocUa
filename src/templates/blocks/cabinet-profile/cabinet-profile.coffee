$('.js-add-tel').click ->
	$('.add-tel').addClass 'is-active'
	return
 
$('.js-section-choice').each ->
	removeClass = true
	item = $(this).find('.section-choice')
	$('body').click ->
		if removeClass
			item.removeClass 'is-open'
			removeClass = true
	$(this).find('.js-field-child').click ->
		if $(this).hasClass 'is-active'
			$('.js-field-child').removeClass 'is-active' 
			$('.section-choice').removeClass 'is-open' 
			removeClass = false
		else
			# $('.js-section-choice').width($('.js-field-child').width())
			$('.js-field-child').removeClass 'is-active'
			$('.section-choice').removeClass 'is-open'
			$(this).siblings('.section-choice').addClass 'is-open'
			removeClass = true
		return false
	item.click ->
		return false

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
	$(this).parent('.section-choice').siblings('.js-field-child').text($(this).text())


$('.js-remove-parent').each ->
	elParent = $(this)

	elParent.find('.js-remove-item').click ->
		item = $('.content-favorites__item')
		elTotal = elParent.find(item).length
		
		$(this).closest(item).remove()
		console.log(elParent.find(item).length)
		if elTotal == 1
			elParent.remove()
		false
		return 



$('.js-table-scroll').jScrollPane({
   	autoReinitialise: true
})


$('.js-field-child').click ->
  list = $(this).siblings('.section-choice')
  if !list.hasClass 'jspScrollable'
    list.addClass 'jspScrollable'
    list.jScrollPane()
    return
  return
 
$('.js-selection-city').click ->   
	text = $(this).text()
	$('.js-selection-main').text(text)
	$(this).closest('.section-choice').removeClass 'is-open'

	
		
	
$('.js-date-mast').inputmask 
	mask: "99.99.9999 " 