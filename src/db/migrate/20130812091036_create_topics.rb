class CreateTopics < ActiveRecord::Migration
  def change
    create_table :topics do |t|
      t.string :subject
      t.string :content
      t.integer :rating
      t.integer :views
      t.boolean :private

      t.timestamps
    end
  end
end
