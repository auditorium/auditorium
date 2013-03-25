class AddJexamIdToCourses < ActiveRecord::Migration
  def change
  	add_column :courses, :jexam_id, :integer

  	Course.all.each do |course|
  		course.jexam_id = course.id
  		course.save
  	end
  end
end
