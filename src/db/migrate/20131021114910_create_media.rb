class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.text :content
      t.string :subject
      t.string :url
      t.integer :views
      t.boolean :is_private
      t.integer :author_id
      t.integer :group_id

      t.timestamps
    end
    add_index :media, :author_id
    add_index :media, :group_id
  end
end
