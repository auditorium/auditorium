# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('#new_announcement_form').hide()
  $('#new_question_form').hide()


  $('#new_question').click ->
    $('#new_question_form').show()


  $('#new_announcement').click ->
    $('#new_announcement_form').show()


  $('#hide-question-form').click ->
    $('#new_question_form').hide()

  $('#hide-announcement-form').click ->
    $('#new_announcement_form').hide()

  # edit course button
  $('#edit_course_button').click ->
    alert("hallo")
    return false

	# collapse course view
	$('a.collapse-course').click ->
		link = $(this)
		course_id = $(this).data('id')
		course_body = $('tbody#course-'+course_id)
		console.log link
		if course_body.is(':hidden') == true
  		course_body.show("slow")
  		link.html('hide details')
		else if course_body.is(':hidden') == false
  		course_body.hide("slow")
  		link.html('details')
		false
	$('tbody.courses-body').hide()

	
# tooltips 	
$('#previous-course').mouseenter ->
	$('#previous-course').tooltip('show')
$('#next-course').mouseenter ->
	$('#next-course').tooltip('show')
$('#maintain-course').mouseenter ->
	$('#maintain-course').tooltip('show')
$('#follow-button-membership-type').mouseenter ->
	$('#follow-button-membership-type').tooltip('show')
	
