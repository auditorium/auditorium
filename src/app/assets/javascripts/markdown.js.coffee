$.loadMarkdownSheet = () ->
  $.ajax
    url: '/ajax/markdown_sheet'
    type: 'post'
    error: (jqXHR, textStatus, errorThrown) ->
      console.log errorThrown
    success:
      $('#markdown-sheet').toggle()


$('a[data-id="markdown"]').on 'click', (e) ->
  e.preventDefault()
  $.loadMarkdownSheet()
  $(this).find('i').toggleClass('fa-chevron-down fa-chevron-up')