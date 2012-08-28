class ChangeTypeToTermTypeInTerms < ActiveRecord::Migration
  def change
    rename_column :terms, :type, :term_type
  end
end
