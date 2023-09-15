class CreateKiloPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :kilo_posts do |t|
      t.integer :road_id
      t.float :latitude
      t.float :longitude
      t.timestamps
    end
  end
end
