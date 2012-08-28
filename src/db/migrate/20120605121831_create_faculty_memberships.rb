class CreateFacultyMemberships < ActiveRecord::Migration
  def change
    create_table :faculty_memberships do |t|
      t.references :user
      t.references :faculty
      t.string :membership_type, :default => 'student'

      t.timestamps
    end
    add_index :faculty_memberships, :user_id
    add_index :faculty_memberships, :faculty_id
  end
end
