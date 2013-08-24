$.loadAnnouncementForm = ->
  alert('Announcement')

$.loadQuestionForm = ->
  alert('Question')

$.loadTopicForm = ->
  alert('Topic')

# $.loadFilterForm = ->
#   $.ajax 
#     url: 'ajax/posts_filter'
#     type: 'POST'
#     error: (jqXHR, textStatus, errorThrown) ->
#       console.log errorThrown
#     success: 
#       $('#post-form').slideDown()

$('a#new-announcement, a#new-topic, a#new-question, a#filter-posts').on 'click', (e) ->
  e.preventDefault()

  switch($(this).attr('id'))
    when 'new-announcement' then $.loadAnnouncementForm()
    when 'new-question' then $.loadQuestionForm()
    when 'new-topic' then $.loadTopicForm()
    when 'filter-posts' 
      if $(this).hasClass('show-form')
        $(this).removeClass('show-form').addClass('hide-form')
        $('#post-form').slideDown()
      else
        $(this).removeClass('hide-form').addClass('show-form')
        $('#post-form').slideUp()
      