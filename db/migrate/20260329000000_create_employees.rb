class CreateEmployees < ActiveRecord::Migration[8.0]
  def change
    create_table :employees do |t|
      t.string :full_name, null: false
      t.string :job_title, null: false
      t.string :country, null: false
      t.decimal :salary, precision: 12, scale: 2, null: false

      t.timestamps
    end
  end
end
