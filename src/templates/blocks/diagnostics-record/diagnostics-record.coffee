if window.matchMedia('screen and (max-width: 767px)').matches
  $('.js-tab__mobile-d').addClass 'js-tab__header-d'

$('.js-tab__header-d').click  ->
  parent = $(@).parent(".js-tab__parent-index")
  item = parent.children('.js-content-hide')
  item.slideToggle 'fast'
  item.toggleClass 'tab-active_info-index'
  parent.find('.btn__mobile').toggleClass 'btn__mobile_open'
  $(@).toggleClass 'tab__header_open'  
  #event.stopPropagation();
  false

 
