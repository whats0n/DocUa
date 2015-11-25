$ ->
  $(".price-block_collapse .price-block__header").on "click", ->
    $(@).closest(".price-block").toggleClass "price-block_collapse_open"