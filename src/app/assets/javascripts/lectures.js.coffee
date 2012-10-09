# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery -> 
	# backward compatability for non-js user -.-
  $('#chair_name').css('display', 'inline')
  $('#chair_name').css('visibility', 'visible')
  $('#chair_select').remove()
  $('#label_chair_select').remove()

  $('#chair_name').autocomplete
    source: "/ajax/chairs"
    select: (event,ui) ->
      $("#lecture_chair_id").val(ui.item.id)