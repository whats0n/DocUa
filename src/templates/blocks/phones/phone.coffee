phonesAutoChange =
  select: $('.navbar-main .phones .select7')
  options: ['mts', 'life', 'kyivstar', 'landline']
  checked: 0
  interval: 0
  init: () ->
    @listeners()
    @startSwitch()

  listeners: () ->
    $('body').on 'click', (e) ->
      clearInterval phonesAutoChange.interval
      phonesAutoChange.startSwitch()

    phonesAutoChange.select.find('.select7__current').click (e) ->
      e.stopPropagation()
      if !phonesAutoChange.select.hasClass('select7_open')
        startSwitch()
    $('body').on 'select7Opened', (e) ->
      clearInterval phonesAutoChange.interval

  startSwitch: () ->
    phonesAutoChange.interval = setInterval(phonesAutoChange.switchPhone, 500000)

  switchPhone: () ->
    phonesAutoChange.checked += 1
    if phonesAutoChange.checked >= phonesAutoChange.options.length
      phonesAutoChange.checked = 0
    phonesAutoChange.select.val(phonesAutoChange.options[phonesAutoChange.checked]).trigger 'change'

phonesAutoChange.init()