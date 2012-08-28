class ChangeNameOfTableTagsToTag < ActiveRecord::Migration
  def change
    rename_table :tags, :tag
  end
end
