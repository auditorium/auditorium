class MembershipRequestsController < ApplicationController
  load_and_authorize_resource :group
  load_and_authorize_resource :membership_request, :through => :group

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
    

  def confirm
    

  end

  def destroy
    @membership_request = MembershipRequest.find(params[:id])
    @membership_request.destroy

    respond_to do |format|
      format.html{redirect_to notifications_path, flash: { success: 'The membership request has been removed.' } }  
    end
  end
end
