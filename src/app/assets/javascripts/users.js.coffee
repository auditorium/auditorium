$.renderTabContent = (tab_content, user_id) ->
  $.ajax
    type: 'post'
    url: '/ajax/tab_content'
    data: { user_id: user_id, view: tab_content }
    error: (jqXHR, textStatus, errorThrown) ->
      console.log errorThrown

$ ->
  $('.tabs li').on 'click', (e) ->
    tab_content = $(this).data('tab-content')

    e.preventDefault()
    console.log(window.location)
    user_id = $(this).data('user-id')
    $.renderTabContent(tab_content, user_id)
    $('.tabs li.active').removeClass('active')
    console.log(".tabs li[data-tab-content='#{tab_content}']")
    $(".tabs li[data-tab-content='#{tab_content}']").toggleClass('active')  
