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
    
    $.ui.autocomplete.prototype._renderItem = (ul, item) ->
        highlighted = item.label.split(this.term).join('<span class="is-active">' + this.term +  '</span>')
        return $("<li></li>").data("item.autocomplete", item).append('<a class="search-select" data-search="' + item.label + '">' + highlighted + '</a>').appendTo(ul);

    availableTags = [
        '(Биохимия для ФиброМакса) (Холестерин; Глюкоза (сыворотка); Билирубин γ-глутаматтрансфераза (Холестерин; Глюкоза (сыворотка); Билирубин γ-глутаматтрансфераза (Холестерин; Глюкоза (сыворотка); Билирубин γ-глутаматтрансфераза'
        'ФиброМакс (Холестерин; Глюкоза (сыворотка); Триглицериды; Гаптоглог γ-глутаматтрансфераза'
        'γ-глутаматтрансфераза'
        'γ-глутаматтрансфераза (ГГТ, GGT)'
        'γ-глутаматтрансфераза (ГГТ)'
        'Тиреоидная панель'
        'Тиреоглобулин (ТГ)'
        'Тиреоглобулин, антитела (АТТГ)'
        'Тиреоидный: ТТГ, Т4 св., АМСт (тиреотропный гормон (ТТГ); Тироксин свободный (T4 свободный) '
        'Тиреотропный гормон (ТТГ)'
        'Тироксин общий'
        'Тироксин свободный (T4 свободный)'
        'Lorem ipsum dolor sit amet, consectetur adipisicing elit. Illo facilis necessitatibus omnis unde? Et nobis, placeat odio non corrupti molestiae iure earum repellendus tempora velit voluptate iusto deserunt. Accusantium, maiores!'
    ]

    $('.js-finder-autocomplete').autocomplete 
        source: availableTags,
        appendTo: ".finder__field"
        open: ->
            $(this).data('uiAutocomplete').menu.element.addClass 'subject-scroll'
            if undefined != _jScrollPane 
                _jScrollPaneAPI.destroy() 
            if  $('.subject-scroll').height() <= _jSheight
                $('.subject-scroll > li').wrapAll $('<ul class="scroll-panel"></ul>').css('height', 'auto')
                $('.ui-menu-item').addClass 'no-scroll'
            else 
                $('.subject-scroll > li').wrapAll $('<ul class="scroll-panel"></ul>').height(_jSheight)
                _jScrollPane = $('.scroll-panel').jScrollPane()
                _jScrollPaneAPI = _jScrollPane.data('jsp')

            if $('.ui-menu-item').height() >= 20
                _this = $('.ui-menu-item')
                _this.addClass 'js-text-hidden' 
                _this.dotdotdot
                    elipsis: " ...",
                    fallbackToLetter: true,
            return 
        close: (event, ui) ->
            _jScrollPaneAPI.destroy()
            _jScrollPane = undefined
            return
        select: (event, ui) -> 
            $(this).val ui.item.label
            false
        source: (request, response) ->
            noResultFinder = $('.no-results-finder')
            results = $.ui.autocomplete.filter(availableTags, request.term)
            if !results.length
                noResultFinder.addClass('is-hide')
            else
                noResultFinder.removeClass('is-hide')
            response results

            $.ajax
                url: '/analysis/search/live',
                dataType: 'json',
                method: 'GET',
                data: {term: request.term}
                success: (data) ->
                    results = $.ui.autocomplete.filter(data.list, request.term)
                    
                    if !results.length
                        noResultFinder.addClass('is-hide')
                    else
                        noResultFinder.removeClass('is-hide')
                    response results

            if !($('.js-finder-autocomplete').val().length >= 2)
                noResultFinder.removeClass('is-hide') 
            return

# index autocomplete
$(".js-index-autocomplete").each ->
    complete = $(this)
    searchHidden = complete.siblings('.search-result')
    _jScrollPane = undefined
    _jScrollPaneAPI = undefined
    _jSheight = 250

    # autocomplete width
    jQuery.ui.autocomplete::_resizeMenu = ->
        ul = @menu.element
        ul.outerWidth @element.outerWidth()
        return
    projects = [
        {
            value: 'Врач нетрадиционной медицины'
            label: 'Врач нетрадиционной медицины'
            desc: 'Список врачей'
            icon: 'icon-list-doctors.png'
        }
        {
            value: 'Кардиология'
            label: 'Кардиология'
            desc: 'Диагностические центры'
            icon: 'icon-list-diagnostic-centers.png'
        }
        {
            value: 'Калиниченко Владислав Петрович'
            label: 'Калиниченко Владислав Петрович'
            desc: 'Врач'
            icon: 'doc.png'
        }
    ]

    complete.autocomplete
        minLength: 2,
        open: ->
            $(this).data('uiAutocomplete').menu.element.addClass 'index-autocomplete js-lists'
            if undefined != _jScrollPane
                _jScrollPaneAPI.destroy()
            if  $('.index-autocomplete').height() <= _jSheight
                $('.index-autocomplete > li').wrapAll $('<ul class="scroll-panel"></ul>').css('height', 'auto')
            else
                $('.index-autocomplete > li').wrapAll $('<ul class="scroll-panel"></ul>').height(_jSheight)
                _jScrollPane = $('.scroll-panel').jScrollPane()
                _jScrollPaneAPI = _jScrollPane.data('jsp')
            return
        close: (event, ui) ->
            # _jScrollPaneAPI.destroy()
            _jScrollPane = undefined
            return
        focus: (event, ui) -> 
            # complete.val( ui.item.label )
            return false
        select: (event, ui) -> 
            $(this).val ui.item.label
            false
        source: (request, response)-> 
            $.ajax
                url: '/analysis/search/live/index-search.json',
                dataType: 'json',
                method: 'GET',
                data: {term: request.term} 
                success: (data) -> 
                    results = $.ui.autocomplete.filter(data.projects, request.term)
                    noResult = complete.siblings('.index-no-result')
                    # if !results.length
                    #     noResult.show()
                    # else
                    #     noResult.hide()
                    response results

            if !($(".js-index-autocomplete").val().length >= 3)
                # console.log('bla')
                searchHidden.hide('slow')

            return
            
    complete.data( "ui-autocomplete")._renderItem =( ul, item ) -> 
        $li = $('<li>')
        $img = $('<img>')
        newText = String(item.value).replace(new RegExp(@term, 'gi'), '<span class=\'ui-menu-item-highlight\'>$&</span>')

        $img.attr
            src: 'i/new-search/' + item.icon,
            alt: item.label 

        $li.attr('data-value', item.label)
        $li.addClass('top-list__item')
        $li.append('<a href="#" class="top-list__item-link">')
        # insert img
        $li.find('.top-list__item-link').append('<div class="top-list__picture">')
        $li.find('.top-list__picture').append($img)
        # insert content
        $li.find('.top-list__item-link').append('<div class="top-list__left">')
        $li.find('.top-list__left').append('<div class="top-list__title">')
        $li.find('.top-list__title').data('item.autocomplete', item).append('<a href="#" class="js-search-title">' + newText + '</a>')
        # insert type
        $li.find('.top-list__item-link').append('<div class="top-list__right">')
        $li.find('.top-list__right').append('<div class="top-list__subject">')
        $li.find('.top-list__subject').append(item.desc)
        return $li.appendTo(ul) 

    complete.on "click", ->
        searchHidden.show()
        $('.top-list__title').dotdotdot
            lines: 2,
            responsive: true 

    $('.js-static-search').on "click", '.top-list__item', ->
        thisItem = $(this).find('.top-list__title')
        thisText = $(this).find('.top-list__title').text()
        completeThis = $(this).parents('.search-result').siblings(".js-index-autocomplete")

        completeThis.val(thisText)
        searchHidden.hide() 

    complete.on 'click', ->
        if $(this).val().length
            searchHidden.hide()
        else
            searchHidden.show() 

$(document).mouseup (e) ->
    container = $('.search-result')
    if container.has(e.target).length == 0
        container.hide()
    return


$(document).on 'click', '.js-select-scroll',->
    list = $('.js-select-scroll').find('.select7__drop-list')

    # select7_open

    if !list.hasClass 'jspScrollable'
        list.addClass 'jspScrollable'
        list.addClass 'js-lists'
        list.jScrollPane()
        return

$('body').on 'scroll', '.location', (e) ->
    e.stopPropagation()
