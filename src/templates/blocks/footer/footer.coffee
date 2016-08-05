if ($(document).height() <= $(window).height())
    $(".container-fluid_footer-bg").addClass("sticky-footer")

    
# bodyPaddingBottomFn = ->
#   if not $("body").hasClass('body-partners')
#        $("body > .main-content").css paddingBottom: "#{$(".footer").outerHeight() - 2}px"
# bodyPaddingBottomFn()
# $(window).resize bodyPaddingBottomFn

# waitForWebFonts ['PT Sans'], ->
#     $(window).resize()
