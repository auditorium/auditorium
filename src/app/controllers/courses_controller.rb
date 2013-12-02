class CoursesController < ApplicationController
  def show
    course = Course.find(params[:id])
    @group = Group.find(course.lecture.id) if course.lecture.present?
    redirect_to group_path(@group)
  end
end
