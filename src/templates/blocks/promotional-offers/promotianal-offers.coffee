# tabs with atrr
$(document).on 'click', '.js-offers-btn', ->
  drop = $(this).parents('.js-offers-tabs').find('.js-offers-content')
  changeText = $(this).children('.dotted')
  getAttr = changeText.data('hidden')
  getText = changeText.text()
  getTextAttr = changeText.data('name')

  drop.slideToggle 'fast'
  $(this).parents('.js-offers-tabs').toggleClass 'is-active'

  changeText.toggleClass 'is-change'
  
  if changeText.hasClass 'is-change'
    changeText.attr("data-name", getText)
    changeText.text(getAttr)
  else
    changeText.text(getTextAttr) 

  false

