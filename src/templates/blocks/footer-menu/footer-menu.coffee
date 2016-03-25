if window.matchMedia('screen and (max-width: 767px)').matches
  $('.js-tab__mobile-f').addClass 'js-tab__header-f'



$('.js-tab__header-f').click  ->
  parent = $(@).parent(".js-tab__parent-index")
  item = parent.children('.js-content_hide-index')
  item.slideToggle 'fast'
  item.toggleClass 'tab-active_info-index'
  parent.find('.btn__mobile').toggleClass 'btn__mobile_open'
  $(@).toggleClass 'tab__header_open'  
  #event.stopPropagation();
  false

# $('.js-tab__header-f').click  ->
#   item = $(@).children('.js-content_hide-index')
#   item.slideToggle 'fast'
#   item.toggleClass 'tab-active_info-index'
#   $(@).toggleClass 'tab__header_open'
#   $(@).find('.btn__mobile').toggleClass 'btn__mobile_open'
#   #event.stopPropagation();
#   false

 
    # $('.footer-menu__item-link')
    #     .on "click", (e) ->
    #         if $(window).width() < 768
    #             $(@).parent().find('.footer-sub-menu').slideToggle 300