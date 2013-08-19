$.renderPreview = (id) ->
  $.ajax 
    url: '/ajax/preview'
    type: 'POST'
    data: { 
      post_type: id
      subject: $('#'+id+'_subject').val() if id != 'answer'
      content: $('#'+id+'_content').val()
    }
    error: (jqXHR, textStatus, errorThrown) ->
      console.log errorThrown

# Preview post content
$('a.toggle-preview').on 'click', (e) ->
  e.preventDefault()
  data_id = $(this).data('id')
  
  if $(this).text() == i18n_hide_preview
    $('#'+data_id+'-preview').hide()
    $(this).text(i18n_show_preview)
  else
    $.renderPreview(data_id)
    $('#'+data_id+'-preview').show()
    $(this).text(i18n_hide_preview)

$('#announcement_subject, #announcement_content').on 'input', (e) ->
  $.renderPreview('announcement') if $('#announcement-preview').is(":visible")
      
$('#question_subject, #question_content').on 'input', (e) ->
  $.renderPreview('question') if $('#question-preview').is(":visible")

$('#topic_subject, #topic_content').on 'input', (e) ->
  $.renderPreview('topic') if $('#topic-preview').is(":visible")

$('#answer_content').on 'input', (e) ->
  $.renderPreview('answer') if $('#answer-preview').is(":visible")