class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.references :reporter
      t.text :body
      t.boolean :read, :default => false
      t.references :post

      t.timestamps
    end
    add_index :reports, :reporter_id
  end
end
