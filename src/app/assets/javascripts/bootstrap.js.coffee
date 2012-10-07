jQuery ->
  # when page is loaded with hash
  if window.location.hash and window.location.hash.match(/#post-/)
    $('html,body').animate({scrollTop:$(window.location.hash).offset().top - 60}, 1000)
    $('div'+window.location.hash).effect('highlight', {}, 2000)

scrollTop = -> document.body.scrollTop or document.documentElement.scrollTop
$("li.dropdown-fallback").each -> @style.display= "none"


window.onscroll = ->
  navigation = document.querySelector("div#navigation")
  nav_height = $("div#navigation").height()
  body = document.querySelector("body")
  section = document.querySelector("body > section")
  fixed_nav_class = 'navbar-fixed-top'
  offset = navigation.offsetTop
  collapsed = $('body').width() <= 970

  # remember offset
  if !navigation.hasAttribute('data-top')
    navigation.setAttribute('data-top', offset)

  if scrollTop() >= offset && not navigation.classList.contains fixed_nav_class
    navigation.classList.add(fixed_nav_class)
    section.style.paddingTop = "#{20 + nav_height}px"
    

  else if scrollTop() <= navigation.getAttribute('data-top') && navigation.classList.contains fixed_nav_class
    navigation.classList.remove(fixed_nav_class)
    section.style.paddingTop = "20px"

