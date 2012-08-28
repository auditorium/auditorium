class CreateFaculties < ActiveRecord::Migration
  def change
    create_table :faculties do |t|
      t.string :name
      t.references :institute

      t.timestamps
    end
    add_index :faculties, :institute_id
  end
end
