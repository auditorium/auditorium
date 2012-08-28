class CreateChairs < ActiveRecord::Migration
  def change
    create_table :chairs do |t|
      t.string :name
      t.references :lecture
      t.references :institute

      t.timestamps
    end
    add_index :chairs, :lecture_id
    add_index :chairs, :institute_id
  end
end
