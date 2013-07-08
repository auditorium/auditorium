class RemoveTaggableTypeAndIdFromTags < ActiveRecord::Migration
  def up
    remove_column :tags, :taggable_id
    remove_column :tags, :taggable_type
  end

  def down
    add_column :tags, :taggable_type, :string
    add_column :tags, :taggable_id, :integer
  end
end
