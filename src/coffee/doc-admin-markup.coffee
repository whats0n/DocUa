$.fn.initScheduleBlock = ->
	$(@).find(".owl").each ->
		data = $(@).data()
		opts =
			navigation: on
			pagination: off
			navigationText:	["",""]
			rewindNav: off
			lazyLoad: true
			itemsDesktop: off
			itemsDesktopSmall: off
			itemsTablet: off
			itemsTabletSmall: off
			itemsMobile: off

		if $(@).is '.owl_single'
			opts.singleItem = yes
		else
			opts.items = data.itemsCount or 7

		if $(@).is ".owl_schedule"
			opts.itemsTablet = [979,4]
			opts.itemsMobile = [767,2]
		if $(@).is ".gallery"
			opts.itemsTablet = [979,5]
			opts.itemsMobile = [767,2]

		$(@).owlCarousel opts 