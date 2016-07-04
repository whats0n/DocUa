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
    $(".finder [data-target='#select-area'] input[type='hidden']").val ""
    off

$("#select-countries [data-action='reset']").click ->
    $("#select-countries").find(".pill :checked").prop "checked", no
    $(".finder [data-target='#select-countries'] .finder__field-text")
        .text($(".finder [data-target='#select-countries'] .finder__field-text").data "emptyText")
        .addClass("grey")
    $(".finder [data-target='#select-countries'] input[type='hidden']").val ""
    off

# popup submits

$("#select-specialization").on "click", "li a", (e) ->
    {value} = $(e.currentTarget).data()
    title = trim $(e.currentTarget).text()
    value = title if not value
    dataValue = trim $(e.target).data('value')
    $(".finder").trigger "specializationSelected", title: title, value: value, dataValue: dataValue
    off

$("select-other-spec").on "click", "li a", (e) ->
    {value} = $(e.currentTarget).data()
    title = trim $(e.currentTarget).text()
    value = title if not value
    dataValue = trim $(e.target).data('value')
    $(".finder").trigger "specializationSelected2", title: title, value: value, dataValue: dataValue
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
    $(".finder [data-target='#select-specialization']").parent().find('.finder__field-text:first')
        .val(if value then title else $(".finder [data-target='#select-specialization'] .finder__field-text").data "emptyText")
        .toggleClass("grey", not value)
    $(".finder [data-target='#select-specialization'] input[type='hidden']").val value
    $("#select-specialization").modal "hide"

$(".finder").on "specializationSelected2", (e, {title, value, dataValue}) ->
    if docMaps.pageName == 'map' and value
        docMaps.loadDoctors('specialty', dataValue)
    $(".finder [data-target='#select-specialization']").parent().find('.finder__field-text:first')
        .val(if value then title else $(".finder [data-target='#select-specialization'] .finder__field-text").data "emptyText")
        .toggleClass("grey", not value)
    $(".finder [data-target='#select-specialization'] input[type='hidden']").val value
    $("#select-specialization").modal "hide"

 $(".finder").on "branchSelected", (e, {title, value}) ->
   $(".finder [data-target='#select-branch']").parent().find('.finder__field-text:first')
        .val(if value then title else $(".finder [data-target='#select-branch'] .finder__field-text").data "emptyText")
        .toggleClass("grey", not value)
   $("#select-branch").modal "hide"
   $(".finder [data-target='#select-branch'] input[type='hidden']").val value
   false


 $(".finder").on "actionsSelected", (e, {title, value}) ->
   $(".finder [data-target='#select-actions']").parent().find('.finder__field-text:first')
       .val(if value then title else $(".finder [data-target='#select-actions'] .finder__field-text").data "emptyText")
       .toggleClass("grey", not value)
   $("#select-actions").modal "hide"
   $(".finder [data-target='#select-actions'] input[type='hidden']").val value
   false

 $(".finder").on "bundlesSelected", (e, {title, value}) ->
   $(".finder [data-target='#select-bundles']").parent().find('.finder__field-text:first')
       .val(if value then title else $(".finder [data-target='#select-bundles'] .finder__field-text").data "emptyText")
       .toggleClass("grey", not value)
   $(".finder [data-target='#select-bundles'] input[type='hidden']").val value
   $("#select-bundles").modal "hide"
   false

# $(".finder").on "diagnosticSelected", (e, {title, value}) ->
#   $(".finder [data-target='#select-area-diagnostics'] .finder__field-text")
#       .text(if value then title else $(".finder [data-target='#select-area-diagnostics'] .finder__field-text").data "emptyText")
#       .toggleClass("grey", not value)
#   $(".finder [data-target='#select-area-diagnostics'] input[type='hidden']").val value
#   $("#select-area-diagnostics").modal "hide"

$("#select-area").on "areaSelected", (e, {values}) ->
    title = (value.title for value in values).join ", "
    value = (value.value for value in values).join ", "
    $(".finder [data-target='#select-area'] input[type='hidden']").val value
    $(".finder [data-target='#select-area']").parent().find('.finder__field-text:last')
        .val(if values.length > 0 then title else $(".finder [data-target='#select-area'] .finder__field-text").data "emptyText")
        .toggleClass("grey", values.length is 0)
    $("#select-area").modal "hide"
    
$('.finder').on 'diagnosticSelected', (t, e) ->
  n = undefined
  i = undefined
  n = e.title
  i = e.value
  $('.finder [data-target=\'#select-area-diagnostics\'] .finder__field-text').text(if i then n else $('.finder [data-target=\'#select-area-diagnostics\'] .finder__field-text').data('emptyText')).toggleClass('grey', !i)
  $('.finder [data-target=\'#select-area-diagnostics\'] input[type=\'hidden\']').val(i)
  $('#select-area-diagnostics').modal('hide')





# cla autocomplete
$(".js-finder-autocomplete").each ->
    _jScrollPane = undefined
    _jScrollPaneAPI = undefined
    _jSheight = 342
    # _autoheight = auto

    # Custom autocomplete instance.
    # $.widget 'app.autocomplete', $.ui.autocomplete,
    #     options: highlightClass: 'ui-state-highlight'
    #     _renderItem: (ul, item) ->
    #         # Replace the matched text with a custom span. This
    #         # span uses the class found in the "highlightClass" option.
    #         re = new RegExp('(' + @term + ')', 'gi')
    #         cls = @options.highlightClass
    #         template = '<span class=\'' + cls + '\'>$1</span>'
    #         label = item.label.replace(re, template)
    #         $li = $('<li/>').appendTo(ul)
    #         # Create and return the custom menu item content.
    #         $li.html(label).appendTo ('.subject-scroll')
    #         $li

    # $.ui.autocomplete.prototype._renderItem = (ul, item) ->
    #   item.label = item.label.replace(new RegExp("(?![^&;]+;)(?!<[^<>]*)(" + $.ui.autocomplete.escapeRegex(this.term) + ")(?![^<>]*>)(?![^&;]+;)", "gi"), "<strong>$1</strong>")
    #   return $('<li></li>').data('item.autocomplete', item).append('<a>' + item.label + '</a>').appendTo ul
    $.ui.autocomplete.prototype._renderItem = (ul, item) ->
        highlighted = item.label.split(this.term).join('<span class="is-active">' + this.term +  '</span>')
        return $("<li></li>").data("item.autocomplete", item).append('<a>' + highlighted + '</a>').appendTo(ul);

    # monkeyPatchAutocomplete = ->
    #   # Don't really need to save the old fn, 
    #   # but I could chain if I wanted to
    #   oldFn = $.ui.autocomplete::_renderItem

    #   $.ui.autocomplete::_renderItem = (ul, item) ->
    #     re = new RegExp('^' + @term, 'i')
    #     t = item.label.replace(re, '<span class="is-active">' + @term + '</span>')
    #     $('<li>' + t + '</li>').data('item.autocomplete', item).appendTo ul

    #   return

    # monkeyPatchAutocomplete()

    availableTags = [
        '(Биохимия для ФиброМакса) (Холестерин; Глюкоза (сыворотка); Билирубин γ-глутаматтрансфераза (Холестерин; Глюкоза (сыворотка); Билирубин γ-глутаматтрансфераза (Холестерин; Глюкоза (сыворотка); Билирубин γ-глутаматтрансфераза'
        'ФиброМакс (Холестерин; Глюкоза (сыворотка); Триглицериды; Гаптоглог γ-глутаматтрансфераза '
        'γ-глутаматтрансфераза'
        'γ-глутаматтрансфераза (ГГТ, GGT)'
        'γ-глутаматтрансфераза (ГГТ)'
        'Тиреоидная панель'
        'Тиреоглобулин (ТГ)'
        'Тиреоглобулин, антитела (АТТГ)'
        'Тиреоидный: ТТГ, Т4 св., АМСт (тиреотропный гормон (ТТГ); Тироксин свободный (T4 свободный) Тирокси'
        'Тиреотропный гормон (ТТГ)'
        'Тироксин общий'
        'Тироксин свободный (T4 свободный)'
    ]

    $('.js-finder-autocomplete').autocomplete 
        source: availableTags,
        appendTo: ".finder"
        open: ->
            $(this).data('uiAutocomplete').menu.element.addClass 'subject-scroll'
            if undefined != _jScrollPane 
                _jScrollPaneAPI.destroy() 
            if  $('.subject-scroll').height() <= _jSheight
                $('.subject-scroll > li').wrapAll $('<ul class="scroll-panel"></ul>').css('height', 'auto')
                console.log('aa')
            else 
                console.log('go')
                $('.subject-scroll > li').wrapAll $('<ul class="scroll-panel"></ul>').height(_jSheight)
                _jScrollPane = $('.scroll-panel').jScrollPane()
                _jScrollPaneAPI = _jScrollPane.data('jsp')

            if $('.ui-menu-item').height() >= 80
                _this = $('.ui-menu-item')
                _this.addClass 'js-text-hidden' 
                _this.dotdotdot
                    elipsis: " ..."
            return 
        close: (event, ui) ->
            _jScrollPaneAPI.destroy()
            _jScrollPane = undefined
            return
        select: (event, ui) -> 
            $(this).val ui.item.label
            false

    

