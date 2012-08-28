class AddTitleBodyAndReadStateToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :title, :string
    add_column :notifications, :body, :text
    add_column :notifications, :read, :boolean, :default => false
  end
end
