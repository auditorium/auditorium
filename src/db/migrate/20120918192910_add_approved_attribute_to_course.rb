class AddApprovedAttributeToCourse < ActiveRecord::Migration
  def change
    add_column :courses, :approved, :boolean, :default => true
  end
end
