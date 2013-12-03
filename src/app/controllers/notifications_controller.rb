class NotificationsController < ApplicationController
  load_and_authorize_resource
  
  # GET /notifications
  # GET /notifications.json
  def index
    @notifications = current_user.notifications.reverse

    @notifications = Kaminari.paginate_array(@notifications).page(params[:page]).per(10)
    respond_to do |format|
      format.html
    end
  end

  def show
    @notification = Notification.find(params[:id])
    @notification.read = true
    @notification.save
  
    case @notification.notifiable_type
    when 'MembershipRequest'
      path = group_membership_requests_path(@notification.notifiable.group)
    else 
      path = @notification.notifiable
    end
    redirect_to path
  end

  # DELETE /notifications/1
  # DELETE /notifications/1.json
  def destroy
    @notification = Notification.find(params[:id])
    @notification.destroy

    respond_to do |format|
      format.html { redirect_to notifications_url }
    end
  end

  def mark_all_as_read
    current_user.notifications.each do |notification|
      notification.read = true
      notification.save
    end if not current_user.notifications.empty?

    redirect_to notifications_path, notice: t('notifications.flash.marked_all_as_read')
  end

  def mark_as_read
    @notification = Notification.find(params[:id])

    @notification.read = true
    
    @notification.save
    redirect_to notifications_path
  end

  def delete_all
    current_user.notifications.destroy_all

    redirect_to notifications_path, notice: t('notifications.flash.deleted_all')
  end
end
