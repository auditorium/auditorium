# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
	$('.lectures-table').hide()
	$('a.toggle-lectures').toggle -> 
			chair_id = $(this).data('id')
			$('#lectures-for-chair-'+chair_id+'-table').show()
			$(this).html('hide lectures <i class="icon-caret-up"></i>')
		, ->
			chair_id = $(this).data('id')
			$('#lectures-for-chair-'+chair_id+'-table').hide()	
			$(this).html('show lectures <i class="icon-caret-down"></i>')
		false