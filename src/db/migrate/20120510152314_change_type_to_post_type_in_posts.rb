class ChangeTypeToPostTypeInPosts < ActiveRecord::Migration
  def change
    rename_column :posts, :type, :post_type
  end
end
