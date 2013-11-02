class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.boolean :receive_emails_when_author, default: true
      t.boolean :receive_email_notifications, default: true
      t.timestamps
    end
  end
end
