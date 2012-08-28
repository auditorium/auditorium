# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
	$('.comment-form').hide()
	
	$('.commenting').click ->
		post_id = $(this).attr('id')
		$('#comment-'+post_id+'-form').show()