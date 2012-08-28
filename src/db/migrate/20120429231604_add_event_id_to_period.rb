class AddEventIdToPeriod < ActiveRecord::Migration
  def change
    add_column :periods, :event_id, :integer
    add_index :periods, :event_id
  end
end
