class RenameMediaToVideo < ActiveRecord::Migration
  def change
    rename_table :media, :videos
  end
end
