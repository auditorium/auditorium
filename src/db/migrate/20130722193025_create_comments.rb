class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :author_id
      t.text :content
      t.integer :rating
      t.references :commentable, polymorphic: true

      t.timestamps
    end
    add_index :comments, :commentable_id
    add_index :comments, :commentable_type
  end
end
