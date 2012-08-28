class AddMaintainerSwsAndUrlToCourses < ActiveRecord::Migration
  def change
    add_column :courses, :maintainer_id, :integer
    add_index :courses, :maintainer_id

    
    add_column :courses, :sws, :integer, :default => 0
    add_column :courses, :url, :string, :default => ""
  end
end
