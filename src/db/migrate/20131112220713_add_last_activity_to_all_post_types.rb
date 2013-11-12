class AddLastActivityToAllPostTypes < ActiveRecord::Migration
  def change
    add_column :questions, :last_activity, :datetime
    add_column :announcements, :last_activity, :datetime
    add_column :topics, :last_activity, :datetime
    add_column :videos, :last_activity, :datetime
    add_column :comments, :last_activity, :datetime
    add_column :answers, :last_activity, :datetime
  end
end
