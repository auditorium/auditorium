class ChangeBeginAndEndToBeNoKeywords < ActiveRecord::Migration
  def change
    rename_column :terms, :begin, :beginDate
    rename_column :terms, :end, :endDate
  end
end
