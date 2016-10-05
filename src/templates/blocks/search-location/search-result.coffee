# $('.js-finder-scroll').on 'click', ->
flags = true
$('.js-location-lists').on 'click', ->
	list = $(this).children('.js-lists')
	paneHeight = 216
	
	list.show() 
	list.addClass('is-show') 

	if list.height() <= paneHeight
		list.css('height', 'auto')
		list.css('padding', '0')
	else
		list.height(paneHeight)
		list.jScrollPane()
		$(this).addClass 'is-active'
		return
	flags = false
	return 
	
$('body').on 'click', '.js-lists-item',->
	changeText = $(this).closest('.js-lists').siblings('.finder__field-text')
	parent = $(this).closest('.js-lists')
	value = $(this).text()

	changeText.val(value)
	$(this).addClass 'is-active'
	changeText.addClass 'is-change'
	# parent.addClass 'hidden'
	parent.hide()
	parent.removeClass('is-show')
	flags = true


# $('body').on 'click', ->
# 	child = $('.js-location-lists').children('.js-lists')
# 	if flags

# 		child.hide()
# 		console.log('bla')
$(document).mouseup (e) ->
  container = $('.js-lists')
  if container.has(e.target).length == 0
    container.hide()
    container.removeClass('is-show')
  return

