# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).foundation('joyride', 'start');

$('.choosable').on 'click', (event) ->
  selected_group = $(this)
  $('.choosable').removeClass('selected')
  selected_group.addClass('selected')

$('.input-fields input#question_subject').on 'focus', (e) ->
  $('#question_subject').attr('placeholder', i18n_question_subject_placeholder)
  $('#new-question-fields').slideDown()

$('.input-fields input#announcement_subject').on 'focus', (e) ->
  $('#announcement_subject').attr('placeholder', i18n_announcement_subject_placeholder)
  $('#new-announcement-fields').slideDown()

$('.input-fields input#topic_subject').on 'focus', (e) ->
  $('#topic_subject').attr('placeholder', i18n_topic_subject_placeholder)
  $('#new-topic-fields').slideDown()

$('.goto a').on 'click', (e) ->
  e.preventDefault()
  target = this.hash
  $target = $(target)
  $('html, body').stop().animate { scrollTop: $target.offset().top - 40 }, 900