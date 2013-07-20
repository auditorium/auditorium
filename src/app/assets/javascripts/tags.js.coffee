# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$('#group_tag_tokens').tokenInput '/tags.json',  
  prePopulate: $('#group_tag_tokens').data('load') 
  theme: 'facebook'
  crossDomain: false
  hintText: i18n_tokeninput_hint_text
  noResultsText: i18n_tokeninput_no_results_text
  searchingText: i18n_tokeninput_searching_text