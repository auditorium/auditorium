class ChangeCreaterToCreatorInCourses < ActiveRecord::Migration
  def change
  	rename_column :courses, :creater_id, :creator_id
  end
end
