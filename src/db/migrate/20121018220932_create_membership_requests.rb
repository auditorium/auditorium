class CreateMembershipRequests < ActiveRecord::Migration
  def change
    create_table :membership_requests do |t|
      t.references :user
      t.references :course
      t.string :membership_type
      t.boolean :read, :default => false
      t.boolean :confirmed, :default => false

      t.timestamps
    end
    add_index :membership_requests, :user_id
    add_index :membership_requests, :course_id
  end
end
