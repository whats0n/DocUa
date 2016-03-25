$(document).ready ->
    $(".js-clamp-3").dotdotdot
        ellipsis: ' ...'
        wrap: "letter" 
        

# postLocationWidthFix = ->

#     $(".post").each ->
#         # unless $(@).closest(".widget").length
#         if $(@).hasClass("post_single")
#             if $(window).width() > 767
#                 locationWidth = $(@).find(".post__footer").width() - $(@).find(".post__price").width() - $(@).find(".post__submits").width() - 10
#                 locationValueWidth = locationWidth - 35
#                 px = "px"
#             else
#                 locationWidth = 'auto'
#                 locationValueWidth = 245
#                 px = ''
#         else 
#             if ($(window).width() > 979) || ($(window).width() < 768)
#                 locationWidth = $(@).find(".post__footer").width() - $(@).find(".post__price").width() + 10
#                 locationValueWidth = locationWidth - 35
#                 px = "px"
#             else
#                 locationWidth = 'auto'
#                 if $(@).closest(".widget").length
#                     locationValueWidth = 130
#                 else
#                     locationValueWidth = 180
#                 px = ''
#         $(@).find(".post__location").attr 'style', "width: #{locationWidth}#{px} !important"
#         $(@).find(".post__location-title").css maxWidth: "#{locationValueWidth}px"
#         $(@).find(".select7__current-value").css maxWidth: "#{locationValueWidth}px"


# $(window).resize postLocationWidthFix
# $(document).on "shown.bs.tab", postLocationWidthFix
# postLocationWidthFix()

