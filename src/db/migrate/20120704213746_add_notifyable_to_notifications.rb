class AddNotifyableToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :notifyable_id, :integer, :polymorphic => true
    add_index :notifications, :notifyable_id
  end
end
