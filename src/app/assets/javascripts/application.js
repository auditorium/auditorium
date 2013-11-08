// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//

//= require jquery
//= require jquery_ujs
//= require jquery.ui.all
//= require jquery.tokeninput
//= require foundation
//= require translations
//= require mathjax/MathJax
//= require behave
//= require_tree 

$(function(){ 
  $(document).foundation();
  $(document).foundation('joyride', 'start');

  if($('#announcement_content').is(':visible')) {
    new Behave({
      textarea: document.getElementById('announcement_content'),
      tabSize: 2
    });
  }

  if($('#question_content').is(':visible')) {
    new Behave({
      textarea: document.getElementById('question_content'),
      tabSize: 2
    });
  }
  
  if($('#topic_content').is(':visible')) {
    new Behave({
      textarea: document.getElementById('topic_content'),
      tabSize: 2
    });
  }

  if($('#answer_content').is(':visible')) {
    new Behave({
      textarea: document.getElementById('answer_content'),
      tabSize: 2
    });
  }

  if($('#comment_content').is(':visible')) {
    new Behave({
      textarea: document.getElementById('comment_content'),
      tabSize: 2
    });
  }

  if($('#recording_content').is(':visible')) {
    new Behave({
      textarea: document.getElementById('recording_content'),
      tabSize: 2
    });
  }
});

