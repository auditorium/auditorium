$('.follow-button-<%= @course.id %>').html('<%= escape_javascript(render :partial => "shared/follow_button", :locals => { :course => @course }) %>');

$('.subscribed-course-<%= @course.id %>').remove();

count = $('.subscribed-courses table').children().length;

if (count == 0)
	$('.subscribed-courses').html('<%= escape_javascript(render "course_memberships/no_subscribtions") %>'); 

