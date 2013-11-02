class AddReceiveEmailNotificationsToGroup < ActiveRecord::Migration
  def change
    add_column :groups, :receive_email_notifications, :boolean, default: true
  end
end
