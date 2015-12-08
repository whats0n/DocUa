$('.js-services-btn').on 'click', ->
  drop = $(this).siblings('.js-services-block')
  drop.slideToggle 'fast'
  $(this).parents('.js-services').toggleClass 'active'
  false