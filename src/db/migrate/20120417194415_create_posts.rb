class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :subject
      t.text :body
      t.string :type
      t.references :child
      t.references :answer_to
      t.references :course

      t.timestamps
    end
    add_index :posts, :child_id
    add_index :posts, :answer_to_id
    add_index :posts, :course_id
  end
end
