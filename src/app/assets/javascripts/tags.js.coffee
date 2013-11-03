# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$.filterGroups = (item, url) ->
  tags = $('#group_filter_tag_tokens').val()
  alert(tags)
  $.ajax
    url: url
    type: 'get'
    data: { tags: tags }
    error: (jqXHR, textStatus, errorThrown) ->
      console.log errorThrown

$.filterPosts = (item) ->
  tags = $('#post_filter_tag_tokens').val()
  $.ajax
    url: '/home'
    type: 'get'
    data: { tags: tags }
    error: (jqXHR, textStatus, errorThrown) ->
      console.log errorThrown

$('#group_tag_tokens, #question_tag_tokens, #answer_tag_tokens, #announcement_tag_tokens, #topic_tag_tokens').tokenInput '/tags.json',  
  prePopulate: $('#group_tag_tokens, #question_tag_tokens, #announcement_tag_tokens,#answer_tag_tokens, #topic_tag_tokens').data('load') 
  crossDomain: false
  hintText: i18n_tokeninput_hint_text
  noResultsText: i18n_tokeninput_no_results_text
  searchingText: i18n_tokeninput_searching_text
  animateDropdown: false
  preventDuplicates: true

$('.groups-filter #group_filter_tag_tokens').tokenInput '/tags.json',  
  prePopulate: $('.groups-filter #group_filter_tag_tokens').data('load')
  crossDomain: false
  hintText: i18n_tokeninput_hint_text
  noResultsText: i18n_tokeninput_no_results_text
  searchingText: i18n_tokeninput_searching_text
  animateDropdown: false
  preventDuplicates: true
  onAdd: (item) -> $.filterGroups(item, '/groups')
  onDelete: (item) -> $.filterGroups(item, '/groups')


$('.my-groups-filter #group_filter_tag_tokens').tokenInput '/tags.json',  
  prePopulate: $('.my-groups-filter #group_filter_tag_tokens').data('load')
  crossDomain: false
  hintText: i18n_tokeninput_hint_text
  noResultsText: i18n_tokeninput_no_results_text
  searchingText: i18n_tokeninput_searching_text
  animateDropdown: false
  preventDuplicates: true
  onAdd: (item) -> $.filterGroups(item, '/groups/my_groups')
  onDelete: (item) -> $.filterGroups(item, '/groups/my_groups')

$('#post_filter_tag_tokens').tokenInput '/tags.json',  
  prePopulate: $('#post_filter_tag_tokens').data('load') 
  crossDomain: false
  hintText: i18n_tokeninput_hint_text
  noResultsText: i18n_tokeninput_no_results_text
  searchingText: i18n_tokeninput_searching_text
  animateDropdown: false
  preventDuplicates: true
  onAdd: (item) -> $.filterPosts(item)
  onDelete: (item) -> $.filterPosts(item)