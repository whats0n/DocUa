# $('.js-finder-scroll').on 'click', ->
flags = true
$('.js-location-lists').on 'click', ->
	list = $(this).children('.js-lists')

	list.show()

	if !list.hasClass 'jspScrollable'
		list.addClass 'jspScrollable'
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

