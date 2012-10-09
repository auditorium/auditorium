class CourseMembershipsController < ApplicationController
	load_and_authorize_resource
	def index
			@courses = current_user.courses.page(params[:page]).per(20)
    	@courses_by_faculty = @courses.group_by{ |course| course.lecture.chair.institute.faculty.name unless course.lecture.nil? }
	end
end
