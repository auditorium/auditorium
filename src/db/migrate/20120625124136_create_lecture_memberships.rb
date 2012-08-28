class CreateLectureMemberships < ActiveRecord::Migration
  def change
    create_table :lecture_memberships do |t|
      t.references :user
      t.references :lecture

      t.timestamps
    end
    add_index :lecture_memberships, :user_id
    add_index :lecture_memberships, :lecture_id
  end
end
