class AddExperimentalGroupToUsers < ActiveRecord::Migration
  def change
    add_column :users, :experimental_group, :boolean, default: true
  end
end
