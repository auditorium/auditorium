class MembershipRequestsController < ApplicationController
  load_and_authorize_resource :group
  load_and_authorize_resource :membership_request, :through => :group

  def index
    @membership_requests = @group.membership_requests.page(params[:page]).per(12) 

    respond_to :html
  end

  def reject
    @membership_request = MembershipRequest.find(params[:id])
    @membership_request.status = 'rejected'
    @membership_request.save!
    @group.remove_moderator @membership_request.user

    AuditoriumMailer.rejected_membership_request({membership_request: @membership_request, group: @group }).deliver

    respond_to :js
  end

  def confirm
    @membership_request = MembershipRequest.find(params[:id])
    @membership_request.status = 'confirmed'
    @membership_request.save!

    @group.add_moderator @membership_request.user

    AuditoriumMailer.confirmed_membership_request({membership_request: @membership_request, group: @group }).deliver

    respond_to :js
  end

  def make  
    unless @group.membership_request_status?(current_user) == 'pending'
      @membership_request = @group.membership_requests.where(user_id: current_user.id, membership_type:'moderator').first_or_create!
    end
    respond_to :js
  end

  def cancel
    @membership_request = @group.membership_requests.where(user_id: current_user.id).first
    @notifications = Notification.where(notifiable_id: @membership_request.id, notifiable_type: MembershipRequest, sender_id: current_user.id)
    @notifications.delete_all

    @membership_request.destroy
    respond_to :js
  end
end
