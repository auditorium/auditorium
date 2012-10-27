class ChangeEmailSettings < ActiveRecord::Migration
  def change
  	rename_column :email_settings, :html_format, :daily
  	change_column_default(:email_settings, :daily, true)
  end
end
