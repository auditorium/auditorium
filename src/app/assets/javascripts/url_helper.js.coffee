jQuery ->
	if window.location.hash and $('input#url_hash')
		$('input#url_hash').val(window.location.hash)