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
    success:
      $('#search-results').show()

$('a#new-announcement, a#new-topic, a#new-question').on 'click', (e) ->
  e.preventDefault()

  switch($(this).attr('id'))
    when 'new-announcement' then $.loadForm('new_announcement')
    when 'new-question' then $.loadForm('new_question')
    when 'new-topic' then $.loadForm('new_topic')


$('#query').on 'input', (e) ->
  query = $('#query').val()
  $.requestSearchResults(query) 
      