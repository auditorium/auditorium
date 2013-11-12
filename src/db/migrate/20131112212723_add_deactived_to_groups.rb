class AddDeactivedToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :deactivated, :boolean, default: false
  end
end
