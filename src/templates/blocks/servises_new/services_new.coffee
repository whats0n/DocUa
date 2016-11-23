# $('.js-s-text-btn').on('click', function(){
# 	$(this).toggleClass('is-open');
# 	$(this).siblings('.js-s-text-b').toggleClass('is-open');
# 	if ($('.js-s-text-b').hasClass('is-open')) {
# 		$('.js-s-text-btn').text('скрыть');
# 	} else {
# 		$('.js-s-text-btn').text('дальше');
# 	}
# });

$('.js-s-text-btn').on 'click', ->
	$(@).toggleClass 'is-open'
	$(@).parents('.js-s-text').toggleClass 'is-open'
	$(@).siblings('.js-s-text-b').toggleClass 'is-open'
	if $(@).hasClass('is-open')
		$(@).text 'скрыть'
	else
		$(@).text 'дальше'
		$('body').animate scrollTop: 0
	false

$('.js-s-link-more').on 'click', ->
	$(@).toggleClass 'is-open'
	$(@).siblings('.js-s-items-more').toggleClass 'is-open'
	if $(@).hasClass('is-open')
		$(@).text 'Свернуть'
	else
		$(@).text 'Показать все'
	false