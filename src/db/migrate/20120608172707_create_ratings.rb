class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.references :user
      t.references :post

      t.timestamps
    end
    add_index :ratings, :user_id
    add_index :ratings, :post_id
  end
end
