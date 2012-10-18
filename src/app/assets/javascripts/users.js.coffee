jQuery ->
	$('.change-gravatar, i.icon-certificate').hover ->
    $(this).tooltip('show')

  $('#signup-email-address, #signup-password, #confirm-email-address').focus ->
  	$(this).tooltip('show')