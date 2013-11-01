$.renderTabContent = (tab_content, user_id) ->
  $.ajax
    type: 'post'
    url: '/ajax/tab_content'
    data: { user_id: user_id, partial: "users/#{tab_content}" }
    error: (jqXHR, textStatus, errorThrown) ->
      console.log errorThrown

$ ->
  $('.tabs li').on 'click', (e) ->
    e.preventDefault()
    console.log(window.location)
    tab_content = $(this).data('tab-content')
    user_id = $(this).data('user-id')
    $.renderTabContent(tab_content, user_id)
    $('.tabs li.active').removeClass('active')
    console.log(".tabs li[data-tab-content='#{tab_content}']")
    $(".tabs li[data-tab-content='#{tab_content}']").toggleClass('active')  
