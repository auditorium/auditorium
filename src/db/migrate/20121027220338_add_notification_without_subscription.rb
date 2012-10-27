class AddNotificationWithoutSubscription < ActiveRecord::Migration
  def change
  	add_column :email_settings, :notification_when_author, :boolean, :default => true
  end
end
