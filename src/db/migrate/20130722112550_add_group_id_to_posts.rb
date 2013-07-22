class AddGroupIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :group_id, :integer
    add_index :posts, :group_id
  end
end
