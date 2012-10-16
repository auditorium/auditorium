jQuery ->
	$('input[placeholder], textarea[placeholder]').placeholder()
	if $.browser.msie and (parseInt($.browser.version) == 7 or parseInt($.browser.version) == 8)
		$('#header').addClass('ie-header') 