class AddTutorIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :tutor_id, :integer
    add_index :events, :tutor_id
  end
end
