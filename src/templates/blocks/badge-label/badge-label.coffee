$ ->
    updateBadgeLabels = ->
        $(".badge-label").each ->
            w = $(@).outerWidth() / 2
            $(@).find(".badge-label__arrow").css borderLeftWidth: "#{w}px", borderRightWidth: "#{w}px"


    $(window).resize updateBadgeLabels
    $(document).on "shown.bs.tab", updateBadgeLabels
    $(document).on "shown.bs.modal", updateBadgeLabels
    updateBadgeLabels()