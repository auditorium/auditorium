class CreateTerms < ActiveRecord::Migration
  def change
    create_table :terms do |t|
      t.string :type
      t.date :begin
      t.date :end
      t.references :course

      t.timestamps
    end
    add_index :terms, :course_id
  end
end
