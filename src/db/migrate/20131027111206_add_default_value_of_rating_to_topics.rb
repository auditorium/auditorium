class AddDefaultValueOfRatingToTopics < ActiveRecord::Migration
  def change
    change_column :topics, :rating, :integer, default: 0
  end
end
