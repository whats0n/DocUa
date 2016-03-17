$ ->
  $('.js-search-btn').click ->
    if $('.js-form').hasClass('is-search-open')
        return true
    else 
        $('.js-form').addClass 'is-search-open'
        false

  $('.js-search-input').focus ->
    if $('.js-form').hasClass('is-search-active')
        return true
    else 
        $('.js-form').addClass 'is-search-active'
        false

  $(document).on "click", ->
    $(".js-form").removeClass "is-search-active"  

  $(document).on "click", ->
    $(".js-form").removeClass "is-search-open"  

  $('.js-form').on "click", (e) ->
    e.stopPropagation()  
