class RemoveMaintainerFromLectures < ActiveRecord::Migration
  def change
    remove_index :lectures, :maintainer_id
    remove_column :lectures, :maintainer_id
    
  end
end
