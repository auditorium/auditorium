class ChangeNameOfTableTagToTags < ActiveRecord::Migration
  def change
    rename_table :tag, :tags
  end
end
