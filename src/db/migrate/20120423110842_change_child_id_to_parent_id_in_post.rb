class ChangeChildIdToParentIdInPost < ActiveRecord::Migration
  def change
    rename_column :posts, :child_id, :parent_id
  end
end
