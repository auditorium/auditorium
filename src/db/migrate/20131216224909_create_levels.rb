class CreateLevels < ActiveRecord::Migration
  def change
    create_table :levels do |t|
      t.integer :threshold
      t.integer :number
      t.references :user

      t.timestamps
    end
  end
end
