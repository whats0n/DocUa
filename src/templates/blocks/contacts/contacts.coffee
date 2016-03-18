if window.matchMedia('screen and (max-width: 767px)').matches
  $('.js-tab__mobile-c').addClass 'js-tab__header-c' 

$('.js-tab__header-c').click  ->
  $(@).children('span').toggleClass 'tab__header_open'
  item = $(@).children('.js-content-hide')
  item.slideToggle 'fast'
  item.toggleClass 'tab-active_info-index'
  $(@).find('.btn__mobile').toggleClass 'btn__mobile_open'
  #event.stopPropagation();
  false
