# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
	$('a#feedback').click ->
		$('#feedbackModal').modal('show')
		$('#feedbackModal').css('visiblity', 'visible')

	$('#hide-feedback-modal').click ->
		$('#feedbackModal').modal('hide')
	