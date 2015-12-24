$(document).ready ->
  $('.js-tab-container').each ->
    $(this).find('.js-tab-link').first().addClass 'active'
    $(this).find('.js-tab-block').first().addClass 'active'
    $('.js-tab-link').on 'click', ->
      id = $(this).data('id')
      $('.js-tab-link').removeClass 'active'
      $('.js-tab-block').removeClass 'active'
      $('.js-tab-block[data-block="' + id + '"]').addClass 'active'
      $(this).addClass 'active'
      if $(window).width() < 768
        $('html, body').animate { scrollTop: $('.js-scrollto').offset().top }, 1000
      return false
  return 