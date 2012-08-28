class ChangeStartTimeToMinuteOfDayInteger < ActiveRecord::Migration
  def change
    remove_column :periods, :start
    add_column :periods, :minute_of_day, :integer
  end
end
