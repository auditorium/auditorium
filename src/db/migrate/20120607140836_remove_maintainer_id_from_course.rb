class RemoveMaintainerIdFromCourse < ActiveRecord::Migration
  def change
    remove_column :courses, :maintainer_id
  end
end
