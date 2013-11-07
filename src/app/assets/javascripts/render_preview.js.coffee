$.renderPreview = (id) ->
  $.ajax 
    url: '/ajax/preview'
    type: 'POST'
    data: { 
      post_type: id
      subject: if id == 'group' then $('#'+id+'_title').val() else $('#'+id+'_subject').val()
      content: if id == 'group' then $('#'+id+'_description').val() else $('#'+id+'_content').val()
    }
    error: (jqXHR, textStatus, errorThrown) ->
      console.log errorThrown

# Preview post content
$('a.toggle-preview').on 'click', (e) ->
  e.preventDefault()
  data_id = $(this).data('id')
  
  if $(this).text() == i18n_hide_preview
    $('#'+data_id+'-preview').fadeOut()
    $(this).text(i18n_show_preview)
  else
    $.renderPreview(data_id)
    $('#'+data_id+'-preview').fadeIn()
    $(this).text(i18n_hide_preview)

$('#announcement_subject, #announcement_content').on 'input', (e) ->
  $.renderPreview('announcement') if $('#announcement-preview').is(":visible")
      
$('#question_subject, #question_content').on 'input', (e) ->
  $.renderPreview('question') if $('#question-preview').is(":visible")

$('#topic_subject, #topic_content').on 'input', (e) ->
  $.renderPreview('topic') if $('#topic-preview').is(":visible")

$('#answer_content').on 'input', (e) ->
  $.renderPreview('answer') if $('#answer-preview').is(":visible")

$('#group_title, #group_description').on 'input', (e) ->
  $.renderPreview('group') if $('#group-preview').is(":visible")