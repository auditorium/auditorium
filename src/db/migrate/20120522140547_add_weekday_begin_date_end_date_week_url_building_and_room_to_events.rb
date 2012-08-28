class AddWeekdayBeginDateEndDateWeekUrlBuildingAndRoomToEvents < ActiveRecord::Migration
  def change
    add_column :events, :weekday, :integer
    add_column :events, :beginDate, :date
    add_column :events, :endDate, :date
    add_column :events, :week, :integer
    add_column :events, :url, :string, :default => ""
    add_column :events, :building, :string, :default => ""
    add_column :events, :room, :string, :default => ""
  end
end
