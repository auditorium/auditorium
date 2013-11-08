class AddAnswerToIdToAnswers < ActiveRecord::Migration
  def change
    add_column :answers, :answer_to_id, :integer
    add_index :answers, :answer_to_id
  end
end
