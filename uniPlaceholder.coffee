class UniPlaceholder
	constructor: (el) ->
		@$block = $(el)
		@initUniPlaceholder()

	initUniPlaceholder: ->
		@getPlaceholder()
		@$block.wrap "<div class='uni-placeholder'></div>"
		@$wraper = $(".uni-placeholder")
		$helperEl = $("<span class='uni-placeholder-helper'></span>")
		$helperEl.insertAfter @$block
		@$helper = $(".uni-placeholder-helper")
		@eventRouter()

	
	eventRouter: ->
		@$block.keypress @preventHandler.bind(@)
		@$block.on 'input', @inputHandler.bind(@)
		@$block.on 'keyup', @updateHelper.bind(@)
		@$helper.click @clickHandler.bind(@)

	clickHandler: ->
		@$block.focus()

	getPlaceholder: ->
		@placeholder = @$block.attr('placeholder').split(' ') or []

	inputHandler: (e)->
		@charCount = @$block.val().split('').length
		@wordCount = @$block.val().trim().split(" ").length 
		@inputedTextWidth = @$block.textWidth()

		if @charCount then @$helper.addClass 'in' else  @$helper.removeClass 'in'
		@$helper.css('left', @inputedTextWidth)

	preventHandler: (e)->
		key= e.keyCode
		wordCount = @$block.val().split(" ").length
		if 48 <= key <= 57 or (wordCount > @placeholder.length and key isnt 8 and key isnt 46 )
			e.preventDefault()

	updateHelper: ->
		@helperText = @placeholder.slice(@wordCount).join(" ")
		@$helper.text @helperText

		
$ ->
	$.fn.textWidth = (text, font) ->
		if (!$.fn.textWidth.fakeEl)
			$.fn.textWidth.fakeEl = $('<span>').css("white-space", "pre").hide().appendTo(document.body)
		$.fn.textWidth.fakeEl.text(text or this.val().edgeTrim() or this.text()).css('font', font or this.css('font'))
		return $.fn.textWidth.fakeEl.width()

	return unless $("[data-uni-placeholder]").length
	$("[data-uni-placeholder]").each (i, item) ->
		new UniPlaceholder item

String.prototype.edgeTrim = ->
	return this.replace(/(^\s+|\s+$)/g,'')
