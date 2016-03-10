$('.js-tab__header-c').click  ->
  $(@).children('span').toggleClass 'tab__header_open'
  item = $(@).children('.js-content-hide')
  item.slideToggle 'fast'
  item.toggleClass 'tab-active_info'
  $(@).find('.btn__mobile').toggleClass 'btn__mobile_open'
  #event.stopPropagation();
  false
