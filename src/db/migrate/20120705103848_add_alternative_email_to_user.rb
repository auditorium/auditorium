class AddAlternativeEmailToUser < ActiveRecord::Migration
  def change
    add_column :users, :alternative_email, :string
  end
end
