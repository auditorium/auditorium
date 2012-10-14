# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
jQuery ->


	$('div.expandable').expander
    slicePoint:       80,  # default is 100
    expandText:       '[read more]', # default is 'read more...'
    userCollapseText: '[less]'  # default is '[collapse expanded text]'
	