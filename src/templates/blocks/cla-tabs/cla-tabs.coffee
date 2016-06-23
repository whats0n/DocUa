 $(document).on 'click', '.js-cla-btn', ->
   drop = $(this).siblings('.js-cla-block')
   drop.slideToggle 'fast'
   $(this).parents('.js-cla-tabs').toggleClass 'active'
   false