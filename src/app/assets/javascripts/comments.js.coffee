# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
  if window.location.hash.length > 0
    $target = $(window.location.hash) 
    $('html, body').stop().animate {
      scrollTop: $target.offset().top - 60
    }, 900, -> 
      $target.effect("highlight", {}, 1000)


  $('.hidden').hide()
  $('.comments a').on 'click', (e) ->
    e.preventDefault()
    $(this).hide()
    commentable_id = $(this).data('commentable_id')
    commentable_type = $(this).data('commentable_type')
    $(".comments form.#{commentable_id}.#{commentable_type}").show()