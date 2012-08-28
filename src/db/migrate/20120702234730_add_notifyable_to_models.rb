class AddNotifyableToModels < ActiveRecord::Migration
  def change
      add_column :posts, :notifyable_id, :integer
      add_column :posts, :notifyable_type, :string
      
      add_column :course_memberships, :notifyable_id, :integer
      add_column :course_memberships, :notifyable_type, :string
      
      add_column :lecture_memberships, :notifyable_id, :integer
      add_column :lecture_memberships, :notifyable_type, :string
      
      add_column :faculty_memberships, :notifyable_id, :integer
      add_column :faculty_memberships, :notifyable_type, :string
      
      add_column :ratings, :notifyable_id, :integer
      add_column :ratings, :notifyable_type, :string
    end
end
