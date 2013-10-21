class ChangeDescriptionColumnTypeToText < ActiveRecord::Migration
  def change
  	change_column :lectures, :description, :text, default: nil
  end
end
