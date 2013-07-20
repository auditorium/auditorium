class AddCreatorToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :creator_id, :integer, default: 1
    add_index :groups, :creator_id
  end
end
