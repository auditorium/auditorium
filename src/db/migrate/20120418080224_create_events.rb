class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :type
      t.references :course
      t.references :period

      t.timestamps
    end
    add_index :events, :course_id
    add_index :events, :period_id
  end
end
