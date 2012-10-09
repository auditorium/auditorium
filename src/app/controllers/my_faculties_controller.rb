class MyFacultiesController < ApplicationController

  #load_and_authorize_resource

  def index
    @faculties = current_user.faculties
    @faculties_with_courses = current_user.faculties_with_courses

  end
end
