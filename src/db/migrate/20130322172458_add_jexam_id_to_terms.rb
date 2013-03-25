class AddJexamIdToTerms < ActiveRecord::Migration
  def change
  	add_column :terms, :jexam_id, :integer, default: 0
  end
end
