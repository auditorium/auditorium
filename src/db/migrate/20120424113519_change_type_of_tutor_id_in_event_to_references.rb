class ChangeTypeOfTutorIdInEventToReferences < ActiveRecord::Migration
  def change
    remove_column :events, :tutor_id
    add_column :events, :tutor_id, :integer
  end
end
