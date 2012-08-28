class CreatePeriods < ActiveRecord::Migration
  def change
    create_table :periods do |t|
      t.string :weekday
      t.time :start
      t.integer :duration
      t.string :place

      t.timestamps
    end
  end
end
