class AddPointsToRatings < ActiveRecord::Migration
  def change
    add_column :ratings, :points, :integer, :default => 0
  end
end
