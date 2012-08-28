class AddUrlSwsCreditPointsAndDescriptionToLectures < ActiveRecord::Migration
  def change
    add_column :lectures, :url, :string, :default => ""
    add_column :lectures, :sws, :integer, :default => 0
    add_column :lectures, :creditpoints, :integer, :default => 0
    add_column :lectures, :description, :string, :default => ""
  end
end
