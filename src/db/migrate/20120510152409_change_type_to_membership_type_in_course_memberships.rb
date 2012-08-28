class ChangeTypeToMembershipTypeInCourseMemberships < ActiveRecord::Migration
  def change
    rename_column :course_memberships, :type, :membership_type
  end
end
