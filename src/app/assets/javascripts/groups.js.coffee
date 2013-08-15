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
      $("html, body").stop().animate({ scrollTop: $('#group-basic-information').offset().top }, 1000);


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

$('#announcement_subject, #announcement_content').on 'input', (e) ->
  console.log 'changed'
  $.ajax 
    url: '/ajax/preview'
    type: 'POST'
    data: { 
      post_type: 'announcement'
      subject: $('#announcement_subject').val()
      content: $('#announcement_content').val()
    }
    error: (jqXHR, textStatus, errorThrown) ->
      console.log errorThrown
    success:
      console.log 'Update preview'
      


$('#question_subject, #question_content').on 'input', (e) ->
  console.log 'changed'
  $.ajax 
    url: '/ajax/preview'
    type: 'POST'
    data: { 
      post_type: 'question'
      subject: $('#question_subject').val()
      content: $('#question_content').val()
    }
    error: (jqXHR, textStatus, errorThrown) ->
      console.log errorThrown
    success: 
      console.log 'Update preview'

$('#topic_subject, #topic_content').on 'input', (e) ->
  console.log 'changed'
  $.ajax 
    url: '/ajax/preview'
    type: 'POST'
    data: { 
      post_type: 'topic'
      subject: $('#topic_subject').val()
      content: $('#topic_content').val()
    }
    error: (jqXHR, textStatus, errorThrown) ->
      console.log errorThrown
    success: 
      console.log 'Update preview'