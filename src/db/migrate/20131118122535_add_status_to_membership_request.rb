class AddStatusToMembershipRequest < ActiveRecord::Migration
  def change
    add_column :membership_requests, :status, :string, default: 'pending'
  end
end
