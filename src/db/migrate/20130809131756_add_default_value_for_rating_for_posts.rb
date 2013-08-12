class AddDefaultValueForRatingForPosts < ActiveRecord::Migration
  def change
    change_column_default :questions, :rating, 0
    change_column_default :announcements, :rating, 0
    change_column_default :answers, :rating, 0
    change_column_default :comments, :rating, 0
    change_column_default :recordings, :rating, 0
  end
end
