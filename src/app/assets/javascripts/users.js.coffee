$.renderTabContent = (tab_content) ->
  $.ajax
    type: 'post'
    url: '/ajax/tab_content'
    data: { partial: "users/#{tab_content}" }
    error: (jqXHR, textStatus, errorThrown) ->
      console.log errorThrown

$ ->
  $('.tabs li').on 'click', (e) ->
    e.preventDefault()
    tab_content = $(this).data('tab-content')
    $.renderTabContent(tab_content)
    $('.tabs li.active').removeClass('active')
    console.log(".tabs li[data-tab-content='#{tab_content}']")
    $(".tabs li[data-tab-content='#{tab_content}']").toggleClass('active')  
