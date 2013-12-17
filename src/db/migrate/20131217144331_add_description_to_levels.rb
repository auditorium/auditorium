class AddDescriptionToLevels < ActiveRecord::Migration
  def change
    add_column :levels, :description, :text
    add_index :levels, :user_id
  end
end
