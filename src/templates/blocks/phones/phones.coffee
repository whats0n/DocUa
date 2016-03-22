$(".phones__item_life").hover ->
  $(@).toggleClass("phones__item_hover")
  $(".phones__list").find(".phones__item_life").toggleClass("phones__item_hover")

$(".phones__item_mts").hover ->
  $(@).toggleClass("phones__item_hover")
  $(".phones__list").find(".phones__item_mts").toggleClass("phones__item_hover")

$(".phones__item_kyivstar").hover ->
  $(@).toggleClass("phones__item_hover")
  $(".phones__list").find(".phones__item_kyivstar").toggleClass("phones__item_hover")

$(".phones__item_civic").hover ->
  $(@).toggleClass("phones__item_hover")
  $(".phones__list").find(".phones__item_civic").toggleClass("phones__item_hover")

$ ->
  $(".js-phones-btn").click ->
    _this = $(@)
    _parent = _this.parents(".js-phones")

    if _parent.find(".js-phones-list").hasClass("phones__list_block")
      return true
    else 
      _this.addClass("phones__toggle_open")
      _parent.find(".js-phones-list").addClass("phones__list_block")
      false

  $(document).on "click", ->
    $(".js-phones-list").removeClass "phones__list_block"  
    $(".js-phones-btn").removeClass "phones__toggle_open"  



# phonesAutoChange =
#   select: $('.navbar-main .phones .select7')
#   options: ['mts', 'life', 'kyivstar', 'landline']
#   checked: 0
#   interval: 0
#   init: () ->
#     @listeners()
#     @startSwitch()

#   listeners: () ->
#     $('body').on 'click', (e) ->
#       clearInterval phonesAutoChange.interval
#       phonesAutoChange.startSwitch()

#     phonesAutoChange.select.find('.select7__current').click (e) ->
#       e.stopPropagation()
#       if !phonesAutoChange.select.hasClass('select7_open')
#         startSwitch()
#     $('body').on 'select7Opened', (e) ->
#       clearInterval phonesAutoChange.interval

#   startSwitch: () ->
#     phonesAutoChange.interval = setInterval(phonesAutoChange.switchPhone, 500000)

#   switchPhone: () ->
#     phonesAutoChange.checked += 1
#     if phonesAutoChange.checked >= phonesAutoChange.options.length
#       phonesAutoChange.checked = 0
#     phonesAutoChange.select.val(phonesAutoChange.options[phonesAutoChange.checked]).trigger 'change'

# phonesAutoChange.init()