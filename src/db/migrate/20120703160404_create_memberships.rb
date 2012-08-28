class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :user
      t.references :memberable, :polymorphic => true
      t.string :memberable_type
      t.string :role

      t.timestamps
    end
    change_column :memberships, :role, :string, default: 'member'

    add_index :memberships, :user_id
  end
end
