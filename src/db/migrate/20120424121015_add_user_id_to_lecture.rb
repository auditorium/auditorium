class AddUserIdToLecture < ActiveRecord::Migration
  def change
    add_column :lectures, :maintainer_id, :integer
    add_index :lectures, :maintainer_id
  end
end
