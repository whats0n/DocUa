###
@name jquery-owlbox
@description Lightbox-like gallery for galleries, based on owlCarousel and Bootstrap 3 modals.
@version 1.0.0
@author Se7enSky studio <info@se7ensky.com>
@dependencies
 - [owlCarousel](http://owlgraphic.com/owlcarousel/)
 - [Bootstrap 3 modals](http://getbootstrap.com/javascript/#modals)
###
###! jquery-owlbox 1.0.0 http://github.com/Se7enSky/jquery-owlbox###

plugin = ($) ->
	
	"use strict"
	
	$.fn.owlbox = ->
		@each ->
			$(@).click (e) ->
				e.preventDefault()
				group = $(@).attr "rel"
				$items = if group then $("a[rel='#{group}'][href]") else $(@)
				currentIndex = $items.index(@)
				items = (for item in $items
					$img = $(item).find("img")
					thumb: $(item).attr("data-thumb-src") or $img.attr("src") or $img.attr("data-src")
					big: $(item).attr("href")
					title: $(item).attr("title")
				)
				$popup = $ """
					<div aria-hidden=\"true\" role=\"dialog\" class=\"gallery-popup sdfgdsf modal fade\" data-keyboard=\"true\" tabindex=\"-1\">\n 
						\n <div class=\"modal-dialog\">\n
							 \n <div class=\"modal-content\">\n 
							 	\n <div class=\"modal-header\">\n 
							 		\n <button aria-hidden=\"true\" data-dismiss=\"modal\" type=\"button\" class=\"close close-special\"></button>\n \n <div class=\"modal-title\">Галерея</div></div>\n <div class=\"modal-body\">\n <div class=\"photo-gallery\"></div>\n
							 	\n </div>\n
							 \n </div>\n 
						\n </div>\n
					\n</div>
				"""
					

					

				keysHandler = (e) ->
					switch e.which
						when 37 # left
							$popup.find(".photo-gallery").trigger "photoGallery.prev"
							e.preventDefault()
						when 39 # right
							$popup.find(".photo-gallery").trigger "photoGallery.next"
							e.preventDefault()

				$("section.modals").append $popup
				$popup.on "hidden.bs.modal", ->
					$popup.remove()
					$("body").off "keydown", keysHandler
				$popup.on "owl.afterInit", (e, owl) ->
					owl.goTo currentIndex
				$popup.on "shown.bs.modal", ->
					$popup.find(".photo-gallery").makeCustomPhotoGallery
						items: items
				$popup.modal "show"
				$("body").on "keydown", keysHandler

# UMD 
if typeof define is 'function' and define.amd then define(['jquery'], plugin) else plugin(jQuery)
