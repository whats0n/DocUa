# $('.js-finder-scroll').on 'click', ->
flags = true
$('.js-location-lists').on 'click', ->
	list = $(this).children('.js-lists')
	paneHeight = 216
	list.show() 

	if list.height() <= paneHeight
		# console.log('bla')
		list.css('height', 'auto')
		list.css('padding', '0')
	else
		# console.log('nebla')
		list.height(paneHeight)
		list.jScrollPane()
		# list.addClass 'jspScrollable'
		# list.jScrollPane({
		# 	autoReinitialise: true
		# 	})
		$(this).addClass 'is-active'
	
	# if !list.hasClass 'jspScrollable'
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
  return

