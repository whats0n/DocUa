$ ->
    updateGroup1 = ->
        $(".x-check-group1").toggle $(".x-check-group1-toggle").prop "checked"

    updateGroup1()
    $(".x-check-group1-toggle").change updateGroup1

    updateGroup2 = ->
        $(".x-check-group2").toggle $(".x-check-group2-toggle").prop "checked"

    updateGroup2()
    $(".x-check-group2-toggle").change updateGroup2