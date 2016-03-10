$ ->
  $('.js-search-btn').click ->
    if $('.js-form').hasClass('is-search-open')
        return true
    else 
        $('.js-form').addClass 'is-search-open'
        false


  $(document).on "click", ->
    $(".js-form").removeClass "is-search-open"  

  $('.js-form').on "click", (e) ->
    e.stopPropagation()  
