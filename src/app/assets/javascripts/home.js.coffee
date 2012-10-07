# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery -> 
	# when link with scroll class is clicked - scroll event is triggered
	$('.scroll').click (event) ->
		event.preventDefault()
		$('html,body').animate({scrollTop:$(this.hash).offset().top - 60}, 1000)

	$('#courses-tab a').click (e) ->
		e.preventDefault
		$(this).tab('show')

	$('.filter-box').hide()
	$('#filter').click -> 
		$('.filter-box').slideToggle()
		false

	$('#question_form').hide()
	$('a#show_question_form').click ->
		$('#question_form').slideDown()
		$('html,body').animate({scrollTop:$('#content').offset().top - 60}, 500)
		$('#show_question_form').hide()
		false

	$('#hide_question_form').click -> 
		$('#question_form').slideUp()
		$('html,body').animate({scrollTop:$('#content').offset().top - 60}, 500)
		$('#show_question_form').show()
		false

	$('span#language').hover ->
    $(this).tooltip('show')
		