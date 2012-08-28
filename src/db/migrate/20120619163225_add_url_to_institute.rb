class AddUrlToInstitute < ActiveRecord::Migration
  def change
    add_column :institutes, :url, :string
  end
end
