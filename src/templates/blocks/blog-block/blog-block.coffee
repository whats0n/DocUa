# $clamp module, clamp: 2 
$(".blog-list__item").each (el) ->
    if $(@).find('.clamp-js')
        module = $(@).find('.clamp-js')

        [].forEach.call module, (el) ->
          $clamp el, clamp: 2
          return

 
# module = document.querySelectorAll('.clamp-js')
# # $clamp module, clamp: 2 

# [].forEach.call module, (el) ->
#   $clamp el, clamp: 2
#   return
# if window.matchMedia('screen and (max-width: 767px)').matches
#   $('.js-blog_links').addClass 'clamp-js'  