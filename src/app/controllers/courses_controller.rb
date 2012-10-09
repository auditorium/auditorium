class CoursesController < ApplicationController

  load_and_authorize_resource

  
  include ActionView::Helpers::DateHelper 

  # GET /courses
  # GET /courses.json
  def index

    if params[:term_id]
      @term = Term.find(params[:term_id]) if params[:term_id]
      @courses = Course.where('term_id = ?', @term.id).order('term_id DESC, name DESC')
    else
      @courses = Course.order('term_id DESC, name DESC')
    end
    @courses.sort! { |x,y| y.participants.count <=> x.participants.count and y.followers.count <=> x.followers.count }
    @courses = Kaminari.paginate_array(@courses).page(params[:page]).per(20)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @courses }
    end
  end

  # GET /courses/1
  # GET /courses/1.json
  def show
    @course = Course.find(params[:id])
    @users = User.order('username DESC, email DESC, first_name DESC, last_name DESC') if can? :manage, User
    @infos = Post.order('last_activity DESC, updated_at DESC, created_at DESC').where('post_type = ? and course_id = ?', 'info', @course.id)
    @questions = Post.order('last_activity DESC, updated_at DESC, created_at DESC').where('post_type = ? and course_id = ?', 'question', @course.id).page(params[:page]).per(15)
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
    if params[:course_id]
      @course = Course.find(params[:course_id])
    else
      @course = Course.new
      @course.lecture_id = params[:lecture_id]
      @course.name = params[:name]
      @course.url = params[:url]
    end

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
    if current_user.is_admin?
      @course.approved = true
      flash_message = 'Course was successfully created.' 
    else
      @course.approved = false
      @course.creator = current_user
      flash_message = 'Course was successfully suggested. Our moderators will check it. But you can already ask questions if you want.'
    end

    

    # creater gets maintainer status 
    # TODO

    respond_to do |format|
      if @course.save
        # make create to maintainer if he is no admin
        if @course.creator and !@course.creator.is_admin?
          membership = CourseMembership.new(:user_id => @course.creator.id, :course_id => @course.id, :membership_type => 'maintainer')
          if membership.save!
            AuditoriumMailer.membership_changed(@course, @course.creator, 'maintainer').deliver 
          end
        end

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
          format.html { redirect_to redirect_url, :flash => {:success => 'You have subscribed to this course. Now you will receive notificatons on updates.' } }
          format.json { render json: course, status: :following, location: course }
        else
          format.html { redirect_to redirect_url, :flash => {:alert => 'Something went wrong. Try again later.' }}
          format.json { render json: course.errors, status: :unprocessable_entity }
        end
      elsif params['unfollow']
        format.js { }
        format.html { redirect_to redirect_url, :flash => {:success => 'You have successfully unsubscribed to this course. You will no longer receive notifications on updates.' } }
        format.json { render json: course, status: :following, location: course }
      else
        format.html { redirect_to redirect_url, :flash => {:alert => 'Something went wrong. Try again later.' }}
        format.json { render json: course.errors, status: :unprocessable_entity }
      end
      
    end
  end
  
  def manage_users
    @course = Course.find(params[:id])
    
    User.all.each do |user|
      membership_type = params["#{user.id}"]
      membership = CourseMembership.find_by_course_id_and_user_id(@course.id, user.id)

      before = membership.membership_type if not membership.nil?
      after = membership_type

      if membership.nil?
        membership = CourseMembership.create(:user_id => user.id, :course_id => @course.id, :membership_type => membership_type)
      else
        membership.membership_type = membership_type
        membership.save
      end

      # send mail
      if not before.eql? after and not after.eql? 'member'
        AuditoriumMailer.membership_changed(@course, user, membership_type).deliver
      end
    end
    
    respond_to do |format|
      format.js
    end
  end

  def approve
    course = Course.find(params[:id])
    course.approved = true
    course.save

    if not course.creator.nil?
      AuditoriumMailer.course_approved(course, course.creator).deliver
    end
    respond_to do |format|
      format.js
      format.html { redirect_to course, :flash => { :success => 'Course has been approved.'} }
    end
  end

  def announcements
    @infos = Course.find(params[:id]).infos

    respond_to do |format|
      format.html
    end
  end

  def search_users
    @users = User.where('username LIKE ? or first_name LIKE ? or last_name LIKE ? or email LIKE ?', "%#{params[:q]}%","%#{params[:q]}%","%#{params[:q]}%","%#{params[:q]}%").order('username DESC, email DESC, first_name DESC, last_name DESC')

    respond_to do |format|
      format.js
    end
  end

end
