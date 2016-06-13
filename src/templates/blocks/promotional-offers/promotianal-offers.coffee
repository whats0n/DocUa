$(document).on 'click', '.js-offers-btn', ->
  drop = $(this).parents('.js-offers-tabs').find('.js-offers-content')
  drop.slideToggle 'fast'
  $(this).parents('.js-offers-tabs').toggleClass 'is-active'
  

  if $('.js-offers-tabs').hasClass('is-active')
    $(this).find('.js-change-text').text 'свернуть перечень анализов'
  else
    $(this).find('.js-change-text').text 'смотреть перечень анализов'

  false 