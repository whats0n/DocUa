
if $(window).width() < 768
  $('.navbar-fixed-top').removeClass 'navbar-main_none'
else
  $(window).scroll ->
    if $(window).scrollTop() > 150
      $('.navbar-fixed-top').removeClass 'navbar-main_none'
    else
      $('.navbar-fixed-top').addClass 'navbar-main_none'
    return