<%  %>

$('.follow-button-<%= @course.id %>').html('<%= j(render :partial => "shared/follow_button", :locals => { :course => @course }) %>');

$('.subscribed-course-<%= @course.id %>').remove();

count = $('.subscribed-courses table').children().length;

if (count == 0)
	$('.subscribed-courses').html('<%= j(render "course_memberships/no_subscribtions") %>'); 

