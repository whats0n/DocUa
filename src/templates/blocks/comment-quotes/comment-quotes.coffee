$ ->
  $block = $(".comment-quotes")
  activeItemIndex = 0 

  setActiveElement = (el) ->
    $block.find(".comment-quotes__item.active").removeClass "active"
    $block.find(".comment-quotes__pane.active").removeClass "active"
    $(el).addClass "active"
    activeItemIndex = $(el).parent().index()
    $block.find(".comment-quotes__pane").eq(activeItemIndex).addClass "active"

  $(".comment-quotes__item").on "click", ->
    setActiveElement @

  $(".comment-quotes__header").owlCarousel
    navigation: on
    pagination: off
    navigationText:	["",""]
    rewindNav: off
    lazyLoad: off
    items: 5
    itemsDesktop: [1215,5]
    itemsTablet: [979,5]
    itemsMobile: [767, 2]
    afterAction: (el) ->
      owl = $(el).data "owlCarousel"
      if owl
        if activeItemIndex not in owl.owl.visibleItems
          activateIndex = if activeItemIndex < owl.owl.visibleItems[0]
            owl.owl.visibleItems[0]
          else
            owl.owl.visibleItems[owl.owl.visibleItems.length - 1]
            
          setActiveElement $block.find(".comment-quotes__item").eq(activateIndex).get()
