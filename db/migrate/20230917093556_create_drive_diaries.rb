class CreateDriveDiaries < ActiveRecord::Migration[6.1]
  def change
    create_table :drive_diaries do |t|
      t.integer :customer_id
      t.date :date
      t.text :body
      t.timestamps
    end
  end
end
