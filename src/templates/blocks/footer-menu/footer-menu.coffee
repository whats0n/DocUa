$('.js-tab__header-f').click  ->
  item = $(@).children('.js-content-hide')
  item.slideToggle 'fast'
  item.toggleClass 'tab-active_info'
  $(@).toggleClass 'tab__header_open'
  $(@).find('.btn__mobile').toggleClass 'btn__mobile_open'
  #event.stopPropagation();
  false
