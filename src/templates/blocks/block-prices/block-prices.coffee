$(document).on 'click', '.js-prices-btn', ->
  drop = $(this).siblings('.js-prices-block')
  drop.slideToggle 'fast'
  $(this).parents('.js-prices').toggleClass 'active'
  false

$('.js-price-btn').on 'click', ->
	drop = $(this).siblings('.js-price-block')
	drop.slideToggle 'fast'
	$(this).parents('.js-price-tabs').toggleClass 'active'
	false