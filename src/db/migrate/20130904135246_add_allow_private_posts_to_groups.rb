class AddAllowPrivatePostsToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :private_posts, :boolean
    remove_column :groups, :post_id
  end
end
