# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery -> 
	
	# when page is loaded with hash
	if window.location.hash
		$('html,body').animate({scrollTop:$(window.location.hash).offset().top - 70}, 1000)
		$(window.location.hash).effect('highlight', {}, 2000)

	# when link with scroll class is clicked - scroll event is triggered
	$('.scroll').click (event) ->
		event.preventDefault()
		$('html,body').animate({scrollTop:$(this.hash).offset().top - 70}, 1000)

	$('#courses-tab a').click (e) ->
		e.preventDefault
		$(this).tab('show')
		
	$('#searchbar input').keyup -> 
		$.get($('#searchbar form').attr('action'), $('#searchbar form').serialize(), null, "script")
		return false
		
		
		