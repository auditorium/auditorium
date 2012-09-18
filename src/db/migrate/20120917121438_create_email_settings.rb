class CreateEmailSettings < ActiveRecord::Migration
  def change
    create_table :email_settings do |t|
      t.references :user
      t.boolean :html_format, :default => false
      t.boolean :emails_for_subscribtions, :default => true
      t.boolean :weekly, :default => true
      t.boolean :moderation_emails, :default => true #when user is moderator in a course

      t.timestamps
    end
    add_index :email_settings, :user_id
  end
end
