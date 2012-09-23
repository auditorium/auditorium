# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  # collapse course view
  #$('a.collapse-course').click ->
  #  link = $(this)
  #  course_id = $(this).data('id')
  #  course_body = $('tbody#course-'+course_id)
  #  console.log link
  #  if course_body.is(':hidden') == true
  #    course_body.show("slow")
  #    link.html('hide details')
  #  else if course_body.is(':hidden') == false
  #    course_body.hide("slow")
  #    link.html('details')
  #  false
  #$('tbody.courses-body').hide()
	
  # tooltips 	
  $('#previous-course').mouseenter ->
  	$('#previous-course').tooltip('show')
  $('#next-course').mouseenter ->
  	$('#next-course').tooltip('show')
  $('#maintain-course').mouseenter ->
  	$('#maintain-course').tooltip('show')
  $('#follow-button-membership-type').mouseenter ->
  	$('#follow-button-membership-type').tooltip('show')

  # backward compatability for non-js user -.-
  $('#lecture_name').css('display', 'inline')
  $('#lecture_name').css('visibility', 'visible')
  $('#lecture_select').remove()
  $('#label_lecture_select').remove()

  $('#lecture_name').autocomplete
    source: "/ajax/lectures"
    select: (event,ui) ->
      $("#course_lecture_id").val(ui.item.id)



	
