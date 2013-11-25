$.loadMarkdownSheet = (element_id) ->
  $.ajax
    url: '/ajax/markdown_sheet'
    data: { element_id: element_id }
    type: 'post'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log errorThrown
    success:
      $(".markdown-sheet[data-id='#{element_id}']").toggle()


$('a.markdown-reference').on 'click', (e) ->
  e.preventDefault()
  element_id = $(this).data('id')
  $.loadMarkdownSheet(element_id)
  $(this).find('i').toggleClass('fa-chevron-down fa-chevron-up')