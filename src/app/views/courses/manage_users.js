$('#manage-users-modal').modal('toggle');

$('#course-<%= @course.id %>-follow-button').html('<%= escape_javascript(render :partial => "shared/follow_button", :locals => { :course => @course }) %>');
$('#maintainer-list').html('<%= escape_javascript(render :partial => "courses/maintainer_list", :locals => { :maintainers => @course.maintainers, :editors => @course.editors, :course => @course }) %>');
$('#follow-button-membership-type').tooltip('toggle')