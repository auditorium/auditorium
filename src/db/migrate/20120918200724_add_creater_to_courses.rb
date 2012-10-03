class AddCreaterToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :creater_id, :integer
    add_index :courses, :creater_id
  end
end
