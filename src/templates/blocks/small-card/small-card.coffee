smallCardInit = ->
    windowWidth = $(window).width()
    c = "small-card__job_fixmargin"
    if windowWidth < 768
        $(".small-card__job").removeClass c
        return
    w = if windowWidth < 980 then 235 else 400

    $(".small-card__job strong").each ->
        $(@).closest(".small-card__job").toggleClass c, $(@).width() > w

$(window).resize smallCardInit
smallCardInit()
$("body").on "smallCardInit", smallCardInit