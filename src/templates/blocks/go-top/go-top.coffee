SHOW_GOTOP_AFTER = 500
$goTop = $(".go-top")

$goTop.toggle goTopShown = $(window).scrollTop() > SHOW_GOTOP_AFTER

$goTop.click ->
    $('html,body').animate {scrollTop: 0}, 800
    return false

$(window).scroll ->
    if not goTopShown and $(window).scrollTop() > SHOW_GOTOP_AFTER
        $goTop.stop(true, true).fadeIn "fast"
        goTopShown = yes
    else if goTopShown and $(window).scrollTop() <= SHOW_GOTOP_AFTER
        $goTop.stop(true, true).fadeOut "fast"
        goTopShown = no