trim = (s) -> s.replace(///^\s*///, '').replace(///\s*$///, '')

$(".finder").on "columnagram.columnized", ->
    setTimeout =>
        $(@).addClass "finder_loaded"
    , 50

$(".finder .finder__field-text").each -> $(@).data "emptyText", $(@).text()

# uncheck all pill on tab change
$("a[data-toggle='tab'][href='#select-area-metro'], a[data-toggle='tab'][href='#select-area-districts']").on "shown.bs.tab", (e) ->
    $("#select-area").find(".pill :checked").prop "checked", no

# reset link
$("#select-area [data-action='reset']").click ->
    $("#select-area").find(".pill :checked").prop "checked", no
    $(".finder [data-target='#select-area'] .finder__field-text")
        .text($(".finder [data-target='#select-area'] .finder__field-text").data "emptyText")
        .addClass("grey")
    $(".finder [data-target='#select-area'] input[type='hidden']").val value
    off

$("#select-countries [data-action='reset']").click ->
    $("#select-countries").find(".pill :checked").prop "checked", no
    $(".finder [data-target='#select-countries'] .finder__field-text")
        .text($(".finder [data-target='#select-countries'] .finder__field-text").data "emptyText")
        .addClass("grey")
    $(".finder [data-target='#select-countries'] input[type='hidden']").val value
    off

# popup submits

$("#select-specialization").on "click", "li a", (e) ->
    {value} = $(e.currentTarget).data()
    title = trim $(e.currentTarget).text()
    value = title if not value
    dataValue = trim $(e.target).data('value')
    $(".finder").trigger "specializationSelected", title: title, value: value, dataValue: dataValue
    off

$("#select-branch").on "click", "li a", (e) ->
    {value} = $(e.currentTarget).data()
    title = trim $(e.currentTarget).text()
    value = title if not value
    $(".finder").trigger "branchSelected", title: title, value: value
    off

$("#select-actions").on "click", "li a", (e) ->
    {value} = $(e.currentTarget).data()
    title = trim $(e.currentTarget).text()
    value = title if not value
    $(".finder").trigger "actionsSelected", title: title, value: value
    off

$("#select-bundles").on "click", "li a", (e) ->
    {value} = $(e.currentTarget).data()
    title = trim $(e.currentTarget).text()
    value = title if not value
    $(".finder").trigger "bundlesSelected", title: title, value: value
    off

$("#select-area-diagnostics").on "click", "li a", (e) ->
    {title, value} = $(e.currentTarget).data()
    defaultTitle = if $(e.currentTarget).siblings("ul").length
        trim $(e.currentTarget).text()
    else
        "#{trim $(e.currentTarget).parent().parent().parent().find(">a:first").text()} #{trim $(e.currentTarget).text()}"
    title = defaultTitle unless title
    value = title unless value
    $(".finder").trigger "diagnosticSelected", title: title, value: value
    off

$("#select-area").on "click", ".modal-footer .btn", ->
    values = []
    $("#select-area .pill :checked").each ->
        $pill = $(@).closest(".pill")
        $parentPill = $pill.closest("ul").siblings(".pill")
        if $parentPill.length is 1
            return if $parentPill.find(":checked").length
        {value} = $pill.data()
        title = trim $pill.text()
        value = title if not value
        values.push title: title, value: value
    $("#select-area").trigger "areaSelected", values: values

# chooser quick links

$(".finder #doctors").on "click", ".chooser__list__item-link", (e) ->
    {value} = $(e.target).data()
    title = trim $(e.target).text()
    value = title if not value
    $(".finder").trigger "specializationSelected", title: title, value: value
    off

$(".finder #clinics").on "click", ".chooser__list__item-link", (e) ->
    {value} = $(e.target).data()
    title = trim $(e.target).text()
    value = title if not value
    $(".finder").trigger "branchSelected", title: title, value: value
    off

# popup submit handlers

$(".finder").on "specializationSelected", (e, {title, value, dataValue}) ->
    if docMaps.pageName == 'map' and value
        docMaps.loadDoctors('specialty', dataValue)
    $(".finder [data-target='#select-specialization']").parent().find('.finder__field-text')
        .val(if value then title else $(".finder [data-target='#select-specialization'] .finder__field-text").data "emptyText")
        .toggleClass("grey", not value)
    $("#select-specialization").modal "hide"

 $(".finder").on "branchSelected", (e, {title, value}) ->
   $(".finder [data-target='#select-branch']").parent().find('.finder__field-text')
        .val(if value then title else $(".finder [data-target='#select-branch'] .finder__field-text").data "emptyText")
        .toggleClass("grey", not value)
   $("#select-branch").modal "hide"

 $(".finder").on "actionsSelected", (e, {title, value}) ->
   $(".finder [data-target='#select-actions']").parent().find('.finder__field-text')
       .val(if value then title else $(".finder [data-target='#select-actions'] .finder__field-text").data "emptyText")
       .toggleClass("grey", not value)
   $("#select-actions").modal "hide"

 $(".finder").on "bundlesSelected", (e, {title, value}) ->
   $(".finder [data-target='#select-bundles']").parent().find('.finder__field-text')
       .val(if value then title else $(".finder [data-target='#select-bundles'] .finder__field-text").data "emptyText")
       .toggleClass("grey", not value)
   $("#select-bundles").modal "hide"

# $(".finder").on "diagnosticSelected", (e, {title, value}) ->
#   $(".finder [data-target='#select-area-diagnostics'] .finder__field-text")
#       .text(if value then title else $(".finder [data-target='#select-area-diagnostics'] .finder__field-text").data "emptyText")
#       .toggleClass("grey", not value)
#   $(".finder [data-target='#select-area-diagnostics'] input[type='hidden']").val value
#   $("#select-area-diagnostics").modal "hide"

$("#select-area").on "areaSelected", (e, {values}) ->
    title = (value.title for value in values).join ", "
    value = (value.value for value in values).join ", "
    $(".finder [data-target='#select-area']").parent().find('.finder__field-text')
        .val(if values.length > 0 then title else $(".finder [data-target='#select-area'] .finder__field-text").data "emptyText")
        .toggleClass("grey", values.length is 0)
    $("#select-area").modal "hide"


