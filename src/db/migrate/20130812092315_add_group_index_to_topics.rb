class AddGroupIndexToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :group_id, :integer
    add_column :topics, :author_id, :integer

    add_index :topics, :group_id
    add_index :topics, :author_id
  end
end
