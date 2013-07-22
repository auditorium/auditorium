class ChangePostTypeInfoToAnnouncementInPosts < ActiveRecord::Migration
  def up
    Post.where(post_type: 'info').each do |post|
      post.post_type = 'announcement'
      post.save!
    end
  end

  def down
    Post.where(post_type: 'announcement').each do |post|
      post.post_type = 'info'
      post.save!
    end
  end
end
