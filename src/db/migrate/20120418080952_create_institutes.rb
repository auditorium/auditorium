class CreateInstitutes < ActiveRecord::Migration
  def change
    create_table :institutes do |t|
      t.string :name
      t.references :faculty
      t.references :chair

      t.timestamps
    end
    add_index :institutes, :faculty_id
    add_index :institutes, :chair_id
  end
end
