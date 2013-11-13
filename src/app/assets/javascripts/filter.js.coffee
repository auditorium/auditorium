if $(window).width() < 500
  $('[data-id="post-filter"]').hide()
  $('[data-id="group-filter"]').hide()
  $('[data-id="toggle-group-filter"]').find('i').toggleClass('fa-chevron-up fa-chevron-down')
  $('[data-id="toggle-post-filter"]').find('i').toggleClass('fa-chevron-up fa-chevron-down')

$('[data-id="toggle-post-filter"]').on 'click', (e) ->
  e.preventDefault()
  $('[data-id="post-filter"]').toggle()
  $(this).find('i').toggleClass('fa-chevron-down fa-chevron-up')

$('[data-id="toggle-group-filter"]').on 'click', (e) ->
  e.preventDefault()
  $('[data-id="group-filter"]').toggle()
  $(this).find('i').toggleClass('fa-chevron-down fa-chevron-up')