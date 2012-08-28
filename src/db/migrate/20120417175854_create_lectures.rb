class CreateLectures < ActiveRecord::Migration
  def change
    create_table :lectures do |t|
      t.string :name
      t.references :responsible
      t.references :course
      t.references :lecture
      t.references :chair

      t.timestamps
    end
    add_index :lectures, :responsible_id # responsible
    add_index :lectures, :course_id
    add_index :lectures, :lecture_id
    add_index :lectures, :chair_id
  end
end
