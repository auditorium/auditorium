class RemovePeriodsModel < ActiveRecord::Migration
  def change
    drop_table :periods
  end
end
