class RemoveModerationEmailsFromEmailSettings < ActiveRecord::Migration
  def change
  	remove_column :email_settings, :moderation_emails
  end
end
