class CreateTutorialProgresses < ActiveRecord::Migration
  def change
    create_table :tutorial_progresses do |t|
      t.boolean :introduction, default: false
      t.boolean :groups, default: false
      t.boolean :group, default: false
      t.boolean :question, default: false
      t.references :user

      t.timestamps
    end

    add_index :tutorial_progresses, :user_id
  end
end
