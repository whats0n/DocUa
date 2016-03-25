if window.matchMedia('screen and (max-width: 767px)').matches
  $('.js-tab__mobile-c').addClass 'js-tab__header-c' 

$('.js-tab__header-c').click  ->
  parent = $(@).parent(".js-tab__parent-index")
  item = parent.children('.js-content_hide-index')
  item.slideToggle 'fast'
  # item.find(".js-contacts__phone").toggleClass 'tab-active_info-index'
  parent.find('.btn__mobile').toggleClass 'btn__mobile_open'
  $(@).toggleClass 'tab__header_open'  
  #event.stopPropagation();
  false


    # $('.contacts__title')
    #     .on "click", (e) ->
    #         if $(window).width() < 768
    #             $(@).parent().find('.contacts__phone').slideToggle 300