class AddPrivateOptionToPosts < ActiveRecord::Migration
  def change
  	# only course moderator and editor and the owner can see this post
    add_column :posts, :is_private, :boolean, :default => false
  end
end
