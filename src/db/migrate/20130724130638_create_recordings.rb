class CreateRecordings < ActiveRecord::Migration
  def change
    create_table :recordings do |t|
      t.string :subject
      t.text :content
      t.integer :rating
      t.integer :views
      t.string :url

      t.boolean :is_private

      t.integer :author_id
      t.integer :group_id
      t.timestamps
    end
    add_index :recordings, [:author_id, :group_id]
  end
end
