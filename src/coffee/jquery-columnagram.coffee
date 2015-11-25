###
@name jquery-columnagram
@description Reinvent the columnizer.
@version 1.2.14
@author Se7enSky studio <info@se7ensky.com>
###

###! jquery-columnagram 1.2.14 http://github.com/Se7enSky/jquery-columnagram###

plugin = ($) ->

	"use strict"

	class Columnagram
		defaults:
			columns: 'auto'
			# balanceMethod: 'balanceCount'
			# balanceMethod: 'balanceHeight'
			balanceMethod: 'optimal'
			minWeightRepeats: 100
			minColumnWidth: off

		constructor: (@el, config) ->
			@$el = $ @el
			@config = $.extend {}, @defaults, config
			
			@columnized = no

			@columnize()

		destroy: ->
			@decolumnize()

		calculateWeights: (chunks, weights) ->
			i = 0
			for chunk in chunks
				chunkWeight = 0
				chunkWeight += weights[j] for j in [i..i+chunk.length-1]
				i += chunk.length
				chunkWeight or 0

		balanceItemsIntoChunksByCount: (items, chunkCount) ->
			result = []
			perChunk = Math.ceil items.length / chunkCount
			for chunkIndex in [0..chunkCount-1]
				result.push items.slice chunkIndex * perChunk, (chunkIndex + 1) * perChunk
			result

		balanceItemsIntoChunksByWeight: (items, weights, chunkCount) ->
			return items if chunkCount is 1
			chunks = @balanceItemsIntoChunksByCount items, chunkCount
			return chunks if items.length is chunkCount

			minWeight = 10000000
			minWeightRepeats = 0
			# t = 1
			while true
				# console.log t++, minWeightRepeats, minWeight
				chunkWeights = @calculateWeights chunks, weights
				# console.log chunkWeights
				maxWeight = Math.max chunkWeights...
				maxWeightChunkIndex = chunkWeights.indexOf maxWeight
				return chunks if maxWeightChunkIndex is -1 # ?
				if maxWeight < minWeight
					minWeight = maxWeight
					minWeightRepeats = 0
				else if maxWeight is minWeight
					minWeightRepeats++
					return chunks if minWeightRepeats is @config.minWeightRepeats

				if maxWeightChunkIndex is 0 # first
					chunks[maxWeightChunkIndex+1].unshift chunks[maxWeightChunkIndex].pop() if chunks[maxWeightChunkIndex].length > 1
				else if maxWeightChunkIndex is chunkWeights.length - 1 # last
					chunks[maxWeightChunkIndex-1].push chunks[maxWeightChunkIndex].shift() if chunks[maxWeightChunkIndex].length > 1
				else
					chunks[maxWeightChunkIndex+1].unshift chunks[maxWeightChunkIndex].pop() if chunks[maxWeightChunkIndex].length > 1 and Math.random() > 0.3
					chunks[maxWeightChunkIndex-1].push chunks[maxWeightChunkIndex].shift() if chunks[maxWeightChunkIndex].length > 1 and Math.random() > 0.3
			chunks

		balanceItemsIntoChunksOptimal: (items, weights, chunkCount) ->
			return items if chunkCount is 1
			chunks = @balanceItemsIntoChunksByWeight items, weights, chunkCount
			chunkWeights = @calculateWeights chunks, weights
			maxWeight = Math.max chunkWeights...
			chunks = []
			chunk = []
			chunkWeight = 0
			i = 0
			while items.length > 0
				if weights[i] + chunkWeight <= maxWeight
					chunk.push items.shift()
					chunkWeight += weights[i]
					i++
				else
					chunks.push chunk
					chunk = []
					chunkWeight = 0
			chunks.push chunk
			chunks

		columnize: ->
			cssHeight = (el) ->
				cssValue = (name) -> parseFloat $(el).css(name).replace("px", "")
				cssValue("height") + cssValue("margin-bottom") + cssValue("margin-top") + cssValue("border-top-width") + cssValue("border-bottom-width")

			return if @columnized
			return if (@config.balanceMethod in ["balanceHeight", "optimal"]) and @$el.innerHeight() is 0

			columnCount = @config.columns
			if @config.minColumnWidth
				columnCount -= 1 while columnCount > 1 and @$el.width() / columnCount < @config.minColumnWidth
			if @config.limitColumnCount
				columnCount = @config.limitColumnCount columnCount
			return if columnCount <= 1
			children = @$el.children().toArray()
			heightsAreSame = no
			heights = (cssHeight(child) for child in children)
			maxRepeats = 4
			repeats = 0

			until heightsAreSame
				repeats++

				chunks = switch @config.balanceMethod
					when "balanceHeight" then @balanceItemsIntoChunksByWeight children, heights, columnCount
					when "balanceCount" then @balanceItemsIntoChunksByCount children, columnCount
					when "optimal" then @balanceItemsIntoChunksOptimal children, heights, columnCount
				
				@$el.empty().append (for chunk in chunks
					$("<div>")
						.css
							float: "left"
							width: "#{Math.floor 100 / chunks.length}%"
						.append chunk
				)

				newHeights = (cssHeight(child) for child in @$el.find "> div > *")

				heightsAreSame = yes
				for i in [0..heights.length]
					if heights[i] isnt newHeights[i]
						heightsAreSame = no
						break

				break if repeats > maxRepeats

				unless heightsAreSame
					heights = newHeights
					# console.log "!heightsAreSame", heights
					children = @$el.find("> div > *").toArray()
					@$el.find("> div").remove()

			@$el.trigger "columnagram.columnized", 
				columns: chunks.length
			@columnized = yes

		decolumnize: ->
			return unless @columnized
			$children = @$el.find("> div").children()
			@$el.find("> div").remove()
			@$el.append $children
			@columnized = no

		recolumnize: ->
			@decolumnize()
			@columnize()

	$.fn.columnagram = (method, args...) ->
		@each ->
			columnagram = $(@).data 'columnagram'
			unless columnagram
				columnagram = new Columnagram @, if typeof method is 'object' then method else {}
				$(@).data 'columnagram', columnagram

			columnagram[method].apply columnagram, args if typeof method is 'string'

# UMD
if typeof define is 'function' and define.amd # AMD
	define(['jquery'], plugin)
else # browser globals
	plugin(jQuery)
