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
      return false
  return 