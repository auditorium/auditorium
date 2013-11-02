class RemoveReceiveEmailNotificationsFromGroups < ActiveRecord::Migration
  def change
    remove_column :groups, :receive_email_notifications
  end
end
