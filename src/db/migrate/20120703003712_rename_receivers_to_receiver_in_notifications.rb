class RenameReceiversToReceiverInNotifications < ActiveRecord::Migration
  def change
    rename_column :notifications, :receivers_id, :receiver_id
  end
end
