class AddPostIdToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :post_id, :integer
    add_index :groups, :post_id
  end
end
