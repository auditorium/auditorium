class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.belongs_to :follower
      t.belongs_to :followerable, polymorphic: true

      t.timestamps
    end
    add_index :followings, :follower_id
    add_index :followings, :followerable_id
    add_index :followings, :followerable_type
  end
end
