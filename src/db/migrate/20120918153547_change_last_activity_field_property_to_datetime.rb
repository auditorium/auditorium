class ChangeLastActivityFieldPropertyToDatetime < ActiveRecord::Migration
  def change
  	change_column :posts, :last_activity, :datetime
  end
end
