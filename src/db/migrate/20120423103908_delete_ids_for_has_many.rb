class DeleteIdsForHasMany < ActiveRecord::Migration
  def up
    remove_column :chairs, :lecture_id
    remove_column :courses, :post_id
    remove_column :courses, :event_id
    remove_column :events, :period_id
    remove_column :faculties, :institute_id
    remove_column :institutes, :chair_id
    remove_column :lectures, :responsible_id
    remove_column :lectures, :course_id
    remove_column :lectures, :lecture_id
    remove_column :terms, :course_id
    remove_column :users, :lecture_id
    remove_column :users, :event_id
    remove_column :users, :course_id
  end

  def down
  end
end
