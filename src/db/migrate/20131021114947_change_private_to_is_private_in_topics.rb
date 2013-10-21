class ChangePrivateToIsPrivateInTopics < ActiveRecord::Migration
  def change
    rename_column :topics, :private, :is_private
  end
end
