class AddLastActivityColumnToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :last_activity, :date
  end
end
