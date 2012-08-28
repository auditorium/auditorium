class AddIndexForTutorId < ActiveRecord::Migration
  def change
    add_index :events, :tutor_id
  end
end
