$ ->
    $.fn.applyRegularScript = ->
        @find(".phone-input-mask").inputmask
            mask: "+38 (999) 999-99-99",
            onBeforeMask: (value, opts) ->
                value.replace /^38/g, '', 
            onBeforePaste: (value, opts) ->
                value.replace /^38/g, ''

    $('body').applyRegularScript()

    #Items pagination
    pagination = ()->
        $(".pagination").removeAttr('style')
        paginationWidth = 0
        $(".pagination li").each ->
            paginationWidth += $(@).outerWidth(true)
        $(".pagination").width(paginationWidth + 5)

    pagination()

    #Items Load
    postLoadHeight = ->
        if $(window).width() < 560
            $('.post-load').height(180)
        else
            $('.post-load').height($('.post-load').parent().prev().find('.post').height() - 14)

    postLoadHeight()
    $('.navbar-main .navbar-toggle')
        .on "click", (e) ->
            $('.navbar-mobile').slideToggle 300
            $('body').toggleClass('lock')

    $('.footer-menu__item-link')
        .on "click", (e) ->
            if $(window).width() < 768
                $(@).parent().find('.footer-sub-menu').slideToggle 300
    $('.contacts__title')
        .on "click", (e) ->
            if $(window).width() < 768
                $(@).parent().find('.contacts__phone').slideToggle 300

    # detect scrollbar width
    $("body").prepend $scrollDiv = $("<div>").css
        width: "100px"
        height: "100px"
        overflow: "scroll"
        position: "absolute"
        top: "-9999px"
    scrollbarWidth = $scrollDiv.get(0).offsetWidth - $scrollDiv.get(0).clientWidth
    $scrollDiv.remove()

    #Article: h2, h3 user menu
    if $('.blog-diseases h2, .blog-diseases h3').length > 0
      $('<div class="disease-subTitle js-nav"></div><ul class="disease-subTitle__list"></ul></div>').insertAfter $('.disease-content header:not(.sr-only)').first()
      $.each $('.blog-diseases h2, .blog-diseases h3, .after-content-title p'), (index, val) ->
        if $(this).text()
          return $('.disease-subTitle__list').append('<li class="disease-subTitle__item first-child"><a class="disease-subTitle__link" href="#">' + $(this).text() + '</a></li>')
        return
      if '.list-view.tomenu'.length > 0
        findTitle = $('.list-view.tomenu').prev().text().replace(/^\S+/, '').replace(/^\s/, '')
        $('.disease-subTitle__list').append '<li><a href="#">' + findTitle + '</a></li>'
      $('.main-content').on 'click', '.disease-subTitle__list a', (e) ->
        offsetY = undefined
        offsetY = undefined
        offsetY = $('h2:contains(\'' + $(this).text() + '\'), h3:contains(\'' + $(this).text() + '\'), p:contains(\'' + $(this).text() + '\')').offset().top
        if $(window).width() < 768
          offsetY -= 40
        else
          offsetY -= 50
        $('html,body').animate { scrollTop: offsetY }, 300


    $("body").on "click", "[data-toggle='class']", (e) ->
        $el = if $(e.target).is("[data-toggle='class']") then $(e.target) else $(e.target).closest("[data-toggle='class']")
        {absSelector, className} = $el.data()
        if absSelector and className
            $(absSelector).toggleClass className
            e.preventDefault()
        else
            console.log "Incorrect [data-toggle='class'] usage. Please set data-abs-selector, data-class-name."

    $('body').on "click", ".dropdown:not(.dropdown_clickable) .dropdown-menu__item", (e) ->
        e.preventDefault()
        $dd = $(e.target).closest(".dropdown")
        $cv = $dd.find(".dropdown-current__value")
        if not $dd.is ".dropdown-static"
            value = $(e.target).data('value')
            html = $(e.target).html()
            $(@).html($cv.html()).data('value', $cv.data('value'))
            $cv.html(html).data('value', value)
            $dd.trigger "dropdown-change", value
    $(".dropdown:not(.dropdown-noopts)").each ->
        $(@).toggleClass "dropdown-noopts", $(@).find(".dropdown-menu__item").length is 0

    $("#select-area-districts").on "columnagram.columnized", (e, opts) ->
        $(@).attr "data-columnagram-column-count", opts.columns
        if opts.columns is 1
            $("#select-area-districts .columnize > div").css
                float: "none"
                width: "50%"
                marginLeft: "auto"
                marginRight: "auto"

    $(".columnize").each ->
        {columns, minColumnWidth, adaptiveColumnCount} = $(@).data()
        opts =
            columns: columns
            # balanceMethod: "balanceHeight"
        opts.minColumnWidth = minColumnWidth? or 160
        if adaptiveColumnCount
            opts.limitColumnCount = (c) ->
                w = $(window).width()
                if w < 768
                    c = 1
                else if w < 980 and c > 3
                    c = 3
                c
        opts.columns or= 4
        opts.columns = Math.min opts.columns, $(@).children().length
        # console.log opts
        $(@).on "columnagram.columnized", (e, eventData) ->
            $(@).addClass("columnized").attr "data-columnagram-column-count", opts.columns
        $(@).columnagram opts


    mobileCss = ->
        $('.navbar-mobile').css(
            top: $('.navbar-main').height()
        )

    mobileCss()

    $(window).resize ->
        postLoadHeight()
        pagination()
        $(".columnize").columnagram('recolumnize')
        if $(window).width() > 768
            $('.footer-sub-menu').removeAttr('style')
        mobileCss()

    $(document).on "shown.bs.tab", (e) ->
        tabSelector = $(e.target).attr("href")
        if $(tabSelector).find('.pagination').length > 0
            pagination()
        $(tabSelector).find(".columnize").each -> $(@).columnagram('recolumnize')
    $(document).on "show.bs.modal", (e) ->
        $(e.target).css(display: "block").find(".columnize").each -> $(@).columnagram('recolumnize')
    # $(document).on "shown.bs.modal", (e) ->
    #   $(e.target).find(".columnize").each -> $(@).columnagram('recolumnize')

    $(".odd-even").each ->
        $(@).children().each ->
            $(@).addClass if $(@).index() % 2 then "even" else "odd"

    $("ul").each -> $(@).find("> li:last").addClass "last-child"
    $("ul").each -> $(@).find("> li:first").addClass "first-child"

    $(".owl").each ->
        data = $(@).data()
        opts =
            navigation: on
            pagination: off
            navigationText: ["",""]
            rewindNav: off
            lazyLoad: true
            itemsDesktop: off
            itemsDesktopSmall: off
            itemsTablet: off
            itemsTabletSmall: off
            itemsMobile: off

        if $(@).is '.owl_single'
            opts.singleItem = yes
        else
            opts.items = data.itemsCount or 8

        if $(@).is ".owl_schedule"
            opts.items = 7
            opts.itemsTablet = [979,4]
            opts.itemsMobile = [767,2]
        if $(@).is ".gallery"
            opts.items = 4
            opts.itemsTablet = [979,5]
            opts.itemsMobile = [767,2]
        if $(@).is ".top-list-carousel" 
            opts.itemsTablet = [979,4]
            opts.itemsMobile = [767,1]

        $(@).owlCarousel opts

    $.fn.ratingStars = ->
        getAllPrev = (star) ->
            $stars = $(star).parent().find '>*'
            $stars.slice 0, $stars.index $(star)
        $.each @, ->
            $(@).hover ->
                $(@).add(getAllPrev(@)).addClass 'hover'
            , ->
                $(@).add(getAllPrev(@)).removeClass 'hover'
            $(@).click ->
                $(@).siblings().removeClass 'active'
                $(@).add(getAllPrev(@)).addClass 'active'
                $(@).find(':radio').get(0).checked = true
            $(@).find(":radio:checked").parent().trigger 'click'
        @ # chaining

    $(".rating__stars li").ratingStars()

    #Tooltips
    $("[data-toggle='tooltip']").tooltip
        container: 'body'
        $(".wrap").tooltip("hide")

    $("[data-toggle='tooltip-metro']").tooltip
        container: false

    $("a[href^='#']").click (e) ->
        href = $(@).attr 'href'
        $tabLink = $("a[data-toggle='tab'][href='#{href}']")
        if $tabLink.length > 0
            $tabLink.tab("show")
            e.preventDefault()
    if window.location.hash?[0] is '#'
        href = window.location.hash.split '/'
        $tabLink = $("a[data-toggle='tab'][href='#{href[0]}']")
        $tabLink.tab "show" if $tabLink.length > 0
        window.scrollTo 0, $("##{href[1]}").offset().top if href.length is 2

    $(document).on "reinitSelect2", (e) ->
        $select = $(e.target)

        $select.select2
            dropdownCssClass: $select.data 'dropdownClass'
            searchInputPlaceholder: $select.data 'searchPlaceholder'
            matcher: (term, text) ->
                return text.toUpperCase().indexOf(term.replace(/_/g, "").toUpperCase()) == 0

        $select.on 'select2-open', (e) ->
            $el = $(e.target)
            dropdownMask = $el.data 'dropdownMask'
            $searchField = $el.data('select2').search

            $container = $el.data('select2').container
            $container.css 'max-width', $container.parent().width()
            
            if dropdownMask
                $searchField.inputmask
                    mask: dropdownMask
            
            if dropdownMask == "99:99"
                $searchField.on 'keypress.mask keydown.mask', (e) ->                    
                    $searchField = $(e.target)
                    v = $searchField.val()
                    
                    x1 = parseInt(v.substring(0,1))
                    if x1 > 2
                        v = '0' + x1 + v.substring(2,5)
                        $searchField.val v.replace(/:|_/g, "")
                    
                    x2 = parseInt(v.substring(0,2))
                    if x2 > 23
                        v = '23' + v.substring(2,5)
                        $searchField.val v.replace(/:|_/g, "")
                    
                    y1 = parseInt(v.substring(3,4))
                    if y1 > 5
                        v = v.substring(0,2) + '5' + v.substring(4,5)
                        $searchField.val v.replace(/:|_/g, "")
        
        $select.on 'select2-close', (e) ->
            $el = $(e.target)
            $searchField = $el.data('select2').search


    $(document).on "reinitSelect7", (e) -> $(e.target).select7()
    $('.select2').trigger "reinitSelect2"
    $('.select7').trigger "reinitSelect7"

    # d = new Date (new Date).getTime() + 24 * 60 * 60 * 1000
    # [day, month, year] = [d.getDate(), d.getMonth() + 1, d.getYear() + 1900]
    # $('.datepicker').val "#{if day < 10 then "0#{day}" else day}.#{if month < 10 then "0#{month}" else month}.#{year}"

    $setDatePickerLang = (s) ->
        switch s
            when 'uk'
                $.extend $.fn.pickadate.defaults,
                    monthsFull: [ 'Січня', 'Лютого', 'Березня', 'Квітня', 'Травня', 'Червня', 'Липня', 'Серпня', 'Вересня', 'Жовтня', 'Листопада', 'Грудня' ],
                    monthsShort: [ 'Січ', 'Лют', 'Бер', 'Кві', 'Трі', 'Чер', 'Лип', 'Сер', 'Вер', 'Жов', 'Лис', 'Гру' ],
                    weekdaysFull: [ 'неділя', 'понеділок', 'вівторок', 'середа', 'четвер', 'п‘ятниця', 'субота' ],
                    weekdaysShort: [ 'нд', 'пн', 'вт', 'ср', 'чт', 'пт', 'сб' ],
                    today: 'сьогодні',
                    clear: 'викреслити'
            else
                $.extend $.fn.pickadate.defaults,
                    monthsFull: [ 'Января', 'Февраля', 'Марта', 'Апреля', 'Мая', 'Июня', 'Июля', 'Августа', 'Сентября', 'Октября', 'Ноября', 'Декабря' ],
                    monthsShort: [ 'Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн', 'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек' ],
                    weekdaysFull: [ 'воскресенье', 'понедельник', 'вторник', 'среда', 'четверг', 'пятница', 'суббота' ],
                    weekdaysShort: [ 'вс', 'пн', 'вт', 'ср', 'чт', 'пт', 'сб' ],
                    today: 'сегодня',
                    clear: 'удалить'

    # $('.datepicker').each ->
    #     val = $(@).val()
    #     $(@).data('value', val) if val
    #     submitFormat = $(@).data('dateFormatSubmit') or 'yyyy-mm-dd'
    #     displayFormat = $(@).data('dateFormatDisplay') or 'dd.mm.yyyy'
    #     setLang = $(@).data 'lang'
    #     $setDatePickerLang setLang

    #     $(@).pickadate
    #         format: displayFormat
    #         formatSubmit: submitFormat
    #         hiddenName: yes
    #         firstDay: 1
    #         min: true
    #         max: +62
    #         clear: ''
    #         labelMonthNext: ''
    #         labelMonthPrev: ''
    #         labelMonthSelect: ''
    #         labelYearSelect: ''
    #         onRender: ->
    #             $(@$root).find("select").trigger "reinitSelect7"
    #             isOpen = @get 'open'
    #             highlight = @get 'highlight', submitFormat
    #             value = @get 'select', submitFormat
    #             highlightedData = @get 'highlight'
    #             @set "select", highlightedData if (highlight != value) and isOpen

    $('.birthdaypicker').each ->
        val = $(@).val()
        $(@).data('value', val) if val
        submitFormat = $(@).data('dateFormatSubmit') or 'yyyy-mm-dd'
        displayFormat = $(@).data('dateFormatDisplay') or 'dd.mm.yyyy'
        setLang = $(@).data 'lang'
        $setDatePickerLang setLang

        $(@).pickadate
            format: displayFormat
            formatSubmit: submitFormat
            hiddenName: yes
            selectYears: 100                
            selectMonths: true
            firstDay: 1
            min: [1934,1,1]
            max: new Date()
            clear: ''
            today: ''
            labelMonthNext: ''
            labelMonthPrev: ''
            labelMonthSelect: ''
            labelYearSelect: ''
            onRender: ->
                $(@$root).find("select").trigger "reinitSelect7"
                isOpen = @get 'open'
                highlight = @get 'highlight', submitFormat
                value = @get 'select', submitFormat
                highlightedData = @get 'highlight'
                @set "select", highlightedData if (highlight != value) and isOpen


    $(".password-eye").click ->
        $(@).siblings("input[type=text], input[type=password]").each ->
        $(@).prev().attr "type", (if $(@).prev().attr("type") is "password" then "text" else "password")

    $('.scroll-pane:not(.scroll-pane_autoreinitialize_off)').jScrollPane
        autoReinitialise: on

    $('.scroll-pane.scroll-pane_autoreinitialize_off').jScrollPane
        autoReinitialise: off

    $("#symptoms-select").on
        change: (e) ->
            v = e.val or $("#symptoms-select").select2 "val"
            $("#symptoms-list-selector li").each ->
                $(@).toggleClass "symptoms__list-item_selected", "#{$(@).data("value")}" in v

    $("#symptoms-list-selector").on "click", "li", ->
        v = $("#symptoms-select").select2("val")
        if $(@).is ".symptoms__list-item_selected"
            v.splice v.indexOf("#{$(@).data("value")}"), 1
        else
            v.push "#{$(@).data("value")}"
        $("#symptoms-select").select2("val", v).trigger("change")

    $("#symptoms-list-selector").empty()
    $("#symptoms-select").find("option").each ->
        $("#symptoms-list-selector").append($("<li></li>")
            .addClass("symptoms__list-item")
            .data("value", "#{$(@).attr("value")}")
            .text($(@).text()))

    $(".owlbox").owlbox()

    $("[data-action='clone']").click ->
        {cloneSelector} = $(@).data()
        $cloneSource = $(cloneSelector)
        
        $cloneSource.find(".select2").select2 "destroy"

        $clone = $cloneSource.clone()
        $clone.insertAfter $cloneSource
        
        $clone.find("input:not([type='checkbox'], [type='radio']), select, textarea").val ""
        $clone.find(":checked").prop "checked", off
        $cloneSource.add($clone).find(".select2").trigger "reinitSelect2"
        
        off


    refreshChildrenAgesSelector = ->
        val = $("#field-personal-children-quantity").val()
        $("[data-for-children-count='one']").toggle val in ["one", "two", "three", "more"]
        $("[data-for-children-count='two']").toggle val in ["two", "three", "more"]
        $("[data-for-children-count='three']").toggle val in ["three", "more"]
        $("[data-for-children-count='more']").toggle val in ["more"]
    $("#field-personal-children-quantity").change refreshChildrenAgesSelector
    refreshChildrenAgesSelector() if $("#field-personal-children-quantity").length > 0


    $("body").on "click", "[data-doctor-request-set-time]", (e) ->
        time = parseInt $(e.target).attr("data-doctor-request-set-time")
        hours = Math.floor time / 60
        minutes = time % 60
        hours = "0#{hours}" if hours < 10
        minutes = "0#{minutes}" if minutes < 10
        time = "#{hours}:#{minutes}"
        # console.log time
        $("#doctor-request-time-select, .time-select").val(time).trigger "change"
    $("body").on "click", "[data-doctor-request-set-date]", (e) ->
        $("#doctor-request-date-input").pickadate("picker").set "select", parseInt $(e.target).attr("data-doctor-request-set-date")

    $("body").on
        "show.bs.modal": ->
            if scrollbarWidth > 0 and $("body").height() > $(window).height()
                $("html").css paddingRight: "#{scrollbarWidth}px"
        "hidden.bs.modal": ->
            $("html").css paddingRight: ""

    $("ul.nav li.active").each ->
        $pp = $(@).parent().parent()
        $pp.addClass "active" if $pp.is "li"

    window.openNotification = (title, content) ->
        $("#notification .modal-title").text title
        $("#notification .modal-body").html content
        $("#notification").modal("show")

    $(document).on "openNotification", (event, title, content) ->
        openNotification title, content

    $(document).on "focusin", ".has-error", (e) ->
        $el = if $(e.target).is ".has-error" then $(e.target) else $(e.target).closest ".has-error"
        $el.removeClass "has-error"

    $.fn.sameHeightHack = ->
        processChunk = (chunk) ->
            minHeight = Math.min ($(i).outerHeight() for i in chunk)...
            return if minHeight is 0
            maxHeight = Math.max ($(i).outerHeight() for i in chunk)...
            $(chunk).css height: "#{maxHeight}px"

        processSameHeightHack = ->
            @css height: ""
            lastTop = null
            chunk = null
            @each ->
                if lastTop isnt $(@).offset().top
                    processChunk chunk if chunk
                    lastTop = $(@).offset().top
                    chunk = [@]
                else
                    chunk.push @
            if chunk?.length > 0
                processChunk chunk
                chunk = null

        processSameHeightHack.call(@)

    shhack = ->
        $(".same-height").sameHeightHack()
    $ shhack
    $(document).on "shown.bs.modal", shhack
    $(document).on "shown.bs.tab", shhack
    $(window).resize shhack
    $(".registration input[type='radio']").on "change", shhack

    if location.hash and location.hash isnt "" and $(location.hash).hasClass "modal"
        $(location.hash).modal "show"

    addDot = ->
        $(".short-card__review-text, .post__title").dotdotdot
            ellipsis: ' ...'
    $(window).resize addDot

    $(document).on "click", "a[href^='#tab-doctors']", (e) ->
        $(window).scrollTo $("#tab-doctors"), 500, {offset: -100}

    $(document).on "click", ".scroll-to", (e) ->
        selector = $(e.currentTarget).attr('href') or $(e.currentTarget).data('href')
        if $(window).width() > 768
            yPos = $(selector).offset().top - $('.navbar-main').outerHeight(true)
        else
            yPos = $(selector).offset().top
        $('html,body').animate {scrollTop: yPos}, 400
        off

    $('body').scrollspy
        target: '.page-sidebar'
      
    formatResult = (item) ->
        if (!item.id)
            # return `text` for optgroup
            itemData = item.element[0].dataset
            r = "<div class='price-item'>"
            r += "<span class='price-item__title'>" + item.text + "</span>"
            if itemData.description then descr = "(" + itemData.description + ")" else descr = ''
            r += "&nbsp;<span class='price-item__description'>" + descr + "</span>"
            r += "<span class='price-item__aside'><span class='price-item__value'>" + itemData.price + "</span></span>" if itemData.price
            r += "</div>"
            return r
            
        # return option template
        itemData = item.element[0].dataset
        itemTitle = if itemData.label then itemData.label else item.text
        r = "<div class='price-item'>"
        r += "<span class='price-item__title'><span class='sr-only'>" + item.text + "</span>" + itemTitle + "</span>"
        if itemData.description then descr = "(" + itemData.description + ")" else descr = ''
        r += "&nbsp;<span class='price-item__description'>" + descr + "</span>"
        r += "<span class='price-item__aside'><span class='price-item__value'>" + itemData.price + "</span></span>" if itemData.price
        r += "<div class='price-item__action'><strong>Акция! </strong><a href=" + itemData.actionLink + ">" + itemData.actionTitle + "</a></div>" if itemData.actionTitle
        r += "</div>"
        return r

    formatSelection = (item) ->
        # return selection template
        itemData = item.element[0].dataset
        r = "<div class='price-item'>"
        r += "<div class='price-item__body'>"
        r += "<span class='price-item__title'>" + item.text + "</span>"
        if itemData.description then descr = "(" + itemData.description + ")" else descr = ''
        r += "&nbsp;<span class='price-item__description'>" + descr + "</span>"
        r += "</div>"
        r += "<span class='price-item__aside'><span class='price-item__value'>" + itemData.price + "</span></span>" if itemData.price
        r += "</div>"
        return r

    $selectCollapse = $('.select-prices')
    $selectCollapse.select2
        tags: $selectCollapse.data 'tags'
        formatResult: formatResult
        formatSelection: formatSelection
        dropdownCssClass: 'show-search select2-collapse'


    $selectCollapse.on "change", (e) ->
        $selectCollapseEl = $(e.target).data('select2')
        $selectCollapseEl.container.css 'max-width', $selectCollapseEl.container.closest('form').width()

    $selectCollapse.on "select2-open", (e) ->
        $selectCollapseEl = $(e.target).data('select2')
        $selectCollapseEl.container.css 'max-width', $selectCollapseEl.container.closest('form').width()
        $selectCollapseEl.onSelect = ((fn) ->
            (data, options) ->
                target = $(options.target) if options
                if target && target.is('a')
                    window.location.href = target.attr('href')
                else
                    return fn.apply(this, arguments)
        )($selectCollapseEl.onSelect)
        $dropdown = $($selectCollapseEl.dropdown[0])
        $dropdown.find('.select2-highlighted').parent().parent().addClass 'select2-collapse-open'
        $dropdown.find('.select2-result-with-children>.select2-result-label').each ->
            $(@).parent().addClass('select2-collapsed')
            $(@).click -> $(@).parent().toggleClass 'select2-collapse-open'