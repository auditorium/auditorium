# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->
	$('tbody tr').click ->
    window.location = $(this).find('a').attr('href')
	$('tbody tr').hover ->
    	$(this).toggleClass('hover')

  $('thead tr').click -> 
   	 false
  $('thead tr').hover ->
   	 false
	