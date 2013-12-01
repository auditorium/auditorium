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

    redirect_to url_for(@notification)
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

    respond_to do |format|
      format.html { redirect_to notifications_path, success: 'Marked all notifications as read.' }
    end
  end

  def mark_as_read
    @notification = Notification.find(params[:id])

    @notification.read = true
    
    respond_to do |format|
      if @notification.save
        format.js
      else
        format.html{ redirect_to notifications_path, flash: { success: 'Something went wrong, try again in a little while.' } }  
      end
    end
  end

  def delete_all_notifications
    current_user.notifications.destroy_all

    respond_to do |format|
      format.html { redirect_to notifications_path, flash: { :success => 'Your notifications were deleted.'}}
    end
  end
end
