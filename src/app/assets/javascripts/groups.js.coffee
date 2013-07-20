# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).foundation('joyride', 'start');

$('.choosable').on 'click', (event) ->
  event.preventDefault()
  selected_group = $(this)
  $('.choosable').removeClass('selected')
  selected_group.addClass('selected')
  console.log selected_group
  $.ajax 
    url: '/groups/change_group_type'
    data: { group_type: $(selected_group).data('id') }
    error: (jqXHR, textStatus, errorThrown) ->
      console.log errorThrown
    success: 
      $("html, body").animate({ scrollTop: $('#group-basic-information').offset().top }, 1000);