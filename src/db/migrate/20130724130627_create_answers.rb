class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|
      t.text :content
      t.integer :rating

      t.integer :question_id
      t.integer :author_id
      t.timestamps
    end
    add_index :answers, [:author_id, :question_id]
  end
end
