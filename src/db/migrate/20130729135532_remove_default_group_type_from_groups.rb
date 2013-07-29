class RemoveDefaultGroupTypeFromGroups < ActiveRecord::Migration
  def change
    change_column_default :groups, :group_type, nil
  end
end
