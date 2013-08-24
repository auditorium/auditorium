class AddRoleAndNotificationsToFollowings < ActiveRecord::Migration
  def change
    add_column :followings, :role, :string, default: 'member'
    add_column :followings, :receive_notifications, :boolean, default: true
  end
end
