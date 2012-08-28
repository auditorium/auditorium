class AddUrlToChair < ActiveRecord::Migration
  def change
    add_column :chairs, :url, :string
  end
end
