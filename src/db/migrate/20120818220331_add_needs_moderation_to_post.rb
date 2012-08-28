class AddNeedsModerationToPost < ActiveRecord::Migration
  def change
    add_column :posts, :needs_review, :boolean, :default => false
  end
end
