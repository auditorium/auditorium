class CreateBadgesUsers < ActiveRecord::Migration
  def change
    create_table :badges_users do |t|
      t.references :user
      t.references :badge

      t.timestamps
    end
    add_index :badges_users, :user_id
    add_index :badges_users, :badge_id
  end
end
