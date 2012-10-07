# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
	$('a#feedback').click ->
		$('#feedbackModal').css('display', 'block')
		$('#feedbackModal').modal('show')
		

	$('#hide-feedback-modal').click ->
		$('#feedbackModal').modal('hide')
	