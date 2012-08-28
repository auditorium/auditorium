class ChangeTypeToEventTypeInEvents < ActiveRecord::Migration
  def change
    rename_column :events, :type, :event_type
  end
end
