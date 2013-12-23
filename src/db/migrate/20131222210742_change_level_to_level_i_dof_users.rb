class ChangeLevelToLevelIDofUsers < ActiveRecord::Migration
  def change
    rename_column :users, :level, :level_id
  end
end
