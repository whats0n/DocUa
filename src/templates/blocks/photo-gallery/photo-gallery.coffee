galleryCount = 1

generateMarkupForOwlCarousel = (items, opts) ->
	html = ""

	generateImg = (src) ->
		unless opts.simpleThumbs
			"""<img data-src="#{src}" alt="" class="lazyOwl"/>"""
		else
			"""<img src="#{src}" alt=""/>"""

	unless opts.owlbox
		html += """
			<ul class="photo-gallery__images">"""
		html += """
				<li class="photo-gallery__image item">
					#{generateImg item.big}
					#{if item.title then '<div class="photo-gallery__image-caption">' + item.title + '</div>' else ''}
				</li>""" for item in items
		html += """
			</ul>"""
		html += """
			<ul class="photo-gallery__thumbs">"""
		html += """
				<li class="photo-gallery__thumb item">
					#{generateImg item.thumb}
				</li>""" for item in items
		html += """
			</ul>"""
	else
		html += """
			<ul class="photo-gallery__thumbs">"""
		html += """
				<li class="photo-gallery__thumb item">
					<a href="#{item.big}" class="owlbox" rel="gallery-#{galleryCount}" #{if item.title then 'title="' + item.title + '"' else ''}>
						#{generateImg item.thumb}
					</a>
				</li>""" for item in items
		html += """
			</ul>"""

	unless opts.owlbox
		html += """
			<div class="photo-gallery__counter">
				<span class="photo-gallery__counter-current">1</span> из <span class="photo-gallery__counter-total">#{items.length}</span>
			</div>
		"""
	html

syncOwlCarousels = (sync1, sync2) ->
	center = (number) ->
		return unless sync2.data("owlCarousel")
		sync2visible = sync2.data("owlCarousel").visibleItems
		return unless sync2visible
		num = number
		found = false
		for i of sync2visible
			found = true  if num is sync2visible[i]
		if found is false
			if num > sync2visible[sync2visible.length - 1]
				sync2.trigger "owl.goTo", num - sync2visible.length + 2
			else
				num = 0  if num - 1 is -1
				sync2.trigger "owl.goTo", num
		else if num is sync2visible[sync2visible.length - 1]
			sync2.trigger "owl.goTo", sync2visible[1]
		else sync2.trigger "owl.goTo", num - 1  if num is sync2visible[0]

	sync1.on "owl.afterAction", (e, owl) ->
		current = owl.currentItem
		sync2.find(".photo-gallery__thumb_current").removeClass "photo-gallery__thumb_current"
		sync2.find(".photo-gallery__thumb").eq(current).addClass "photo-gallery__thumb_current"
		center current

	sync2.on "click", ".owl-item", (e) ->
		e.preventDefault()
		sync1.trigger "owl.goTo", $(@).data("owlItem")

initOwlCarousel = (container, items, opts) ->
	$(container).prepend generateMarkupForOwlCarousel items, opts
	$thumbs = $(container).find ".photo-gallery__thumbs"
	unless opts.owlbox
		$images = $(container).find ".photo-gallery__images"
		syncOwlCarousels $images, $thumbs
		$images.owlCarousel
			singleItem: yes
			lazyLoad: yes
			pagination: no
			navigation: on # next and prev arrows
			navigationText:	["",""]
			slideSpeed: 394
			afterAction: (el) ->
				$(el).trigger "owl.afterAction", @
				$(container).find(".photo-gallery__counter-current").text @currentItem + 1
			afterInit: (el) -> $(el).trigger "owl.afterInit", @
	unless opts.simpleThumbs
		$thumbs.owlCarousel
			items: 4
			itemsTablet: [979,6]
			itemsMobile: [767,2]
			lazyLoad: yes
			pagination: no
			navigation: on # next and prev arrows
			navigationText:	["",""]
			slideSpeed: 394
			afterAction: (el) -> $(el).trigger "owl.afterAction", @
			afterInit: (el) -> $(el).trigger "owl.afterInit", @

$.fn.makeCustomPhotoGallery = (_opts = {}) ->
	@each ->
		opts = $.extend {}, _opts
		items = opts.items
		unless items
			$items = $(@).find "ul a[href]"
			items = (for item in $items
				$img = $(item).find("img")
				thumb: $(item).attr("data-src") or $img.attr("src")
				big: $(item).attr("href")
				title: $(item).attr("title")
			)
			$(@).find("ul").remove()

		unless opts.owlbox
			opts.owlbox = $(@).hasClass "photo-gallery_owlbox"
		unless opts.simpleThumbs
			opts.simpleThumbs = $(@).hasClass "photo-gallery_simple-thumbs"
		initOwlCarousel @, items, opts
		$(@).on
			"photoGallery.next": =>
				$(@).find(".photo-gallery__images").trigger "owl.next"
			"photoGallery.prev": =>
				$(@).find(".photo-gallery__images").trigger "owl.prev"

		$(@).addClass "photo-gallery_initialized"

		galleryCount++

$ ->
	$(".photo-gallery").makeCustomPhotoGallery()