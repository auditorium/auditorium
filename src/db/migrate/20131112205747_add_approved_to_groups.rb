class AddApprovedToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :approved, :boolean, defualt: false
  end
end
