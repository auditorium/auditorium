# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->

	# get caret position in text area
	insertAtCaret = (element,value) ->
		@element=document.getElementById(element)
		if(document.selection)
			@element.focus()
			sel=document.selection.createRange()
			sel.text=value
			return
		
		if(@element.selectionStart||@element.selectionStart=="0")
			@t_start=@element.selectionStart
			@t_end=@element.selectionEnd
			@val_start=@element.value.substring(0, @t_start)
			@val_end=@element.value.substring(@t_end,@element.value.length)
			@element.value=@val_start+value+@val_end
		else
			@element.value+=value



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
		$('#reportModal').show()
		$('#reportModal').css('visibility', 'visible')
		return false

	$('a.closeButton').click -> 
		$('.modal').hide()
		$('#reportModal').css('visibility', 'hidden')
		return false

	$('a#insert-inline-code').click ->
		insertAtCaret('content_field', '`# add your code`')
		return false

	$('a#insert-code-block').click ->
		insertAtCaret('content_field', '\n```ruby\n# add your code\n```')
		return false

	$('a#insert-quote').click ->
		insertAtCaret('content_field', '\n\n> content\n\n')
		return false

	$('a#insert-latex-inline').click ->
		insertAtCaret('content_field', '$%LaTeX code here!$')
		return false

	$('a#insert-latex-block').click ->
		insertAtCaret('content_field', '\n$$%LaTeX code here!$$\n')
		return false

	$('a.general-question').click ->
		$('#course_name').val('Allgemeine und organisatorische Angelegenheiten').focus()
		$('#course_name').autocomplete('search', $('#course_name').val())
		return false

	$('.permalink').click -> 
		post_id = $(this).data('id')
		$('html,body').animate({scrollTop:$('#post-'+post_id).offset().top - 70}, 500)
		$('#post-'+post_id).effect('highlight', {}, 1000)

	$('.private-question').hover ->
		$(this).tooltip('show')
