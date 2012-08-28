# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery -> 
	$('#courses-tab a').click (e) ->
		e.preventDefault
		$(this).tab('show')
		
	$('#searchbar input').keyup -> 
		$.get($('#searchbar form').attr('action'), $('#searchbar form').serialize(), null, "script")
		return false
		
		
		