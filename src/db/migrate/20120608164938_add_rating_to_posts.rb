class AddRatingToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :rating, :integer, :default => 0
  end
end
