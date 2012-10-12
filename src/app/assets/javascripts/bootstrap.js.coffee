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

   


scrollTop = -> document.body.scrollTop or document.documentElement.scrollTop
$("li.dropdown-fallback").each -> @style.display= "none"

window.onscroll = ->
  navigation = $('div#navigation')

  offset = parseInt(document.body.scrollTop) - @old_position
  if offset >= 0
    navigation.addClass('fixed-navbar')
  else
    navigation.removeClass('fixed-navbar')