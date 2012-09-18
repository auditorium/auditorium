class AddChangeDefaultValueOfHtmlInEmailSettings < ActiveRecord::Migration
  def change
  	change_column_default :email_settings, :html_format, true
  end
end
