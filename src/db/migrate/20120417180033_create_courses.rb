class CreateCourses < ActiveRecord::Migration
  def change
    create_table :courses do |t|
      t.string :name
      t.references :term # semester oder trimester
      t.references :post
      t.references :event
      t.references :lecture
      t.text :description

      t.timestamps
    end
    add_index :courses, :term_id
    add_index :courses, :post_id
    add_index :courses, :lecture_id
    add_index :courses, :event_id
  end
end
