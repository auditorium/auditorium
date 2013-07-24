class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.string :subject
      t.text :content
      t.integer :rating
      t.integer :views

      t.boolean :is_private

      t.integer :author_id
      t.integer :group_id
      t.timestamps
    end
    add_index :questions, [:author_id, :group_id]
  end
end
