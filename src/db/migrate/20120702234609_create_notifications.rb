class CreateNotifications < ActiveRecord::Migration
  def change

    create_table :notifications do |t|
      t.references :receivers
      t.references :sender

      t.timestamps
    end
    add_index :notifications, :receivers_id
    add_index :notifications, :sender_id
  end
end
