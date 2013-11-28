class AddPrivacyPolicyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :privacy_policy, :boolean, default: false
  end
end
