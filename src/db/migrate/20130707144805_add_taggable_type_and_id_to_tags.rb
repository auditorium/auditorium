class AddTaggableTypeAndIdToTags < ActiveRecord::Migration
  def change
    add_column :tags, :taggable_id, :integer
    add_column :tags, :taggable_type, :string
  end
end
