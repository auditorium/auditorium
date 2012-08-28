class AddNotifyableTypeToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :notifyable_type, :string
  end
end
