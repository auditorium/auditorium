class AddUrlToFaculty < ActiveRecord::Migration
  def change
    add_column :faculties, :url, :string
  end
end
