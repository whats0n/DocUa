
  # $ ->

  #   transitionEndEventName = ->
  #     `var undefined`
  #     i = undefined
  #     undefined = undefined
  #     el = document.createElement('div')
  #     transitions = 
  #       'transition': 'transitionend'
  #       'OTransition': 'otransitionend'
  #       'MozTransition': 'transitionend'
  #       'WebkitTransition': 'webkitTransitionEnd'
  #     for i of transitions
  #       `i = i`
  #       if transitions.hasOwnProperty(i) and el.style[i] != undefined
  #         return transitions[i]
  #     return

  #   clearSelectTime = (callObj) ->
  #     callObj = callObj or false
  #     clearGroupLabel()
  #     $('input[type=checkbox][data-group-id]', '.modal-time').prop('checked', false).trigger 'change', callObj
  #     return

  #   clearGroupLabel = ->
  #     $('a[data-group]', timeSelect).removeClass 'active'
  #     return

  #   clearFreeTime = ->
  #     $('.free-time', '.modal-time').prop 'checked', false
  #     return

  #   recalcScrollPaneHeight = (el, scrollPane) ->
  #     `var scrollPane`
  #     scrollPane = scrollPane or el.closest('.dialog-window-content').data('jsp')
  #     footer = $('.dialog-footer', el.closest('#dialog-window'))
  #     footer.on transitionEndEvent, ->
  #       scrollPane.reinitialise()
  #       return
  #     return

  #   removeItem = ->
  #     $('.select-parents').each ->
  #       this_ = $(this)
  #       district = this_.find('.is-main-disrtict')
  #       parent = district.parents('.list-item')
  #       listItem = parent.next('dd').find('.list-item')
  #       if !parent.hasClass('selected')
  #         listItem.removeClass('selected').find('.remove-item').remove()
  #       return
  #     return

  #   'use strict'
  #   # Calendar setup
  #   calendarInput = $('#modal-calendar').pickadate()
  #   picker = calendarInput.pickadate('picker')
  #   transitionEndEvent = transitionEndEventName()
  #   picker.set 'min', new Date
  #   picker.on 'set', (set) ->
  #     console.log set
  #     return
  #   $('.picker__weekday').removeAttr 'title'
  #   # Time selected
  #   timeSelect = $('.modal-time')
  #   $('input[type=checkbox][data-group-id]', timeSelect).on 'change', (e, callObj) ->
  #     self = $(this)
  #     cell = self.closest('.modal-time-cell')
  #     nextCell = cell.next()
  #     prevCell = cell.prev()
  #     rowSize = if window.innerWidth <= 320 then 3 else 4
  #     maxRows = Math.ceil($('.modal-time-cell', cell.parent()).size() / rowSize)
  #     curCellIndex = cell.index()
  #     topCell = undefined
  #     bottomCell = undefined
  #     selectRow = Math.ceil(curCellIndex / rowSize)
  #     topCell = if curCellIndex + 1 <= rowSize then undefined else $('.modal-time-cell:nth(' + curCellIndex - ((selectRow - 1) * rowSize) + (selectRow - 2) * rowSize + ')')
  #     bottomCell = if selectRow < maxRows then $('.modal-time-cell:nth(' + curCellIndex - ((selectRow - 1) * rowSize) + selectRow * rowSize + ')') else undefined
  #     console.log curCellIndex - ((selectRow - 1) * rowSize) + (selectRow - 2) * rowSize, topCell, bottomCell
  #     if self.is(':checked')
  #       if ! !topCell and topCell.hasClass('checked')
  #         topCell.addClass 'has-bottom'
  #         cell.addClass 'has-top'
  #       if ! !bottomCell and bottomCell.hasClass('checked')
  #         bottomCell.addClass 'has-top'
  #         cell.addClass 'has-bottom'
  #       if ! !nextCell and nextCell.hasClass('checked')
  #         nextCell.addClass 'has-left'
  #         cell.addClass 'has-right'
  #       if ! !prevCell and prevCell.hasClass('checked')
  #         prevCell.addClass 'has-right'
  #         cell.addClass 'has-left'
  #       cell.addClass 'checked'
  #     else
  #       if ! !topCell and topCell.hasClass('checked')
  #         topCell.removeClass 'has-bottom'
  #         cell.removeClass 'has-top'
  #       if ! !bottomCell and bottomCell.hasClass('checked')
  #         bottomCell.removeClass 'has-top'
  #         cell.removeClass 'has-bottom'
  #       if ! !nextCell and nextCell.hasClass('checked')
  #         nextCell.removeClass 'has-left'
  #         cell.removeClass 'has-right'
  #       if ! !prevCell and prevCell.hasClass('checked')
  #         prevCell.removeClass 'has-right'
  #         cell.removeClass 'has-left'
  #       cell.removeClass 'checked'
  #     if !callObj
  #       clearGroupLabel()
  #       clearFreeTime()
  #     else
  #       if callObj.attributes['data-group']
  #         clearFreeTime()
  #       if /\bfree-time\\b/.test(callObj.className)
  #         clearGroupLabel()
  #     return
  #   $('a[data-group]', timeSelect).on 'click', (e) ->
  #     e.preventDefault()
  #     self = $(this)
  #     groupId = self.attr('data-group')
  #     conteiner = self.closest('.modal-time')
  #     allGroupLink = $('a[data-group]', conteiner)
  #     clearSelectTime this
  #     clearFreeTime()
  #     self.addClass 'active'
  #     $('input[type=checkbox][data-group-id]', conteiner).filter(->
  #       !@disabled and groupId == @attributes['data-group-id'].value
  #     ).prop('checked', true).trigger 'change', this
  #     return
  #   $('.free-time', timeSelect).on 'change', ->
  #     clearSelectTime this
  #     return
  #   # Scroll
  #   dialogScrollPane = $('.dialog-window-content').jScrollPane().data('jsp').reinitialise()
  #   leftContentScrollPane = $('.side-section-content').jScrollPane().data('jsp').reinitialise()
  #   # Dialog
  #   dialogWindow = $('#dialog-window')
  #   modalWindow = $('.modal')
  #   section = undefined
  #   $('.list-item', dialogWindow).on 'change', (e) ->
  #     self = $(this)
  #     self.closest('.list-item').trigger 'change-item', this
  #     return
  #   $('[data-dialog]').on 'click', ->
  #     $thiss = $('.list-item', dialogWindow)
  #     $this_ = $('.list-item1', dialogWindow)
  #     dialogWindow.addClass 'show-footer'
  #     recalcScrollPaneHeight $thiss, dialogScrollPane
  #     recalcScrollPaneHeight $this_, dialogScrollPane
  #     return
  #   $('.modal-left-side').on 'remove-item-el', '.list-item', (e) ->
  #     self = $(this)
  #     itemConteiner = self.parent()
  #     if $('.list-item', itemConteiner).length == 1
  #       itemConteiner.remove()
  #     return
  #   dialogWindow.on 'footer-toggle', (e, show) ->
  #     self = $(this)
  #     dialogScrollPane.reinitialise()
  #     return
  #   $('.dialog-close').on 'click', ->
  #     dialogWindow.trigger 'close-dialog'
  #     return
  #   # $('.js-close-window').on('click', function() {
  #   #   dialogWindow.trigger('close-dialog');
  #   # });
  #   dialogWindow.on 'close-dialog', ->
  #     self = $(this)
  #     self.removeClass 'open'
  #     $('.side-section-header', '.modal-dialog').removeClass 'open-dialog'
  #     return
  #   $('[data-dialog]').on 'click', ->
  #     self = $(this)
  #     currentSection = self.closest('.side-section')
  #     dialogCenter = Math.floor(dialogWindow.outerHeight() / 2)
  #     dialofOffset = dialogWindow.position()
  #     dialogHandlerPoint = $('.side-section-header', currentSection).position().top + 5
  #     modalHeight = $('.modal-dialog').outerHeight()
  #     dialofOffsetTop = 105
  #     lock = false
  #     section = undefined
  #     # Set dialog position
  #     if dialogHandlerPoint - dialogCenter > 105
  #       dialofOffsetTop = dialogHandlerPoint - dialogCenter
  #     if modalHeight - (dialogHandlerPoint + dialogCenter) < 10
  #       dialofOffsetTop = modalHeight - 10 - (dialogCenter * 2)

  #     showDialog = ->
  #       dialogWindow.css 'top', dialofOffsetTop
  #       dialogWindow.addClass 'open'
  #       $('.side-section-header', currentSection).addClass 'open-dialog'
  #       if $('.js-doctors').hasClass('open')
  #         $('.js-doctors').removeClass 'open'
  #         $('.js-doctor-text').removeClass 'open-dialog_doctor'
  #         $('.js-btn-open').removeClass 'btn-opacity'
  #       section = currentSection
  #       return

  #     if 'undefined' != typeof section
  #       dialogWindow.removeClass 'open'
  #       $('.side-section-header', '.modal-dialog').removeClass 'open-dialog'
  #     else
  #       showDialog()
  #     dialogWindow.on transitionEndEvent, (e) ->
  #       if !lock
  #         lock = true
  #         showDialog()
  #       return
  #     false
  #   $('[data-clear-select]', dialogWindow).on 'click', ->
  #     $('.remove-item', dialogWindow).trigger 'click'
  #     false
  #   $('[data-clear-select]', '.js-doctors').on 'click', ->
  #     $('.list-item', '.js-doctors').removeClass 'selected'
  #     false
  #   $('.modal-dialog').on 'append-content', '.side-section-content-inner', (e, content, list_class) ->
  #     content.removeClass 'selected'
  #     list_class = list_class or ''
  #     if content.is('li')
  #       content = $('<ul/>').addClass(list_class).append(content)
  #     $(this).html content.wrap('<ul/>')
  #     return
  #   $('.select-list').on 'change', 'input', ->
  #     self = $(this)
  #     inputId = self.attr('id')
  #     recalcScrollPaneHeight $('label[for="' + inputId + '"]')
  #     return
  #   $(document).on 'hide.bs.modal', '.modal', (e) ->
  #     self = $(this)
  #     modal = self.data('bs.modal')
  #     close = modal.closeDialog or false
  #     if close
  #       modal.closeDialog = undefined
  #       return
  #     if 'request-dialog' == $(e.target).attr('id')
  #       e.preventDefault()
  #       closeDialog = $('#close-dialog').clone()
  #       $('.modal-dialog', e.target).after closeDialog
  #       closeDialog.css 'opacity': 1
  #     return
  #   $(document).on('click', '.button.return', (e) ->
  #     e.preventDefault()
  #     $(this).closest('#close-dialog').css('opacity', 0).on transitionEndEvent, ->
  #       $(this).remove()
  #       return
  #     return
  #   ).on 'click', '.button.close-dialog', (e) ->
  #     e.preventDefault()
  #     self = $(this)
  #     modal = self.closest('.modal').data('bs.modal')
  #     modal['closeDialog'] = true
  #     modal.hide()
  #     modal.$element.on 'hidden.bs.modal', ->
  #       self.closest('#close-dialog').remove()
  #       return
  #     return
  #   # radio
  #   $('#radio1').click ->
  #     $this = $(this)
  #     $parents = $this.parents('.radio-item')
  #     $('.this-text1').addClass 'is-active_color'
  #     $('.radio-text_hide1').addClass 'is-active'
  #     return
  #   $('#radio2').click ->
  #     $('.this-text2').addClass 'is-active_color'
  #     $('.radio-text_hide2').addClass 'is-active'
  #     return
  #   $('#radio3').click ->
  #     $('.this-text3').addClass 'is-active_color'
  #     $('.radio-text_hide3').addClass 'is-active'
  #     return
  #   $('#radio4').click ->
  #     $('.this-text4').addClass 'is-active_color'
  #     $('.radio-text_hide4').addClass 'is-active'
  #     return
  #   # Media
  #   if window.matchMedia('screen and (max-width: 640px)').matches
  #     $('.js-btn-info').addClass 'js-btn-info__mobile'
  #     $('.js-btn-cal').addClass 'js-btn-cal__mobile'
  #     $('.js-btn-time').addClass 'js-btn-time__mobile'
  #   #tabs
  #   $('.js-btn-info__mobile, .tab-close').click ->
  #     $('.js-content-hide').slideToggle 'fast'
  #     $('.tab-close').toggleClass 'tab-active_info'
  #     #event.stopPropagation();
  #     false
  #   $('.js-btn-cal__mobile, .tab-close__calendar').click ->
  #     $('.modal-calendar').slideToggle 'fast'
  #     $('.tab-close__calendar').toggleClass 'tab-active_calendar'
  #     #event.stopPropagation();
  #     false
  #   $('.js-btn-time__mobile, .tab-close__time').click ->
  #     $('.modal-time').slideToggle 'fast'
  #     $('.tab-close__time').toggleClass 'tab-active_calendar'
  #     #event.stopPropagation();
  #     false
  #   #second window
  #   $('body').on 'click', '.js-close-item', ->
  #     $block = $('.js-doctors')
  #     data = $(this).data('name')
  #     $item = $block.find($('[data-name=\'' + data + '\']'))
  #     $itemParent = $item.parents('.list-item')
  #     $(this).remove()
  #     $itemParent.removeClass 'selected'
  #     return
  #   # open window-doctors
  #   $('.js-btn-open').on 'click', ->
  #     $this_ = $('.list-item', '.js-doctors')
  #     recalcScrollPaneHeight $this_, dialogScrollPane
  #     $('.js-doctors').addClass 'show-footer'
  #     $(this).addClass 'btn-opacity'
  #     $('.js-doctors').addClass 'open'
  #     $('.js-doctor-text').addClass 'open-dialog_doctor'
  #     if $('.js-district').hasClass('open')
  #       $('.js-district').removeClass 'open'
  #       $('.side-section-header').removeClass 'open-dialog'
  #     return
  #   $('.dialog-close').on 'click', ->
  #     $('.js-doctors').removeClass 'open'
  #     $('.js-doctor-text').removeClass 'open-dialog_doctor'
  #     $('.js-btn-open').removeClass 'btn-opacity'
  #     return
  #   #doctors
  #   $('.list-item label', '.select-specialization').on 'click', ->
  #     $this = $(this)
  #     $parent_ = $('.' + $this.parents('#dialog-window').data('block'))
  #     $text = $parent_.find('.side-section_item')
  #     $parent = $this.parents('.list-item')
  #     $parentChoose = $this.parents('.select-specialization')
  #     $($text).html ''
  #     $parentChoose.find('.list-item').removeClass 'selected'
  #     $('.list-item input').removeAttr 'checked'
  #     $parent.addClass 'selected'
  #     $this.clone().appendTo $text
  #     $('<a href="#" class="item-close"></a>').appendTo '.side-section_item label'
  #     $('.side-section_item label').addClass 'js-close-item'
  #     $('a.js-btn-text').text 'Измените специальность'
  #     if $parent.hasClass('selected')
  #       dialogWindow.removeClass 'open'
  #       $('.side-section-header').removeClass 'open-dialog'
  #       $('.js-doctors').removeClass 'open'
  #       $('.js-doctor-text').removeClass 'open-dialog_doctor'
  #       $('.js-btn-open').removeClass 'btn-opacity'
  #     return
  #   $('.section-doctors').on 'click', '.js-close-item', ->
  #     $('a.js-btn-text').text 'Выберете специальность'
  #     return
  #   #delete label
  #   $('body').on 'click', '.js-close-item', ->
  #     $block = $('#dialog-window')
  #     data = $(this).data('name')
  #     $item = $block.find($('[data-name=\'' + data + '\']'))
  #     $itemParent = $item.parents('.list-item')
  #     $(this).remove()
  #     $itemParent.removeClass('selected').find('.remove-item').remove()
  #     dialogWindow.find('.list-item').children().removeClass 'js-district-remove'
  #     removeItem()
  #     return
  #   #usluga_vibor
  #   $('.list-item label', '.select-diagnostic').on 'click', ->
  #     $this = $(this)
  #     $parent = $this.parents('.list-item')
  #     $parent.addClass 'selected'
  #     if $parent.hasClass('selected')
  #       $parent.append '<div class="remove-item"/>'
  #     return
  #   $('body').on 'click', '.remove-item', ->
  #     $this = $(this)
  #     $thisParent = $this.closest($('.list-item'))
  #     $thisParent.removeClass('selected').find('.remove-item').remove()
  #     return
  #   $('[data-clear-select]').on 'click', ->
  #     $this = $('.remove-item', dialogWindow)
  #     $itemParent = $this.parents('.list-item__diagnost')
  #     $Parent = $itemParent.parents('.list-item')
  #     $this.remove()
  #     $('.list-item').removeClass 'selected'
  #     return
  #   $('.js-btn-copy').on 'click', ->
  #     list = $('.list-item.selected label', '.select-diagnostic')
  #     $parent = $('.' + $(this).parents('.window-diagnostic').data('block'))
  #     text = $('.side-section_item')
  #     textJsp = $parent.find('.side-section_item .jspPane')
  #     if text.hasClass('is-height')
  #       textJsp.html ''
  #       $('<a href="#" class="item-close"></a>').appendTo list.clone().appendTo(textJsp)
  #       $('#dialog-window').removeClass 'open'
  #       $('.side-section-header').removeClass 'open-dialog'
  #     else
  #       text.html ''
  #       text.removeClass 'is-height'
  #       $('<a href="#" class="item-close"></a>').appendTo list.clone().appendTo('.side-section_item')
  #       $('#dialog-window').removeClass 'open'
  #       $('.side-section-header').removeClass 'open-dialog'
  #     if text.height() >= 150
  #       text.addClass 'is-height'
  #     if text.hasClass('is-height')
  #       textJsp.html ''
  #       $('<a href="#" class="item-close"></a>').appendTo list.clone().appendTo(textJsp)
  #       setTimeout (->
  #         settings = autoReinitialise: true
  #         pane = text
  #         pane.jScrollPane settings
  #         contentPane = pane.data('jsp').getContentPane()
  #         return
  #       ), 10
  #     $('.side-section_item label').addClass 'js-close-item'
  #     $('a.js-btn-text1').text 'Измените услугу'
  #     return
  #   #district
  #   $('.list-item label', '.js-district').on 'click', ->
  #     $this = $(this)
  #     $parent = $this.parents('.list-item')
  #     $parent.addClass 'selected'
  #     if $parent.hasClass('selected')
  #       $parent.append '<div class="remove-item"/>'
  #     return
  #   #disrticts select
  #   $('dt.list-item').on 'click', ->
  #     this_ = $(this)
  #     parents = this_.parents('.select-parents')
  #     list_ = parents.find('.list-item')
  #     item = $('.list-item').closest('.select-parents')
  #     this_.find('label').addClass 'is-main-disrtict'
  #     parents.find('.district-list').find('.list-item label').addClass 'js-district-remove'
  #     list_.addClass 'selected'
  #     list_.append '<div class="remove-item"/>'
  #     return
  #   $('body').on 'click', 'dt.list-item.selected', ->
  #     removeItem()
  #     return
  #   #copy disrtict
  #   $('.js-btn-copy__dictrict').on 'click', ->
  #     list = $('.list-item.selected label', '.js-district')
  #     $parent_ = $('.' + list.parents('.js-district').data('block'))
  #     text = $parent_.find('.side-section_item')
  #     parent = list.parents('.list-item')
  #     textJsp = $parent_.find('.side-section_item .jspPane')
  #     dtList = $('dt.list-item')
  #     if text.hasClass('is-height')
  #       textJsp.html ''
  #       $('<a href="#" class="item-close"></a>').appendTo list.clone().appendTo(textJsp)
  #       $('#dialog-window').removeClass 'open'
  #       $('.side-section-header').removeClass 'open-dialog'
  #     else
  #       text.html ''
  #       text.removeClass 'is-height'
  #       $('<a href="#" class="item-close"></a>').appendTo list.clone().appendTo(text)
  #       $('#dialog-window').removeClass 'open'
  #       $('.side-section-header').removeClass 'open-dialog'
  #     if text.height() >= 150
  #       text.addClass 'is-height'
  #     if text.hasClass('is-height')
  #       textJsp.html ''
  #       $('<a href="#" class="item-close"></a>').appendTo list.clone().appendTo(textJsp)
  #       setTimeout (->
  #         settings = autoReinitialise: true
  #         pane = text
  #         pane.jScrollPane settings
  #         contentPane = pane.data('jsp').getContentPane()
  #         return
  #       ), 10
  #     $('.side-section_item label').addClass 'js-close-item'
  #     $('a.js-btn-text__disrtict').text 'Измените район'
  #     if $('.is-main-disrtict').length
  #       text.find('.js-district-remove').remove()
  #     return
  #   $('.js-btn-clear').on 'click', ->
  #     thisis = $('.list-item', '.select-district')
  #     itemParent = thisis.parents('.select-district')
  #     thisis.removeClass('selected').find('.remove-item').remove()
  #     dialogWindow.find('.list-item').children().removeClass 'js-district-remove'
  #     return
  #   return
  # # close dialow window mobile
  # $('.js-close-window').on 'click', (e) ->
  #   e.preventDefault()
  #   self = $(this)
  #   modal = self.closest('.modal').data('bs.modal')
  #   modal['closeDialog'] = true
  #   modal.hide()
  #   modal.$element.on 'hidden.bs.modal', ->
  #     self.closest('#close-dialog').remove()
  #     return
  #   return
  # #scroll radio
  # $('#request-dialog').on 'show.bs.modal', (e) ->
  #   setTimeout (->
  #     settings = autoReinitialise: true
  #     pane = $('.section-form__inner').jScrollPane()
  #     pane.jScrollPane settings
  #     contentPane = pane.data('jsp').getContentPane()
  #     return
  #   ), 10
  #   return
  # return
