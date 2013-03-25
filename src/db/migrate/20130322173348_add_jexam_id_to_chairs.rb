class AddJexamIdToChairs < ActiveRecord::Migration
  def change
  	add_column :chairs, :jexam_id, :integer

  	Chair.all.each do |chair|
  		chair.jexam_id = chair.id
  		chair.save
  	end
  end
end
