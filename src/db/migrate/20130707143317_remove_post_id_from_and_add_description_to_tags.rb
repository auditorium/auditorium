class RemovePostIdFromAndAddDescriptionToTags < ActiveRecord::Migration
  def up
    add_column :tags, :description, :text
    remove_column :tags, :post_id
  end
  def down
  	remove_column :tags, :description
  	add_column :tags, :post_id
  	add_index :tags, :post_id
  end
end
