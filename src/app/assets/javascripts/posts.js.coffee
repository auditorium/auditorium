# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
	$('.comment-form').hide()
	
	$('.commenting').click ->
		post_id = $(this).attr('id')
		$('#comment-'+post_id+'-form').show()

	# when user chooses question only for moderator 
	$('a#private-post').click ->
		$('input#submit-button-label').val("Ask a moderator (private)")
		$('input#is-private').val('true')
		$('div.btn-group').removeClass('open')
		return false
	
	$('a#public-post').click ->
		$('input#submit-button-label').val("Ask a public question")
		$('input#is-private').val('false')
		$('div.btn-group').removeClass('open')
		return false
	
	# backward compatability for non-js user -.-
	$('#course_name').css('display', 'inline')
	$('#course_name').css('visibility', 'visible')
	$('#course_select').remove()
	$('#label_course_select').remove()

	$('#course_name').autocomplete
		source: "/ajax/courses"
		select: (event,ui) -> 
			$("#post_course_id").val(ui.item.id)