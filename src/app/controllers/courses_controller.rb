class CoursesController < ApplicationController

  load_and_authorize_resource

  
  include ActionView::Helpers::DateHelper 
  # GET /courses
  # GET /courses.json
  def index
    @courses = Course.order('name ASC').page(params[:page]).per(20)
    @courses_by_faculty = @courses.to_a.group_by{ |course| course.faculty }
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @courses }
    end
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @course = Course.find(params[:id])
    @infos = Post.order('created_at DESC').where('post_type = ? and course_id = ?', 'info', @course.id).page(params[:info_page]).per(20)
    @questions = Post.order('created_at DESC').where('post_type = ? and course_id = ?', 'question', @course.id).page(params[:question_page]).per(20)
    if current_user.nil?
      @questions.delete_if { |post| post.is_private }
    else
      @questions.delete_if {|post| !current_user.can_see(post)}
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/new
  # GET /courses/new.json
  def new
    @course = Course.new
    @course.lecture_id = params[:lecture_id]
    @course.name = params[:name]
    @course.url = params[:url]

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @course }
    end
  end

  # GET /courses/1/edit
  def edit
    @course = Course.find(params[:id])
  end

  # POST /courses
  # POST /courses.json
  def create
    @course = Course.new(params[:course])

    respond_to do |format|
      if @course.save
        format.html { redirect_to @course, notice: 'Course was successfully created.' }
        format.json { render json: @course, status: :created, location: @course }
      else
        format.html { render action: "new" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /courses/1
  # PUT /courses/1.json
  def update
    @course = Course.find(params[:id])

    respond_to do |format|
      if @course.update_attributes(params[:course])
        format.html { redirect_to @course, notice: 'Course was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /courses/1
  # DELETE /courses/1.json
  def destroy
    @course = Course.find(params[:id])
    @course.destroy

    respond_to do |format|
      format.html { redirect_to courses_url }
      format.json { head :no_content }
    end
  end

  def following
    
    @course = Course.find(params[:id])
   
    
    if params['unfollow']
      course_membership = CourseMembership.find_by_user_id_and_course_id(current_user.id, @course.id)
      course_membership.destroy if course_membership
    elsif params['follow']
      course_membership = CourseMembership.new :user_id => current_user.id, :course_id => @course.id, :membership_type => 'member'
    end
    
    if request.env["HTTP_REFERER"]
      redirect_url = request.env["HTTP_REFERER"]
    else
      redirect_url = @course
    end
    
    
    respond_to do |format|
      if params['follow']
        if course_membership.save!
          format.js { }
          format.html { redirect_to redirect_url, :flash => {:success => 'Du folgst nun dem Kurs und wirst informiert, wenn es Neuigkeiten gibt!' } }
          format.json { render json: course, status: :following, location: course }
        else
          format.html { redirect_to redirect_url, :flash => {:alert => 'Es ist ein Fehler aufgetreten, bitte versuche es noch einmal.' }}
          format.json { render json: course.errors, status: :unprocessable_entity }
        end
      elsif params['unfollow']
        format.js { }
        format.html { redirect_to redirect_url, :flash => {:success => 'Du wurdes erfolgreich aus dem Kurs ausgetragen.' } }
        format.json { render json: course, status: :following, location: course }
      else
        format.html { redirect_to redirect_url, :flash => {:alert => 'Es ist ein Fehler aufgetreten, bitte versuche es noch einmal.' }}
        format.json { render json: course.errors, status: :unprocessable_entity }
      end
      
    end
  end

  def search
    #todo
    respond_to do |format|
        format.js 
        format.html { redirect_to "#{root_url}?s=#{params[:query]}" }
    end
  end
  
  def manage_users
    @course = Course.find(params[:id])
    
    User.all.each do |user|
      membership_type = params["#{user.id}"]
      membership = CourseMembership.find_by_course_id_and_user_id(@course.id, user.id)
      if membership.nil?
        membership = CourseMembership.create(:user_id => user.id, :course_id => @course.id, :membership_type => membership_type)
      else
        membership.membership_type = membership_type
        membership.save
      end
    end
    
    if request.env["HTTP_REFERER"]
      redirect_url = request.env["HTTP_REFERER"]
    else
      redirect_url = @course
    end
    
    respond_to do |format|
      format.js
      format.html { redirect_to redirect_url, :flash => { :success => 'Successfully updated users for this course.'} }

    end
  end

end
