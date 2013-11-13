# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$.searchMembers = (group_id, query) ->
  $.ajax
    url: '/groups/search_members'
    type: 'post'
    data: { member_query: query, group_id: group_id }
    error: (jqXHR, textStatus, errorThrown) ->
      console.log errorThrown


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

$('#groups-grid').on 'click', 'a.flip-to-back', (e) ->
  e.preventDefault()
  group_id = $(this).data('id')
  console.log(group_id)
  $('.flip-container[data-id="'+group_id+'"]').addClass('flipped')

$('#groups-grid').on 'click','a.flip-to-front', (e) ->
  e.preventDefault()
  group_id = $(this).data('id')
  $('.flip-container[data-id="'+group_id+'"]').removeClass('flipped')

$('#member_query').on 'input', (e) ->
  member_query = $('#member_query').val()
  group_id = $('#group_id').val()
  $.searchMembers(group_id, member_query)

if $('#announcement_content').is(':visible')
  new Behave
    textarea: document.getElementById('announcement_content')
    tabSize: 2

if $('#question_content').is(':visible')
  new Behave
    textarea: document.getElementById('question_content')
    tabSize: 2

if $('#topic_content').is(':visible')
  new Behave
    textarea: document.getElementById('topic_content')
    tabSize: 2


if $('#answer_content').is(':visible')
  new Behave
    textarea: document.getElementById('answer_content')
    tabSize: 2


if $('#comment_content').is(':visible')
  new Behave
    textarea: document.getElementById('comment_content')
    tabSize: 2


if $('#recording_content').is(':visible')
  new Behave
    textarea: document.getElementById('recording_content')
    tabSize: 2




