$.loadForm = (form_type) ->
  $.ajax
    type: 'post'
    url: 'ajax/load_form'
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
  $($search_form).css({'width': '100%'})
  $($search_form).find('input').focus()

# $('a.hide-search').on 'click', (e) ->
#   e.preventDefault()
#   $('#search-form a.show-search').show()
#   $('#search-form form').hide()
#   $('#search-form').css({'width': '50px'})

$('#search-results').hide();
$('#query').on 'input', (e) ->
  query = $(this).val()
  if query.length == 0
    $('#search-results').slideUp('slow');
  else
    $.requestSearchResults(query) 

$('#alternative-search-results').hide();
$('#alternative-query').on 'submit', (e) ->
  $('#search-hint').hide()
  query = $(this).val()
  if query.length == 0
    $('#alternative-search-results').slideUp('slow');
  else
    $.requestSearchResults(query) 
      