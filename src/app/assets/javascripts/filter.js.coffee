if $(window).width() > 500
  $('[data-id="post-filter"]').slideDown()
  $('[data-id="group-filter"]').slideDown()
else
  $('[data-id="toggle-group-filter"]').text(i18n_general_filter_show)
  $('[data-id="toggle-post-filter"]').text(i18n_general_filter_show)

$('[data-id="toggle-post-filter"]').on 'click', (e) ->
  e.preventDefault()
  $('[data-id="post-filter"]').toggle()
  if $(this).text() == i18n_general_filter_hide
    $(this).text(i18n_general_filter_show)
  else
    $(this).text(i18n_general_filter_hide)

$('[data-id="toggle-group-filter"]').on 'click', (e) ->
  e.preventDefault()
  $('[data-id="group-filter"]').toggle()
  if $(this).text() == i18n_general_filter_hide
    $(this).text(i18n_general_filter_show)
  else
    $(this).text(i18n_general_filter_hide)