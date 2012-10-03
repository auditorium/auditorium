class AddReadToFeedback < ActiveRecord::Migration
  def change
    add_column :feedbacks, :read, :boolean, :default => false
  end
end
