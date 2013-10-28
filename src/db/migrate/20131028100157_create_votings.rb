class CreateVotings < ActiveRecord::Migration
  def change
    create_table :votings do |t|
      t.references :user
      t.integer :value
      t.references :votable, polymorphic: true

      t.timestamps
    end
    add_index :votings, :user_id
    add_index :votings, :votable_id
    add_index :votings, :votable_type
  end
end
