class CreateCourseMemberships < ActiveRecord::Migration
  def change
    create_table :course_memberships do |t|
      t.references :user
      t.references :course
      t.string :type

      t.timestamps
    end
    add_index :course_memberships, :user_id
    add_index :course_memberships, :course_id
  end
end
