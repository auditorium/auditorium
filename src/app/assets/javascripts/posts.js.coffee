# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
	post_hash = window.location.hash
	$(post_hash).effect('highlight', {}, 1500)
	false

	$('.comment-form').hide()
	
	$('.commenting').click ->
		post_id = $(this).attr('id')
		$(this).hide()
		$('#comment-'+post_id+'-form').show()

	# backward compatability for non-js user -.-
	$('#course_name').css('display', 'inline')
	$('#course_name').css('visibility', 'visible')
	$('#course_select').remove()
	$('#label_course_select').remove()

	$('#course_name').autocomplete
		source: "/ajax/courses"
		select: (event,ui) -> 
			$("#post_course_id").val(ui.item.id)

	$('.hint.hidden-post a').click ->
		data_id = $(this).data('id')
		$('.table-posts.hidden.post-'+data_id).show().effect('highlight', {}, 1200)
		$('.table-posts.hidden.post-'+data_id).removeClass('hidden')
		$('p.hint.post-'+data_id).hide()
		return false
	
	$('.table-posts.hidden').hide()
	
	$('.modal').hide()
	$('a.submit-report').click ->
		data_id = $(this).data('id')
		$('input#report_post_id').val(data_id)
		$('.modal').show()
		$('#reportModal').css('visibility', 'visible')
		return false

	$('a.closeButton').click -> 
		$('.modal').hide()
		$('#reportModal').css('visibility', 'hidden')
		return false

	$('a#insert-code-block').click -> 
		text_area = $('textarea#content_field')
		text_area.append('\n```ruby\nput code here\n```')
		return false

	$('a#insert-inline-code').click -> 
		text_area = $('textarea#content_field')
		text_area.append(' `put code here`')
		return false

	$('a#insert-quote').click -> 
		text_area = $('textarea#content_field')
		text_area.append('\n\n> your quote...')
		return false

	$('.permalink').click -> 
		post_id = $(this).data('id')
		alert 'Copy this link to share:\n' + $('a#post-'+post_id).attr("href")
		return false

	$()