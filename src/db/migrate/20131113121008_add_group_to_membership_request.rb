class AddGroupToMembershipRequest < ActiveRecord::Migration
  def change
    add_column :membership_requests, :group_id, :integer
    add_index :membership_requests, :group_id
  end
end
