class MembershipRequestsController < ApplicationController
  def index
    @membership_requests = MembershipRequest.order('created_at desc').keep_if{|m| can? :manage, m }
    @membership_requests = Kaminari.paginate_array(@membership_requests).page(params[:mr_page]).per(20)
  end

  def new
    @membership_request = MembershipRequest.new
  end

  def create
    course_id = params[:course_id]
    user_id = current_user.id
    membership_type = params[:membership_type]
    @membership_request = MembershipRequest.create(:user_id => user_id, :course_id => course_id, :membership_type => membership_type)

    respond_to do |format|
      format.html { redirect_to @membership_request.course, :flash => { :success => 'Your request has been delivered and it will be approved.' } }
    end
  end

  def reject
    @membership_request = MembershipRequest.find(params[:id])
    @membership_request.read = true
    @membership_request.confirmed = false

    AuditoriumMailer.confirm_membership_request(@membership_request).deliver

    respond_to do |format|
      if @membership_request.save!
        format.html { redirect_to membership_requests_path, :flash => { :success => "The membership request has been rejected." } }
      else
        format.html { redirect_to membership_requests_path, :flash => { :error => "Something went wrong." } }
      end
    end
  end

  def add_as_member
    @membership_request = MembershipRequest.find(params[:id])
    @membership_request.read = true
    @membership_request.confirmed = false
    mtype = 'member'

    AuditoriumMailer.reject_membership_request_add_as_member(@membership_request).deliver
    
    if membership = CourseMembership.find_by_user_id_and_course_id(@membership_request.user.id, @membership_request.course.id)
      membership.membership_type = mtype
      membership.save!
    else
      membership = CourseMembership.create(:user_id => @membership_request.user.id, :course_id => @membership_request.course.id, :membership_type => mtype)
    end

    respond_to do |format|
      if @membership_request.save!
        format.html { redirect_to membership_requests_path, :flash => { :success => "The membership request has been rejected. The user is now a normal member of this course." } }
      else
        format.html { redirect_to membership_requests_path, :flash => { :error => "Something went wrong." } }
      end
    end
  end

  def confirm
    @membership_request = MembershipRequest.find(params[:id])
    @membership_request.read = true
    @membership_request.confirmed = true

    if membership = CourseMembership.find_by_user_id_and_course_id(@membership_request.user.id, @membership_request.course.id)
      membership.membership_type = @membership_request.membership_type
      membership.save!
    else
      membership = CourseMembership.create(:user_id => @membership_request.user.id, :course_id => @membership_request.course.id, :membership_type => @membership_request.membership_type)
    end

    AuditoriumMailer.confirm_membership_request(@membership_request).deliver

    respond_to do |format|
      if @membership_request.save!
        format.html { redirect_to membership_requests_path, :flash => { :success => "The membership request has been confirmed." } }
      else
        format.html { redirect_to membership_requests_path, :flash => { :error => "Something went wrong." } }
      end
    end

  end

  def destroy
    @membership_request = MembershipRequest.find(params[:id])
    @membership_request.destroy

    respond_to do |format|
      format.html{redirect_to membership_requests_path, flash: { success: 'The membership request has been removed.' } }  
    end
  end
end
