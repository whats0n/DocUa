# date-picker

$ ->
  $('.js-datepicker').daterangepicker
    autoUpdateInput: true,
    alwaysShowCalendars: true,
    # autoUpdateInput: true,
    startDate: moment(),
    opens: "left",
    applyClass: "apply-btn"
    cancelClass: "cancel-btn"
    ranges:
      'Последние :': [
      ]
      '7 дней': [
        moment()
        moment().add(6, 'days')
      ]
      '14 дней': [
        moment()
        moment().add(13, 'days')
      ]
      '30 дней': [
        moment()
        moment().add(29, 'days') 
      ]
    locale:
      format: 'YYYY.MM.DD',
      separator: ' - ',
      applyLabel: 'Подтвердить',
      cancelLabel: 'Отменить',
      daysOfWeek: [
        'ВC'
        'ПН'
        'ВТ'
        'СР'
        'ЧТ'
        'ПТ'
        'СБ'
      ]
      monthNames: [
        'Январь'
        'Февраль'
        'Март'
        'Апрель'
        'Май'
        'Июнь'
        'Июль'
        'Август'
        'Сентябрь'
        'Октябрь'
        'Ноябрь'
        'Декабрь'
      ]
      firstDay: 1




      # $('.ranges li').on 'click', ->
  #   parent = $('.ranges li').parents('.daterangepicker')
  #   # alert()
  #   # setTimeout ->
  #   #   parent.addClass 'open'
  #   #   , 1000
  #   $('.ranges li').removeClass 'active'
  
  #   if !$('.ranges li').hasClass 'active'
  #     $(@).addClass "active"
  #   else
  #     $('.ranges li').removeClass 'active'