$('.js-nav a').on 'click', ->
  section = $(this).attr('href')
  $('html, body').animate { scrollTop: $(section).offset().top - 35 }, 500
  false 
    