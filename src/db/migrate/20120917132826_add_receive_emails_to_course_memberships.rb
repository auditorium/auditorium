class AddReceiveEmailsToCourseMemberships < ActiveRecord::Migration
  def change
    add_column :course_memberships, :receive_emails, :boolean, :default => true
  end
end
