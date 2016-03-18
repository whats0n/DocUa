$(window).scroll ->
    if window.matchMedia('screen and (min-width: 768px)').matches
        if $(window).scrollTop() > 50 
          $('.navbar-fixed-top').addClass 'navbar-main_slide'
        else
          $('.navbar-fixed-top').removeClass 'navbar-main_slide'
        return
    return
    
if window.matchMedia('screen and (max-width: 767px)').matches
  $('.navbar-fixed-top').addClass 'navbar-main_slide'