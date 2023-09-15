class CreateRoads < ActiveRecord::Migration[6.1]
  def change
    create_table :roads do |t|
      t.integer :category, default: 0
      t.integer :number
      t.text :infomation
      t.timestamps
    end
  end
end
