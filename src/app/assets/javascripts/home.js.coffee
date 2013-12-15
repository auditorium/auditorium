$.saveTutorialProgress = () ->
  tutorial_name = $('input[name="guide"]').val()
  $.ajax
    type: 'post'
    url: '/ajax/save_tutorial_progress'
    data: { tutorial_name: tutorial_name }
    error: (jqXHR, textStatus, errorThrown) ->
      console.log errorThrown

$.loadForm = (form_type) ->
  $.ajax
    type: 'post'
    url: '/ajax/load_post_form'
    data: { form_type: form_type }
    error: (jqXHR, textStatus, errorThrown) ->
      console.log errorThrown
    success:
      $('#post-form').slideDown()

$.requestSearchResults = (query) ->
  $.ajax
    url: '/ajax/search'
    type: 'get'
    data: { query: query }
    error: (jqXHR, textStatus, errorThrown) ->
      console.log errorThrown

$('a#new-announcement, a#new-topic, a#new-question').on 'click', (e) ->
  e.preventDefault()
  switch($(this).attr('id'))
    when 'new-announcement' then $.loadForm('new_announcement')
    when 'new-question' then $.loadForm('new_question')
    when 'new-topic' then $.loadForm('new_topic')


$('a.show-search').on 'click', (e) ->
  e.preventDefault()
  $(this).hide()
  $search_form = $('#search-form')
  $($search_form).find('form').show()
  $($search_form).css({'width': '100%', 'height': '50px', 'background-color': '#494949'})
  $($search_form).find('input').css({'background-color': '#494949'})
  $($search_form).find('input').focus()

$('#search-results').hide();
$('#query').on 'input', (e) ->
  query = $(this).val()
  if query.length == 0
    $('#search-results').slideUp('slow');
  else
    $.requestSearchResults(query) 

$('section[role="main"]').on 'click', (e) ->
  if $('#search-results').is(':visible')
    $('#search-results').slideUp 'slow', ->
      $search_form = $('#search-form')
      $($search_form).find('form').hide()
      $($search_form).find('input[type="text"]').val("")
      $($search_form).css({'width': '50px', 'background-color': '#c04735'})
      $('a.show-search').show()


$('#alternative-search-results').hide();
$('#alternative-query').on 'submit', (e) ->
  $('#search-hint').hide()
  query = $(this).val()
  if query.length == 0
    $('#alternative-search-results').slideUp('slow');
  else
    $.requestSearchResults(query) 

$('a[data-id="show_login_form"]').on 'click', (e) ->
  e.preventDefault()
  $('#sign-in-form').show()
      