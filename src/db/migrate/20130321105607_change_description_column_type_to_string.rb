class ChangeDescriptionColumnTypeToString < ActiveRecord::Migration
  def change
  	change_column :lectures, :description, :text
  end
end
