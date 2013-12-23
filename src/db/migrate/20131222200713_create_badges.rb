class CreateBadges < ActiveRecord::Migration
  def change
    create_table :badges do |t|
      t.string :category, default: 'bronze'
      t.integer :score, default: 25
      t.string :title
      t.references :user
      t.text :description

      t.timestamps
    end
  end
end
