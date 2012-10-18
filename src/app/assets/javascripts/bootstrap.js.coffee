scrollToPost = (offset) ->
  if window.location.hash and window.location.hash.match(/#post-/)
    $("html,body").animate({scrollTop:$(window.location.hash).offset().top - offset}, 500)
    $(window.location.hash).effect('highlight', {}, 2000)

jQuery ->
  $(window).load ->
    @old_position = $('div#navigation').position().top
  $(window).resize ->
    @old_position = $('div#navigation').position().top

  # when page is loaded with hash
  if $.browser.safari 
    $(window).load -> scrollToPost(70)
  else
    $(window).load -> scrollToPost(140)

  $('a.copy-link').click (e) ->
    e.preventDefault
    false

window.onscroll = ->
  navigation = $('div#navigation')
  if $.browser.mozilla
    offset = $('html, body').scrollTop() - @old_position
  else 
    offset = document.body.scrollTop - @old_position

  if offset >= 0
    navigation.addClass('fixed-navbar')
  else
    navigation.removeClass('fixed-navbar')