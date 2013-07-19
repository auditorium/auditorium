class AddGroupTypeToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :group_type, :string, default: 'lecture'
  end
end
