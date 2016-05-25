
$("#select-area").on "areaSelected", (e, {values}) ->
    title = (value.title for value in values).join ", "
    value = (value.value for value in values).join ", "
    # $(".finder [data-target='#select-area'] input[type='hidden']").val value
    $(".js-services-go [data-target='#select-area']").parent().find('.finder__field-text:last')
        .val(if values.length > 0 then title else $(".js-services-go [data-target='#select-area'] .finder__field-text").data "emptyText")
        .toggleClass("grey", values.length is 0)
    $("#select-area").modal "hide"