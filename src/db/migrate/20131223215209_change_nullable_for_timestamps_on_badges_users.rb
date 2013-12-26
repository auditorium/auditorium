class ChangeNullableForTimestampsOnBadgesUsers < ActiveRecord::Migration
  def change
    change_column(:badges_users, :created_at, :datetime, :null => true)
    change_column(:badges_users, :updated_at, :datetime, :null => true)
  end
end
