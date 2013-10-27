class AddRatingToVideos < ActiveRecord::Migration
  def change
    add_column :videos, :rating, :integer, default: 0
  end
end
