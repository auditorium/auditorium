# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  # tooltips 	
  $('#previous-course').mouseenter ->
  	$('#previous-course').tooltip('show')
  $('#next-course').mouseenter ->
  	$('#next-course').tooltip('show')
  $('#maintain-course').mouseenter ->
  	$('#maintain-course').tooltip('show')
  $('#follow-button-membership-type').mouseenter ->
  	$('#follow-button-membership-type').tooltip('show')

  $('#saved-changes').hide()
  $('input#save-changes').attr("disabled", "disabled")

  # follow button tooltips
  $('.follow-button').hover -> 
    $(this).tooltip('show')
  $('.follow-button').click -> 
    $(this).tooltip('hide')

  $('input#save-changes').click -> 
    $('#saved-changes').show()
    $('#saved-changes').html('loading...')

  # backward compatability for non-js user -.-
  $('#lecture_name').css('display', 'inline')
  $('#lecture_name').css('visibility', 'visible')
  $('#lecture_select').remove()
  $('#label_lecture_select').remove()

  $('#lecture_name').autocomplete
    source: "/ajax/lectures"
    select: (event,ui) ->
      $("#course_lecture_id").val(ui.item.id)



	
