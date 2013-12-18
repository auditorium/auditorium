class AddScoreToBadges < ActiveRecord::Migration
  def change
    add_column :badges, :score, :integer, default: 0
  end
end
