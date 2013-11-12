class ChangeNotifyableToNotifiableInNotifications < ActiveRecord::Migration
  def change
    rename_column :notifications, :notifyable_id, :notifiable_id
    rename_column :notifications, :notifyable_type, :notifiable_type
    rename_index :notifications, :notifyable_id, :notifiable_id
    rename_index :notifications, :notifyable_type, :notifiable_id
  end
end
