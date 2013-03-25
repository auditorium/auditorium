class AddJexamIdToLectures < ActiveRecord::Migration
  def change
  	add_column :lectures, :jexam_id, :integer

  	Lecture.all.each do |lecture|
  		lecture.jexam_id = lecture.id
  		lecture.save
  	end
  end
end
